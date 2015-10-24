#Area de Gobierno
areas = 
[
  { name: "Equidad, Derechos Sociales y Empleo" }, 
  { name: "Coordinación Territorial y Asociaciones" }, 
  { name: "Portavoz, Coordinación Junta de Gobierno y Relaciones con el Pleno" }, 
  { name: "Economía y Hacienda" }, 
  { name: "Salud, Seguridad y Emergencias" }, 
  { name: "Participación Ciudadana, Transparencia y Gobierno Abierto" }, 
  { name: "Desarrollo Urbano Sostenible" }, 
  { name: "Medio Ambiente y Movilidad" }, 
  { name: "Cultura y Deportes" }
]
areas.each do |area|
  Area.find_or_create_by(area)
end

#Dirección general, organismos, consorcios, empresas
departments =
[
  { name: "Dirección General de Transparencia",
    area: Area.find_by(name: "Participación Ciudadana, Transparencia y Gobierno Abierto" ),
    description: "El Ayuntamiento de Madrid a través del Área de Gobierno de Participación Ciudadana, Transparencia y Gobierno Abierto se ha marcado como objetivo para los próximos cuatro años poner a la ciudad de Madrid al frente de las ciudades más avanzadas en transparencia. Para conseguirlo se ha trazado un plan que incluye la adopción e implementación de una batería de medidas en materia de transparencia. 
Todas estas medidas irán encabezadas por la aprobación de una Ordenanza de Transparencia que sea ambiciosa, superando los mínimos legales y permitiendo acceder a la información sobre toda la actividad que desarrolla el Ayuntamiento de Madrid. Esta ordenanza desarrollará el derecho de acceso a la información que ha sido reconocido internacionalmente como un derecho fundamental, esencial para asegurar la participación ciudadana y elemento básico en la lucha contra la corrupción. Se va a facilitar a la ciudadanía un procedimiento que garantice que pueda ejercer este derecho de acceso a la información pública de forma fácil y ágil. 
Además se proporcionará toda la información de la trazabilidad de las decisiones públicas abriendo los procesos de decisión desde las reuniones iniciales, publicando la agenda de los responsables públicos y regulando el registro de Lobby del Ayuntamiento de Madrid.
Se van a desarrollar nuevos Portales de Transparencia y Datos Abiertos que proporcionarán información más completa y de forma más accesible y que se integrarán en el Portal de Gobierno Abierto del Ayuntamiento de Madrid.
La administración electrónica es base fundamental para hacer posible la transparencia y la participación, de tal forma que se aprovechen los canales de comunicación y difusión y se incorpore a los ciudadanos y empresas en el diseño y mejora de los servicios. Se desarrollará un plan de administración electrónica que facilite el acceso de los ciudadanos a la administración municipal con el objetivo de cambiar las formas de trabajo mejorando la productividad y ahorrando costes de gestión. 
Se garantizará la protección de los datos personales en el desarrollo de las políticas de transparencia con especial interés en los métodos para anonimizar los datos. Se desarrollará un Plan de protección de datos personales para asegurar la confidencialidad de la información de carácter personal de los ciudadanos que se relacionan con el Ayuntamiento de Madrid. 
Se ofrecerá un servicio eficaz que facilite a la ciudadanía el ejercicio del derecho a presentar sugerencias, reclamaciones y avisos sobre deficiencias en los servicios prestados con el objetivo de, con su colaboración, mejorar la gestión municipal.",
	directives: "<ol><li>Situar a la Ciudad de Madrid a la cabeza en materia de transparencia aprobando medidas que aseguren la apertura de datos y su reutilización.</li><li>Asegurar la trazabilidad de las decisiones públicas abriendo los procesos de decisión desde las reuniones iniciales.</li><li>Garantizar la protección de los datos personales de la ciudadanía en su relación con el Ayuntamiento y específicamente en el desarrollo de las políticas de transparencia con especial interés en los métodos de anonimización de datos.</li><li>Facilitar el acceso de la ciudadanía a los servicios municipales potenciando la gestión electrónica como elemento fundamental de transparencia.</li><li>Impulsar un sistema unificado que facilite a la colaboración ciudadana en la gestión municipal presentando avisos, sugerencias y reclamaciones.</li></ol>"	
  },    
  { name: "Dirección General de Participación Ciudadana",
    area: Area.find_by(name: "Participación Ciudadana, Transparencia y Gobierno Abierto" ),
    description: "La participación ciudadana en la adopción de decisiones públicas ha sido uno de los ejes del programa con el que se presentó Ahora Madrid a las elecciones municipales.
Se trata de que individualmente los ciudadanos puedan hacer propuestas en el ámbito de las competencias del ayuntamiento, de que sus conciudadanos puedan apoyar esas propuestas, y de que si estas obtienen los apoyos necesarios sean llevadas a la práctica.
También se trata de que una parte significativa de las decisiones de Gobierno sea sometida a consulta de la ciudadanía; lo que incluye, entre otros, temas tales como transporte público, sostenibilidad, o líneas estratégicas de urbanismo; decisión sobre el gasto que se va a hacer con una parte del presupuesto; el contenido que deben tener determinadas normativas; o prioridades de actuación municipal.
Por otra parte, se incentivará la participación ciudadana en aspectos relativos al voluntariado; se pretende que el número de voluntarios (que actualmente asciende a 10 000) se incremente todo los años, así como el tipo de actividades en las que colaboran, y que el voluntariado se integre como un elemento más que caracterice el ejercicio responsable de la ciudadanía.",
	directives: "<ol><li>Que los ciudadanos puedan hacer propuestas, que sus conciudadanos puedan apoyar esas propuestas, y que si estas tienen el apoyo necesario sean llevadas a la práctica por el Gobierno Municipal.</li><li>Que una parte significativa de las decisiones de Gobierno sea sometida a consulta de la ciudadanía.</li><li>Implicar a la ciudadanía en los asuntos públicos, al objeto de su participación voluntaria y altruista en diversas tareas de carácter social.</li><li>Crear nuevas fórmulas de innovación social que puedan implantarse en la organización municipal para la mejora de los servicios públicos o la organización social.</li></ol>"
  }
]
departments.each do |department|
  Department.find_or_create_by(department)
end

#Acciones Clave
objectives =
[
  { title: "Aprobación de una ordenanza de transparencia",
  	description: "Este ayuntamiento cree en la transparencia como medio para conseguir objetivos claves para el desarrollo de la democracia. En la práctica, el derecho de acceso a la información tiene un efecto disuasorio y preventivo sobre la corrupción. Además tiene un impacto directo sobre los derechos democráticos más esenciales como es el derecho a la participación, desde su concepción más básica como es votar en las elecciones, el derecho a una prensa libre e independiente o sobre todo nuestro derecho a obtener o a exigir una rendición de cuentas completa de lo público.
El Ayuntamiento de Madrid se propone aprobar una norma de transparencia que incluya los principios más avanzados en esta materia y que incluya la obligación de las instituciones públicas hacer pública, reactiva o proactivamente, toda la información, registrada, archivada, elaborada, recibida o en posesión de las autoridades públicas sea cual sea el formato. Se trata de explicar todo lo que afecte a una decisión sobre lo público: qué se hace, quién lo hace, por qué se hace, cómo se hace y cuánto cuesta. Además esta información debe ser publicada en formatos abiertos que la hagan más accesible y reutilizable por cualquiera.",
    order: 1,
    accomplished: true,
    department: Department.find_by(name:"Dirección General de Transparencia")
  },  
  { title: "Desarrollo de un nuevo Portal de Transparencia",
  	description: "En cumplimiento de la Ley 19/2013 de Transparencia, Acceso a la Información y Buen Gobierno, y de su futura implementación en una Ordenanza Municipal en Madrid, el Ayuntamiento de Madrid plantea el desarrollo y mejora de un nuevo Portal de Transparencia. El Ayuntamiento no se limitará a cumplir con las obligaciones que se adquieran cuando entre en vigor la ley 19/2013 sino que aprobará mediante su Ordenanza las obligaciones y derechos que posibiliten la publicación de una lista de información más ambiciosa que debe encontrarse en el Portal de Transparencia...
Para conseguir elaborar esta lista se contará con la ayuda de los propios trabajadores del Ayuntamiento que serán consultados a través de la intranet y de los ciudadanos que podrán aportar ideas sobre qué tipo de información creen que debería encontrase en el portal. Por último esta información se irá completando con los datos que los ciudadanos vayan solicitando a través de sus solicitudes de acceso a la información. 
El objetivo de esta mejora es no solo la publicación de un mayor volumen de información sino también la publicación de esta información en formatos que la hagan más accesible y fácil de entender para los ciudadanos.",
    order: 2,
    accomplished: false,
    department: Department.find_by(name:"Dirección General de Transparencia")
  },  
  { title: "Desarrollo de un nuevo Portal de Datos Abiertos",
  	description: "El Ayuntamiento tiene como objetivo compartir todos los datos que tienen en su poder en formatos abiertos y fomentar su reutilización por parte de la sociedad. El objetivo por tanto es doble, por un lado se trabajará en el desarrollo de una nuevo Portal de Datos Abiertos aumentando la cantidad y la calidad en la publicación de datos, y por otro lado se abrirán canales de colaboración para promover las aplicaciones y los usos que resulten de la reutilización de los datos.",
    order: 3,
    accomplished: false,
    department: Department.find_by(name:"Dirección General de Transparencia")
  },  
  { title: "Transparencia de la contratación y subvenciones públicas",
  	description: "Cada día Gobiernos de todo el mundo dedican más de 26 millones de dólares de dinero público a contratos con entidades privadas. Si bien esto es a priori un problema, sí se ha detectado que existe una falta de transparencia generalizada a la hora de decidir cómo se otorgan estos contratos o ha provocado irregularidades en las contrataciones.
En España la publicidad que se hace de los contratos se limita en muchas ocasiones a publicar información sobre los pliegos del contrato y el adjudicatario final del mismo y su oferta. Sin embargo esto hoy en día se considera insuficiente ya que para que pueda existir realmente una rendición de cuentas es necesario poder comprobar si de todas las ofertas que se recibieron para una concurso público se eligió la más adecuada. Por eso desde el Ayuntamiento de Madrid se propone crear una web donde poder encontrar todos los detalles que afectan a la contratación pública  desde los pliegos y condiciones de contratación, las ofertas que se presentan a cada concurso, los criterios de selección hasta la decisión final, superando las funcionalidades, información y forma de acceso del actual Perfil del contratante.
A través de la sede electrónica se puede realizar un seguimiento muy vinculado a su solicitud (Gestiones y Trámites - Ayudas y subvenciones) de las subvenciones y ayudas públicas convocadas por el Ayuntamiento de Madrid. Sin embargo no existe información centralizada de las subvenciones concedidas incluyendo las bases reguladoras, convocatoria, programa y crédito presupuestario al que se imputan, objeto o finalidad de la subvención, identificación de los beneficiarios, e importe de las subvenciones otorgadas. Se elaborará un nuevo espacio que facilite el acceso a toda esta información de las subvenciones y ayudas municipales. Estos nuevos espacios que se van a crear incluirá toda la información en formatos reutilizables e incluirá un buscador que permita encontrar información por diferentes criterios.",
    order: 4,
    accomplished: false,
    department: Department.find_by(name:"Dirección General de Transparencia")
  },  
  { title: "Sistema único de gestión de licencias municipales",
  	description: "El objetivo en este ámbito debe ser utilizar la transparencia tanto para que la ciudadanía pueda conocer y valorar la actividad municipal, como acercarse a los agentes de desarrollo y actividad para potenciar el desarrollo económico al mismo tiempo que se facilita la obtención de las licencias, con un sistema de gestión único para todo el ámbito municipal, de fácil comprensión externa.
Las licencias del Ayuntamiento, fundamentalmente las urbanísticas y de actividad, son procesos complejos por la conjunción de derechos a proteger y potenciar, por la normativa aplicable y el gran número de especialidades técnicas, ámbitos de competencias y órganos de aprobación que intervienen. Todo ello provoca un gran trabajo de gestión y una visión de estos procesos como obstáculos para la actividad y desarrollo de la vida de la ciudad.",
    order: 5,
    accomplished: true,
    department: Department.find_by(name:"Dirección General de Transparencia")
  },  
  { title: "Agendas públicas",
  	description: "En el moderno proceso de toma de decisiones por los responsables políticos, la publicación de las agendas de los cargos públicos es una medida fundamental para garantizar la transparencia de las instituciones. De esta forma, la ciudadanía puede tener una idea clara de quiénes participan en el proceso de toma de decisiones. 
Esta necesidad de publicidad viene refrendada por destacados organismos internacionales, como el Grupo de Estados Contra la Corrupción del Consejo de Europa (GRECO), que la señala como uno de los estándares internacionales a tener en cuenta para incorporar al sistema parlamentario español; o la Organización para la Cooperación y el Desarrollo Económico (OCDE) que, en junio de 2013, destacaba que “en el despertar de una crisis global donde la protección del interés público ha sido cuestionada de forma mundial, hay una creciente necesidad de valorar el progreso alcanzado para garantizar un proceso de toma de decisiones abierto, balanceado y con un público informado”.
En línea con este espíritu de apertura, y con la decidida voluntad de que exista fluidez en la información, se considera necesario hacer públicas las agendas de los Concejales como inicio de una política de transparencia y rendición de cuentas en el Ayuntamiento de Madrid, de forma que sea posible saber qué trabajo realizan los miembros del gobierno municipal y qué colectivos o circunstancias pueden tener repercusión en las decisiones que se toman.",
    order: 6,
    accomplished: true,
    department: Department.find_by(name:"Dirección General de Transparencia")
  },  
  { title: "Transparencia del Lobby",
  	description: "Con el objetivo de hacer el proceso de toma de decisiones del Ayuntamiento de Madrid un proceso lo más transparente posible, se propone la creación de un registro de lobbies que obligue a todas las personas que quieran reunirse con el Gobierno para ejercer influencia sobre los asuntos públicos a estar registrada en el mismo. El objetivo de este registro es conocer qué intereses representan las personas que se reúnen con los representantes públicos.
La implementación de este registro se hará en dos pasos, en primer lugar se creará el registro y tendrá carácter voluntario pero el Gobierno se comprometerá formalmente a no mantener reuniones con aquellos que nos estén inscritos; en segundo lugar y en paralelo a la primera medida se trabajará en la adopción de una norma que haga obligatoria la inscripción en el Registro para mantener reuniones con todos los miembros del Gobierno y con todos los concejales.",
    order: 7,
    accomplished: true,
    department: Department.find_by(name:"Dirección General de Transparencia")
  },  
  { title: "Plan de protección de datos personales",
  	description: "Se desarrollará el plan de protección de datos personales para garantizar la confidencialidad de la información de carácter personal de los ciudadanos que se relacionan con el Ayuntamiento de Madrid. En el desarrollo de las políticas de transparencia se garantizará la protección de los datos personales trabajando en especial los métodos para anonimizar los datos.
Esta actuación se concreta en acciones en materia de transparencia y datos abiertos (análisis de impacto en la disociación de datos, consultas sobre publicación activa, protección de datos y en relación con el acceso a la información pública). También se mejorará la regulación en materia de protección de datos unificando las normas internas existentes. 
Se realizará un plan específico de seguridad en datos personales:
Aprobación de normas internas de implantación de medidas de seguridad 
Realización de auditorías de seguridad LOPD
Formación en la elaboración de los documentos y guías de seguridad internos y autoevaluaciones de seguridad.",
    order: 8,
    accomplished: true,
    department: Department.find_by(name:"Dirección General de Transparencia")
  },  
  { title: "Plan de administración electrónica",
  	description: "Con el objetivo de potenciar la administración electrónica en el Ayuntamiento de Madrid se elaborará un plan de actuación para todo el mandato, cuyo objetivo es que el 90% de la tramitación administrativa sea electrónica, lo que hará posible la transparencia activa y el acceso a la información directamente por los ciudadanos. Esta actuación global se desagrega en:
Nueva Sede Electrónica
Nuevo Registro del Ayuntamiento de Madrid
Implantación de un gestor de expedientes interno
Implantación de las notificaciones electrónicas
Desarrollo del sistema de gestión documental
Mejora de la carpeta de los ciudadanos y creación de la carpeta de la empresa
Establecimiento de un soporte y ayuda en línea para los ciudadanos
Revisión de los procedimientos y servicios
Adaptación a las modificaciones normativas estatales mediante la regulación de la atención electrónica a los ciudadanos",
    order: 9,
    accomplished: true,
    department: Department.find_by(name:"Dirección General de Transparencia")
  },  
  { title: "Sistema unificado de avisos, sugerencias y reclamaciones",
  	description: "Con el objetivo de facilitar la colaboración ciudadana en la gestión municipal se implantará un sistema unificado de gestión de los avisos, sugerencias y reclamaciones. Se desarrollarán nuevas funcionalidades en la interacción con el ciudadano: información proactiva de otras reclamaciones presentadas sobre la misma materia, en la misma zona geográfica, con visualización en mapa, incorporación de herramientas sociales (posibilidad de votar, adherirse a otras reclamaciones o avisos, hacer comentarios o anotar como favorito para hacer seguimiento). Además se facilitará la transparencia de los avisos y de las reclamaciones con información en formato abierto. 
Se elaborará un barómetro a través de los datos procedentes de los avisos y las reclamaciones ciudadanas que permita tener una información de ciudad para facilitar la toma de decisiones, la mejora en la gestión de los servicios públicos y la transparencia.",
    order: 10,
    accomplished: true,
    department: Department.find_by(name:"Dirección General de Transparencia")
  },  
  { title: "Propuestas Ciudadanas",
    description: "Se establecerá un sistema para que cualquier persona pueda presentar propuestas, y que éstas se concreten en una iniciativa política aprobada por el Ayuntamiento si consiguen el apoyo suficiente de la ciudadanía. 
Las propuestas se presentarán en el Portal de Gobierno Abierto, ya sea directamente a través de la web, o presencialmente a través de cualquiera de las Oficinas de Atención al Ciudadano",
    order: 1,
    accomplished: true,
    department: Department.find_by(name:"Dirección General de Participación Ciudadana")
  },  
  { title: "Consulta Ciudadana de actuaciones gubernamentales.",
    description: "Creación de un sistema de participación ciudadana basado principalmente en Internet, pero que también admita la participación presencial y la accesibilidad universal, para que una parte significativa de las decisiones de Gobierno sea sometida a consulta de la ciudadanía.
Se gestionará este procedimiento al amparo del artículo 23 del Reglamento de participación Ciudadana y se establecerá contacto sistemático con las distintas áreas de Gobierno para que puedan someterse a la ciudadanía las decisiones más significativas de su actuación política.",
    order: 2,
    accomplished: true,
    department: Department.find_by(name:"Dirección General de Participación Ciudadana")
  },  
  { title: "Presupuestos Participativos",
    description: "Parte del presupuesto municipal será gestionado mediante presupuestos participativos por la ciudadanía de manera directa, a través de una sección específica de la plataforma de Gobierno Abierto. Dicha sección no sólo está destinada a la mera gestión sino a mostrar y corresponsabilizar a los habitantes de los distritos de las inversiones y necesidades en sus entornos de proximidad, y a la ciudadanía en general del uso de los recursos públicos.",
    order: 3,
    accomplished: true,
    department: Department.find_by(name:"Dirección General de Participación Ciudadana")
  },  
  { title: "Co-Gobierno Ciudadano",
    description: "Permitirá a la ciudadanía decidir, en colaboración con el ayuntamiento, los Objetivos Prioritarios del gobierno municipal.
La ciudadanía podrá proponer Objetivos Prioritarios nuevos a través de la Plataforma de Participación Ciudadana, utilizando un mecanismo de recogida de propuestas y apoyos equivalente al usado para las Propuestas Ciudadanas. Las propuestas que tengan más apoyos se unirán a una serie de propuestas elegidas por el gobierno municipal.
El total de propuestas (las elaboradas por la ciudadanía y las elaboradas por el gobierno) serán presentadas a la ciudadanía de nuevo, para que puedan presentar sus apoyos dentro de esta lista final, teniendo en cuenta el orden de prioridades. El resultado será una lista ordenada de manera colectiva estableciendo por lo tanto los Objetivos Prioritarios del gobierno municipal.",
    order: 4,
    accomplished: false,
    department: Department.find_by(name:"Dirección General de Participación Ciudadana")
  },  
  { title: "Legislación colaborativa",
    description: "Se pondrá a disposición de toda la ciudadanía un portal digital enfocado a crear legislación de manera colaborativa y transparente entre ciudadanos e instituciones. 
Los ciudadanos podrán debatir de manera abierta y libre la legislación a abordar. Se invitará a este debate a expertos e implicados, que serán propuestos por la ciudadanía y la institución, y que una vez incluidos podrán proponer dinámicas de debate y consulta ciudadana. Con la información obtenida en éste primer paso se redactará el texto legislativo por parte de los expertos e implicados seleccionados, que a su vez será revisado y comentado por los mismos agentes, produciendo modificaciones en él hasta que se alcance un grado de satisfacción suficiente por parte de los ciudadanos. 
Todas las fases del proceso serán transparentes, y será la propia ciudadanía la que marque el camino a seguir en todo momento, seleccionando las intervenciones más relevantes de los debates, los expertos e implicados que finalmente participen en él, y las modificaciones más relevantes sobre el texto final.",
    order: 5,
    accomplished: false,
    department: Department.find_by(name:"Dirección General de Participación Ciudadana")
  },  
  { title: "Voluntariado: ejercicio responsable de la ciudadanía",
    description: "Se incentivará la participación ciudadana en aspectos relativos al voluntariado; se pretende que el número de voluntarios (que actualmente asciende a 10 000) se incremente todos los años en un 10%, así como el tipo de actividades en las que colaboran, y que el voluntariado se integre como un elemento más, que caracterice el ejercicio responsable de la ciudadanía.",
    order: 6,
    accomplished: false,
    department: Department.find_by(name:"Dirección General de Participación Ciudadana")
  },  
  { title: "Innovación en la mejora de los servicios públicos o la organización social",
    description: "Se busca crear espacios de generación de ideas que contribuyan a resolver las necesidades de la ciudad y de sus ciudadanos, y la conexión con espacios de este tipo ya existentes. Los espacios estarán participados tanto por la ciudadanía como por los trabajadores municipales, y estarán enfocados en innovación social y digital.
Para ello se contará con la colaboración de la entidad municipal Madrid Destino, Cultura, Turismo y Negocio, a través de Medialab – Prado; así como con otras instituciones punteras en innovación social.",
    order: 7,
    accomplished: true,
    department: Department.find_by(name:"Dirección General de Participación Ciudadana")
  }
]
objectives.each do |objective|
  Objective.find_or_create_by(objective)
end
