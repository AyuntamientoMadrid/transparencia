# transparencia

Bienvenidos al repositorio de la nueva página de transparencia de Madrid.rb

## Configuración para desarrollo y tests

Prerequisitos: git, Ruby 2.2.3, la gema bundler y PostgreSQL (9.4 o superior).

```
git clone https://github.com/AyuntamientoMadrid/transparencia.git
cd transparencia
bundle install
cp config/secrets.yml.example config/secrets.yml
cp config/database.yml.example config/database.yml
bin/rake db:setup
RAILS_ENV=test bin/rake db:setup
```

Para ejecutar la aplicación en local:

```
bin/rails s
```

Para ejecutar los tests:

```
bin/rspec
```

## Organización

En estos momentos se está realizando un hackathon. Los desarrollos de esta página están centrados en las issues:

https://github.com/AyuntamientoMadrid/transparencia/issues

Si te interesa trabajar o contribuir en alguna, añade un comentario.

También puedes contactar a alguno de los responsables técnicos:

* Raimon García ([@voodoorai2000](https://twitter.com/voodoorai2000))
* Enrique García ([@otikik](https://twitter.com/otikik))
* Juanjo Bazán ([@xuanxu](https://twitter.com/xuanxu))
* Alberto García ([@decabeza](https://twitter.com/decabeza))



