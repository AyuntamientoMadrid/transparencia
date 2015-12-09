module Importers
  class ProfilesImporter < BaseImporter

    def import!
      each_row(col_sep: ";") do |row|
        person = Person.find_or_initialize_by(personal_code: row[:n_personal])

        if person.new_record? then
          person.name = "#{row[:nombre]} #{row[:apellidos]}"
          person.role = row[:cargo]
        end

        profiled_at = DateTime.parse(row[:fecha])
        if person.profiled_at.blank? || person.profiled_at < profiled_at

          person.profiled_at = profiled_at

          puts "Importing profile for #{person.name}"

          person.twitter  = row[:cuenta_de_twitter]
          person.facebook = row[:cuenta_de_facebook]
          person.unit     = row[:unidad]

          party = Party.find_by(long_name: person.unit)
          person.party = party if party.present?

          parse_studies(person, row)
          parse_courses(person, row)
          parse_languages(person, row)
          parse_career(person, row)
          parse_political_posts(person, row)

          person.publications       = row[:publicaciones]
          person.teaching_activity  = row[:actividad]
          person.special_mentions   = row[:distinciones]
          person.other              = row[:otra_informacion]

          person.save
        end
      end
    end

    private

      def parse_studies(person, row)
        person.profile['studies'] = []
        (1..4).each do |index|
          col = row.index("#{index}_titulacion_oficial".to_sym)
          person.add_study(row[col], row[col+1], row[col+2], row[col+3])
        end
        studies_comment_col = row.index(:"4_titulacion_oficial")+4
        person.studies_comment = row[studies_comment_col]
      end

      def parse_courses(person, row)
        person.profile['courses'] = []
        (1..4).each do |index|
          col = row.index("#{index}_nombre_del_curso".to_sym)
          person.add_course(row[col], row[col+1], row[col+2], row[col+3])
        end
        courses_comment_col = row.index(:"4_nombre_del_curso")+4
        person.courses_comment = row[courses_comment_col]
      end

      def parse_languages(person, row)
        person.profile['languages'] = []
        person.add_language('Inglés',   row[:ingles])   if row[:ingles].present?
        person.add_language('Francés',  row[:frances])  if row[:frances].present?
        person.add_language('Alemán',   row[:aleman])   if row[:aleman].present?
        person.add_language('Italiano', row[:italiano]) if row[:italiano].present?

        person.add_language(row[:otro_idioma], row[:nivel_otro_idioma])
      end

      def parse_career(person, row)
        person.profile['public_jobs'] = []
        (1..4).each do |index|
          col = row.index("#{index}_puesto_desempenado".to_sym)
          person.add_public_job(row[col], row[col+1], row[col+2], row[col+3])
        end

        person.profile['private_jobs'] = []
        (1..4).each do |index|
          col = row.index("#{index}_cargoactividad".to_sym)
          person.add_private_job(row[col], row[col+1], row[col+2], row[col+3])
        end

        career_comment_col = row.index(:"4_cargoactividad")+4
        person.political_posts_comment = row[career_comment_col]
      end

      def parse_political_posts(person, row)
        person.profile['political_posts'] = []
        (1..4).each do |index|
          col = row.index("#{index}_cargo".to_sym)
          person.add_political_post(row[col], row[col+1], row[col+2], row[col+3])
        end
        political_posts_comment_col = row.index(:"4_cargo")+4
        person.political_posts_comment = row[political_posts_comment_col]
      end


  end
end