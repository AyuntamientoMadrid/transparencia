require 'excel_importers/base'

module ExcelImporters
  class Profile < Base
    JOB_LEVEL_CODES = {
      'ASESOR/A N24' => 'temporary_worker',
      'ASESOR/A N26' => 'temporary_worker',
      'ASESOR/A N28' => 'temporary_worker',
      'DIRECTOR/A DE GABINETE' => 'temporary_worker',
      'VOCAL ASESOR/A' => 'temporary_worker',
      'VOCAL ASESOR' => 'temporary_worker',
      'ADMINISTRATIVO/A' => 'temporary_worker',
      'APOYO A LA SECRETARIA ALCALDIA' => 'temporary_worker',
      'JEFE/A DE SECRETARÍA' => 'temporary_worker',
      'JEFE/A DE SECRETARIA' => 'temporary_worker',

      'COORDINADOR GENERAL' => 'director',
      'COORDINADOR/A GENERAL' => 'director',
      'COORDINADOR/A DE DISTRITO' => 'director',
      'DIRECTOR GENERAL' => 'director',
      'DIRECTOR/A GENERAL' => 'director',
      'DIRECTOR OOAA. AGENCIA TRIBUTARIA' => 'director',
      'DIRECTOR/A OOAA. AGENCIA TRIBUTARIA' => 'director',
      'DIRECTOR/A OFICINA' => 'director',
      'GERENTE AGENCIA DE ACTIVIDADES' => 'director',
      'GERENTE/A ORGANISMO AUTONOMO' => 'director',
      'GERENTE/A ORGANISMO AUTÓNOMO' => 'director',
      'GERENTE DE LA CIUDAD' => 'director',
      'GERENTE/A CIUDAD' => 'director',
      'GERENTE DISTRITO' => 'director',
      'GERENTE/A DISTRITO' => 'director',
      'GERENTE ORGANISMO AUTONOMO' => 'director',
      'PENDIENTE ADSCRIPCION' => 'director',
      'PRESIDENTE TRIBUNAL' => 'director',
      'PRESIDENTE/A TRIBUNAL' => 'director',
      'SECRETARIO GENERAL PLENO' => 'director',
      'SECRETARIO GENERAL TEAMM' => 'director',
      'SECRETARIO/A GENERAL TEAMM' => 'director',
      'SECRETARIO GENERAL TECNICO' => 'director',
      'SECRETARIO/A GENERAL TÉCNICO/A' => 'director',
      'SECRETARIO/A SERVICIOS COMUNES' => 'director',
      'VOCAL DEL TRIBUNAL' => 'director',

      'ALCALDE/SA' => 'councillor',
      'CONCEJAL DE GOBIERNO' => 'councillor',
      'CONCEJAL/A DE GOBIERNO' => 'councillor',
      'CONCEJAL SIN RESPONS. DE GESTION PUBLICA' => 'councillor',
      'CONCEJAL/A SIN RESPONS. DE GESTION PUBLI' => 'councillor',
      'CONCEJAL PRESIDENTE DE DISTRITO' => 'councillor',
      'CONCEJAL/A PRES DISTRITO/ 3º TTE ALCADIA' => 'councillor',
      'PORTAVOZ GRUPO POLITICO' => 'councillor',
      'PRIMER TENIENTE DE ALCALDE' => 'councillor',
      'PRIMER/A TENIENTE DE ALCALDIA' => 'councillor'
    }.freeze

    def import!
      each_row do |row|
        person_query = Person.where(personal_code: row[:n_personal])
        job_level = JOB_LEVEL_CODES.fetch(row[:cargo])

        if job_level == 'councillor'
          person = person_query.first!
        else
          person = person_query.first_or_initialize
          person.first_name = row[:nombre]
          person.last_name = row[:apellidos]
          person.admin_first_name = transliterate(row[:nombre])
          person.admin_last_name = transliterate(row[:apellidos])
          person.role = row[:cargo]
          person.job_level = job_level
        end

        profiled_at = row[:fecha]

        if person.profiled_at.blank? || person.profiled_at < profiled_at

          person.profiled_at = profiled_at

          puts "Importing profile for #{person.name}"

          person.twitter  = row[:cuenta_de_twitter]
          person.facebook = row[:cuenta_de_facebook]
          person.unit     = row[:unidad]

          parse_studies(person, row)
          parse_courses(person, row)
          parse_languages(person, row)
          parse_career(person, row)
          parse_political_posts(person, row)

          person.publications       = row[:publicaciones]
          person.teaching_activity  = row[:actividad]
          person.special_mentions   = row[:distinciones]
          person.other              = row[:otra_informacion]

          person.save!
        end
      end
    end

    private

      def parse_studies(person, row)
        person.profile['studies'] = []
        (1..4).each do |studies_index|
          col = index("#{studies_index}_titulacion_oficial".to_sym)
          person.add_study(row[col], row[col+1], row[col+2], row[col+3])
        end
        studies_comment_col = index(:"4_titulacion_oficial")+4
        person.studies_comment = row[studies_comment_col]
      end

      def parse_courses(person, row)
        person.profile['courses'] = []
        (1..4).each do |course_index|
          col = index("#{course_index}_nombre_del_curso".to_sym)
          person.add_course(row[col], row[col+1], row[col+2], row[col+3])
        end
        courses_comment_col = index(:"4_nombre_del_curso")+4
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
        (1..4).each do |public_job_index|
          col = index("#{public_job_index}_puesto_desempenado".to_sym)
          person.add_public_job(row[col], row[col+1], row[col+2], row[col+3])
        end

        person.profile['private_jobs'] = []
        (1..4).each do |private_job_index|
          col = index("#{private_job_index}_cargo_actividad".to_sym)
          person.add_private_job(row[col], row[col+1], row[col+2], row[col+3])
        end

        career_comment_col = index(:"4_cargo_actividad")+4
        person.career_comment = row[career_comment_col]

        person.public_jobs_level      = row[:grado_consolidado]
        person.public_jobs_body       = row[:cuerpo_o_escala_de_la_administracion]
        person.public_jobs_start_year = row[:ano_de_ingreso]
      end

      def parse_political_posts(person, row)
        person.profile['political_posts'] = []
        (1..4).each do |post_index|
          col = index("#{post_index}_cargo".to_sym)
          person.add_political_post(row[col], row[col+1], row[col+2], row[col+3])
        end
        political_posts_comment_col = index(:"4_cargo")+4
        person.political_posts_comment = row[political_posts_comment_col]
      end
  end
end
