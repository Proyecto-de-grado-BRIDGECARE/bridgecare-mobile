import 'package:flutter/material.dart';
import 'package:bridgecare/features/bridge_management/inventory/presentation/widgets/build_form.dart';

class FormInventario extends StatefulWidget {
  const FormInventario({super.key});

  @override
  State<FormInventario> createState() => _FormInventarioState();
}

class _FormInventarioState extends State<FormInventario> {
  //primero
  TextEditingController nombrePuente = TextEditingController();
  TextEditingController puenteId = TextEditingController();
  TextEditingController regionalId = TextEditingController();
  TextEditingController carreteraId = TextEditingController();
  TextEditingController pr = TextEditingController();

  //pasos
  TextEditingController tipoPaso = TextEditingController();
  TextEditingController primero = TextEditingController();
  TextEditingController supInf = TextEditingController();
  TextEditingController galiboI = TextEditingController();
  TextEditingController galiboIM = TextEditingController();
  TextEditingController galiboDM = TextEditingController();
  TextEditingController galiboD = TextEditingController();

  //datos administrativos
  TextEditingController anioConstruccion = TextEditingController();
  TextEditingController anioReconstruccion = TextEditingController();
  TextEditingController direccionCarretera = TextEditingController();
  TextEditingController requisitosInspec = TextEditingController();
  TextEditingController estacionConteo = TextEditingController();
  TextEditingController fechaRecoleccion = TextEditingController();
  TextEditingController inspectorIni = TextEditingController();

  //datos tecnicos
  TextEditingController numLuces = TextEditingController();
  TextEditingController longLuzMayor = TextEditingController();
  TextEditingController longLuzMenor = TextEditingController();
  TextEditingController longTotal = TextEditingController();
  TextEditingController anchoTablero = TextEditingController();
  TextEditingController anchoSeparador = TextEditingController();
  TextEditingController anchoAndenIzq = TextEditingController();
  TextEditingController anchoAndenDer = TextEditingController();
  TextEditingController anchoCalzada = TextEditingController();
  TextEditingController anchoEntreBordillos = TextEditingController();
  TextEditingController anchoAcceso = TextEditingController();
  TextEditingController alturaPilas = TextEditingController();
  TextEditingController alturaEstribos = TextEditingController();
  TextEditingController longApoyoPilas = TextEditingController();
  TextEditingController longApoyoEstribos = TextEditingController();
  TextEditingController puenteTerraplen = TextEditingController(); //bool
  TextEditingController puenteCurva = TextEditingController(); //bool
  TextEditingController esviajamiento = TextEditingController();

  //Super estructura tipo principal
  TextEditingController disenioTipo = TextEditingController(); //bool
  TextEditingController tipoEstructTrans = TextEditingController();
  TextEditingController tipoEstructlong = TextEditingController();
  TextEditingController material = TextEditingController();

  //Super estructura tipo secundario
  TextEditingController disenioTipo2 = TextEditingController(); //bool
  TextEditingController tipoEstructTrans2 = TextEditingController();
  TextEditingController tipoEstructlong2 = TextEditingController();
  TextEditingController material2 = TextEditingController();

  //Subestructura
  TextEditingController subEstructTipo = TextEditingController();
  TextEditingController subEstructMaterial = TextEditingController();
  TextEditingController tipoCimentacion = TextEditingController();

  //Subestructura detalles
  TextEditingController tipoBaranda = TextEditingController();
  TextEditingController superfRodadura = TextEditingController();
  TextEditingController juntaExpancion = TextEditingController();

  // Subestructura pilas
  TextEditingController subPilasTipo = TextEditingController();
  TextEditingController subPilasMaterial = TextEditingController();
  TextEditingController subPilastipoCimentacion = TextEditingController();

  //Subestructura señales
  TextEditingController subSenialesCargaMax = TextEditingController();
  TextEditingController subSenialesVelMax = TextEditingController();
  TextEditingController subSenialesOtra = TextEditingController();

  //apoyos
  TextEditingController apoyosFijosEstribos = TextEditingController();
  TextEditingController apoyosMovilesEstribos = TextEditingController();
  TextEditingController apoyosFijosFilas = TextEditingController();
  TextEditingController apoyosMovilesFilas = TextEditingController();
  TextEditingController apoyosFijosPilas = TextEditingController();
  TextEditingController apoyosMovilesPilas = TextEditingController();
  TextEditingController apoyosFijosVigas = TextEditingController();
  TextEditingController apoyosMovilesVigas = TextEditingController();
  TextEditingController apoyosVehiculosDisenio = TextEditingController();
  TextEditingController apoyosDistrCarga = TextEditingController();

  //miembros interesados
  TextEditingController propietarios = TextEditingController();
  TextEditingController departamento = TextEditingController();
  TextEditingController adminVial = TextEditingController();
  TextEditingController proyectista = TextEditingController();
  TextEditingController municipio = TextEditingController();

  //Posicion geografica
  TextEditingController latitud = TextEditingController();
  TextEditingController longitud = TextEditingController();
  TextEditingController acelSismica = TextEditingController(); //Aa
  TextEditingController pasoCause = TextEditingController(); //bool
  TextEditingController variante = TextEditingController(); //bool
  TextEditingController longVariante = TextEditingController();
  TextEditingController estado = TextEditingController(); //B/R/M

  //carga
  TextEditingController longLuzCritic = TextEditingController();
  TextEditingController factorClasificacion = TextEditingController();
  TextEditingController fuerzaCortante = TextEditingController();
  TextEditingController momento = TextEditingController();
  TextEditingController lineaCargaRueda = TextEditingController();
  TextEditingController observaciones = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<SectionData> secciones = [
      SectionData(
        tituloSeccion: "INFORMACIÓN BASICA",
        campos: [
          FieldData(
            labelCampo: "nombre",
            controller: nombrePuente,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "id puente",
            controller: puenteId,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "region id",
            controller: regionalId,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "id del camino",
            controller: carreteraId,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "pr",
            controller: pr,
            opciones: [],
            numerico: false,
          ),
        ],
      ),
      SectionData(
        tituloSeccion: "PASOS",
        campos: [
          FieldData(
            labelCampo: "Tipo paso",
            controller: tipoPaso,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Primero (S/N)",
            controller: primero,
            opciones: ["S", "N"],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Sup/Inf(S/I)",
            controller: supInf,
            opciones: ["superior", "inferior"],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Galibo I",
            controller: galiboI,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Galibo IM",
            controller: galiboIM,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Galibo DM",
            controller: galiboDM,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Galibo D",
            controller: galiboD,
            opciones: [],
            numerico: true,
          ),
        ],
      ),
      SectionData(
        tituloSeccion: "DATOS ADMINISTRATIVOS",
        campos: [
          FieldData(
            labelCampo: "Año de construcción",
            controller: anioConstruccion,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Año de reconstrucción",
            controller: anioReconstruccion,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Dirección de absc. de la carret. (N/S/E/O)",
            controller: direccionCarretera,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Numero de secciones de inspección",
            controller: requisitosInspec,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Estación de conteo",
            controller: estacionConteo,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Fecha de recolección de datos",
            controller: fechaRecoleccion,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Iniciales de inspector",
            controller: inspectorIni,
            opciones: [],
            numerico: false,
          ),
        ],
      ),
      SectionData(
        tituloSeccion: "DATOS TÉCNICOS (GEOMETRIA)",
        campos: [
          FieldData(
            labelCampo: "Número de luces",
            controller: numLuces,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Longitud Luz mayor (m)",
            controller: longLuzMayor,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Longitud Luz menor (m)",
            controller: longLuzMenor,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Longitud total (m)",
            controller: longTotal,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Ancho del tablero (m)",
            controller: anchoTablero,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Ancho del separador (m)",
            controller: anchoSeparador,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Ancho del andén izquierdo (m)",
            controller: anchoAndenIzq,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Ancho del andén derecho (m)",
            controller: anchoAndenDer,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Ancho de calzada (m)",
            controller: anchoCalzada,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Ancho entre bordillos (m)",
            controller: anchoEntreBordillos,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Ancho del acceso (m)",
            controller: anchoAcceso,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Altura de pilas (m)",
            controller: alturaPilas,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Altura de estribos (m)",
            controller: alturaEstribos,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Longitud de apoyo en pilas (m)",
            controller: longApoyoPilas,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Longitud de apoyo en estribos (m)",
            controller: longApoyoEstribos,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Puente en terraplén (S/N)",
            controller: puenteTerraplen,
            opciones: ["S", "N"],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Puente en curva / Tangente (C/T)",
            controller: puenteCurva,
            opciones: ["C", "T"],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Esviajamiento (gra)",
            controller: esviajamiento,
            opciones: [],
            numerico: true,
          ),
        ],
      ),
      SectionData(
        tituloSeccion: "SUPERESTRUCTURA, TIPO PRINCIPAL",
        campos: [
          FieldData(
            labelCampo: "Diseño tipo (S/N)",
            controller: disenioTipo,
            opciones: ["S", "N"],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Tipo de estructuración transversal",
            controller: tipoEstructTrans,
            opciones: [
              "10 Losa",
              "11 Losa/viga, 1 viga",
              "12 Losa/viga, 2 vigas",
              "13 Losa/viga, 3 vigas",
              "14 Losa/viga, 4 o más vigas",
              "30 Trabe cajón, 1 cajón",
              "31 Trabe cajón, 2 ó más cajones",
              "40 Armadura de paso inferior",
              "41 Armadura de paso superior",
              "42 Armadura de paso a través",
              "50 Arco superior",
              "51 Arco inferior, tipo abierto",
              "52 Arco inferior, tipo cerrado",
              "80 Provisional, tipo Bailey",
              "81 Provisional, tipo Callender Hamilton",
            ],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Tipo de estructuración longitudinal",
            controller: tipoEstructlong,
            opciones: [
              "10 Simplemente apoyado, sección transversal constante",
              "11 Simplemente apoyado, sección transversal variable",
              "20 Viga continua, sección transversal constante",
              "21 Viga continua, sección transversal variable",
              "30 Viga Gerber, sección transversal constante",
              "31 Viga Gerber, sección transversal variable",
              "40 Pórtico, sección transversal constante",
              "41 Pórtico, sección transversal variable",
              "42 Cajones (box culvert)",
              "50 Puente colgante",
              "60 Puente atirantado",
            ],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Material (de la superestructura)",
            controller: material,
            opciones: [
              "10 Concreto ciclópeo",
              "11 Concreto sin refuerzo",
              "20 Concreto reforzado, in situ",
              "21 Concreto reforzado, prefabricado & in situ",
              "30 Concreto presforzado, in situ",
              "31 Concreto presforzado, prefabricado",
              "32 Concreto presforzado, prefabricado & in situ",
              "50 Acero",
              "51 Acero y concreto",
              "60 Piedra o roca",
              "70 Ladrillo",
            ],
            numerico: false,
          ),
        ],
      ),
      SectionData(
        tituloSeccion: "SUPERESTRUCTURA, TIPO SECUNDARIO",
        campos: [
          FieldData(
            labelCampo: "Diseño tipo (S/N)",
            controller: disenioTipo2,
            opciones: ["S", "N"],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Tipo de estructuración transversal",
            controller: tipoEstructTrans2,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Tipo de estructuración longitudinal",
            controller: tipoEstructlong2,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Material",
            controller: material2,
            opciones: [],
            numerico: false,
          ),
        ],
      ),
      SectionData(
        tituloSeccion: "SUBESTRUCTURA, ESTRIBOS",
        campos: [
          FieldData(
            labelCampo: "Tipo",
            controller: subEstructTipo,
            opciones: [
              "10 Con aletas integradas",
              "11 Con aletas separadas",
              "20 Enterrado, sólido",
              "21 Enterrado, columnas/pilotes con viga cabezal",
            ],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Material",
            controller: subEstructMaterial,
            opciones: [
              "10 Mampostería",
              "20 Concreto ciclópeo",
              "21 Concreto reforzado",
              "30 Acero",
              "40 Acero y concreto",
              "50 Tierra armada",
              "60 Ladrillo",
            ],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Tipo de Cimentacion",
            controller: tipoCimentacion,
            opciones: [
              "10 Cimentación superficial",
              "20 Pilotes de concreto",
              "21 Pilotes de acero",
              "22 Pilotes de madera",
              "30 Caisson de concreto",
              "40 Cajón autofundante",
            ],
            numerico: false,
          ),
        ],
      ),
      SectionData(
        tituloSeccion: "SUBESTRUCTURA, DETALLES",
        campos: [
          FieldData(
            labelCampo: "Tipo de baranda",
            controller: tipoBaranda,
            opciones: [
              "10 Mampostería",
              "20 Concreto sólido",
              "21 Concreto sólido con pasamanos metálicas",
              "30 Pasamanos de concreto sobre pilastras de concreto",
              "40 Pasamanos metálicas sobre pilastras de concreto",
              "41 Pasamanos metálicas sobre pilastras metálicas",
              "50 Construcción metálica ligera",
              "60 Parte integral de la superestructura",
            ],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Superficie de rodadura",
            controller: superfRodadura,
            opciones: [
              "10 Asfalto",
              "20 Concreto",
              "30 Acero (con disp. de fricción)",
              "40 Afirmado",
            ],
            numerico: false,
          ),
          FieldData(
            labelCampo: "junta de expansión",
            controller: juntaExpancion,
            opciones: [
              "10 Placa de acero",
              "11 Placa de acero cubierto de asfalto",
              "12 Placas verticales/ángulos de acero",
              "13 Junta dentada",
              "20 Acero con sello fijo de neopreno",
              "21 Acero con neopreno comprimido",
              "30 Bloque de neopreno",
              "40 Junta de goma asfáltica",
              "50 No dispositivo de junta",
              "51 Junta de cartón asfaltado",
              "52 Junta de cartón asfaltado con sello",
            ],
            numerico: false,
          ),
        ],
      ),
      SectionData(
        tituloSeccion: "SUBESTRUCTURA, PILAS",
        campos: [
          FieldData(
            labelCampo: "Tipo",
            controller: subPilasTipo,
            opciones: [
              "10 Pila sólida",
              "20 Columna sola",
              "21 2 o más columnas sin viga cabezal",
              "30 Columna sola con viga cabezal",
              "31 2 ó más columnas con vigas cabezales separadas",
              "32 2 ó más columnas con viga cabezal común",
              "33 Columnas con viga cabezal y diafragma",
              "40 Pilotes con viga cabezal",
              "41 Pilotes con viga cabezal y diafragma",
              "50 Mástil (pilón)",
              "60 Torre metálica",
            ],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Material",
            controller: subPilasMaterial,
            opciones: [
              "10 Mampostería",
              "20 Concreto ciclópeo",
              "21 Concreto reforzado",
              "30 Acero",
              "40 Acero y concreto",
              "50 Tierra armada",
              "60 Ladrillo",
            ],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Tipo de cimentación",
            controller: subPilastipoCimentacion,
            opciones: [
              "10 Mampostería",
              "20 Concreto sólido",
              "21 Concreto sólido con pasamanos metálicas",
              "30 Pasamanos de concreto sobre pilastras de concreto",
              "40 Pasamanos metálicas sobre pilastras de concreto",
              "41 Pasamanos metálicas sobre pilastras metálicas",
              "50 Construcción metálica ligera",
              "60 Parte integral de la superestructura",
            ],
            numerico: false,
          ),
        ],
      ),
      SectionData(
        tituloSeccion: "SUBESTRUCTURA, SEÑALES",
        campos: [
          FieldData(
            labelCampo: "Carga máxima",
            controller: subSenialesCargaMax,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Velocidad Máxima",
            controller: subSenialesVelMax,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Otra",
            controller: subSenialesOtra,
            opciones: [],
            numerico: false,
          ),
        ],
      ),
      SectionData(
        tituloSeccion: "APOYOS",
        campos: [
          FieldData(
            labelCampo: "Tipo de apoyos fijos sobre estribos",
            controller: apoyosFijosEstribos,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Tipo de apoyos móviles sobre estribos",
            controller: apoyosMovilesEstribos,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Tipo de apoyos fijos en pilas",
            controller: apoyosFijosPilas,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Tipo de apoyos móviles en pilas",
            controller: apoyosMovilesPilas,
            opciones: [],
            numerico: false,
          ),
        ],
      ),
      SectionData(
        tituloSeccion: "MIEMBROS INTERESADOS",
        campos: [
          FieldData(
            labelCampo: "Propietario",
            controller: propietarios,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Departamento",
            controller: departamento,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Administrador Vial",
            controller: adminVial,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Proyectista",
            controller: proyectista,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Municipio",
            controller: municipio,
            opciones: [],
            numerico: false,
          ),
        ],
      ),
      SectionData(
        tituloSeccion: "POCISIÓN GEOGRÁFICA",
        campos: [
          FieldData(
            labelCampo: "Latitud (N)",
            controller: latitud,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Longitud (O)",
            controller: longitud,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Coeficiente de aceleración sísmica (Aa)",
            controller: acelSismica,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Paso por el cauce (S/N)",
            controller: pasoCause,
            opciones: ["S", "N"],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Existe variante (S/N)",
            controller: variante,
            opciones: ["S", "N"],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Longitud variante",
            controller: longVariante,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Estado (B/R/M)",
            controller: estado,
            opciones: [],
            numerico: false,
          ),
        ],
      ),
      SectionData(
        tituloSeccion: "CARGA",
        campos: [
          FieldData(
            labelCampo: "Long. Luz crítica (m)",
            controller: longLuzCritic,
            opciones: [],
            numerico: true,
          ),
          FieldData(
            labelCampo: "Factor de clasificación",
            controller: factorClasificacion,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Fuerza cortante (t)",
            controller: fuerzaCortante,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Momento (t.m.)",
            controller: momento,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Línea de carga por rueda (t)",
            controller: lineaCargaRueda,
            opciones: [],
            numerico: false,
          ),
          FieldData(
            labelCampo: "Observaciones",
            controller: observaciones,
            opciones: [],
            numerico: false,
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        title: Text(
          "Formulario de Inventario",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFEBEBEB),
      ),
      body: BuildForm(tituloSeccion: "", secciones: secciones),
    );
  }
}
