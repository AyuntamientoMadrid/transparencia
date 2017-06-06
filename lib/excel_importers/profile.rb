require 'excel_importers/base'

module ExcelImporters
  class Profile < Base

    COUNCILLOR_JOB_LEVEL_CODES = %w(alcalde-sa concejal-de-gobierno concejal-presidente-de-distrito concejal-sin-respons-de-gestion-publica concejal-a-de-gobierno concejal-a-pres-distrito-3-tte-alcadia concejal-a-sin-respons-de-gestion-publi portavoz-grupo-politico primer-teniente-de-alcalde primer-a-teniente-de-alcaldia).freeze
    TEMP_WORKER_JOB_LEVEL_CODES = %w(administrativo-a apoyo-a-la-secretaria-alcaldia asesor-a-n24 asesor-a-n26 asesor-a-n28 director-a-de-gabinete jefe-a-de-secretaria vocal-asesor vocal-asesor-a).freeze

    JOB_LEVEL_CODES = Hash.new('director')
                          .merge(Hash[COUNCILLOR_JOB_LEVEL_CODES.map{|c| [c, 'councillor']}])
                          .merge(Hash[TEMP_WORKER_JOB_LEVEL_CODES.map{|c| [c, 'temporary_worker']}])
                          .freeze
    def import
      @imported = 0
      @updated = 0
      @skipped = 0

      successful = super

      unless successful
        @imported = 0
        @updated = 0
      end

      logger.info ''
      logger.info I18n.t('excel_importers.profile.summary')
      logger.info I18n.t('excel_importers.profile.imported', count: @imported)
      logger.info I18n.t('excel_importers.profile.updated', count: @updated)
      logger.info I18n.t('excel_importers.profile.skipped', count: @skipped)

      successful
    end

    def import_row!(row)
      person_query = Person.where(personal_code: row[:n_personal])
      job_level = JOB_LEVEL_CODES[row[:cargo].parameterize]

      if job_level == 'councillor'
        person = person_query.first!
      else
        person = person_query.first_or_initialize
        person.first_name = row[:nombre]
        person.last_name = row[:apellidos]
        person.admin_first_name = transliterate(row[:nombre])
        person.admin_last_name = transliterate(row[:apellidos])
        person.role = row[:cargo] unless person.role.present?
        person.job_level = job_level
      end

      profiled_at = parse_profiled_at(row[:fecha]).in_time_zone

      if person.profiled_at.blank? || person.profiled_at < profiled_at

        if person.profiled_at.blank?
          @imported += 1
          logger.info I18n.t('excel_importers.profile.importing',
                             person: person.name)
        else
          @updated += 1
          logger.info I18n.t('excel_importers.profile.updating',
                             person: person.name,
                             reference: row[:referencia],
                             person_profiled_at: person.profiled_at.iso8601,
                             file_profiled_at: profiled_at.iso8601)
        end

        person.profiled_at = profiled_at

        person.twitter  = row[:cuenta_de_twitter]
        person.facebook = row[:cuenta_de_facebook]
        person.unit     = row[:unidad] unless person.unit.present?

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
      else
        @skipped += 1
        logger.info I18n.t('excel_importers.profile.skipping',
                           person: person.name,
                           reference: row[:referencia],
                           person_profiled_at: person.profiled_at.iso8601,
                           file_profiled_at: profiled_at.iso8601)
      end
    end

    private

      def parse_profiled_at(profiled_at)
        return profiled_at if profiled_at.respond_to?(:year)
        profiled_at = DateTime.strptime(profiled_at, '%d/%m/%y %H:%M:%S')
        profiled_at
      end

      def parse_studies(person, row)
        person.profile['studies'] = []
        (1..4).each do |studies_index|
          col = index("#{studies_index}_titulacion_oficial".to_sym)
          person.add_study(row[col], row[col+1], row[col+2], row[col+3])
        end
        studies_comment_col = index(:"4_titulacion_oficial")+5
        person.studies_comment = row[studies_comment_col]
      end

      def parse_courses(person, row)
        person.profile['courses'] = []
        (1..4).each do |course_index|
          col = index("#{course_index}_nombre_del_curso".to_sym)
          person.add_course(row[col], row[col+1], row[col+2], row[col+3])
        end
        courses_comment_col = index(:"4_nombre_del_curso")+5
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

        career_comment_col = index(:"4_cargo_actividad") + 5
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
        political_posts_comment_col = index(:"4_cargo")+5
        person.political_posts_comment = row[political_posts_comment_col]
      end
  end
end
