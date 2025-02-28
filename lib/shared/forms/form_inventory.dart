import 'package:flutter/material.dart';
import 'package:bridgecare/features/assets/presentation/pages/buildForm.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';

class FormInventory extends StatefulWidget {
  const FormInventory({super.key});

  @override
  State<FormInventory> createState() => _FormInventoryState();
}

class _FormInventoryState extends State<FormInventory> {
  //primero
  final TextEditingController bridgeName = TextEditingController();
  final TextEditingController regionalId = TextEditingController();
  final TextEditingController roadId = TextEditingController();

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
      SectionData(tituloSeccion: "INFORMACIÓN BASICA", campos: [
        FieldData(labelCampo: "nombre", controller: bridgeName),
        FieldData(labelCampo: "region id", controller: regionalId),
        FieldData(labelCampo: "id del camino", controller: roadId),
      ]),
      SectionData(tituloSeccion: "pasos", campos: [
        FieldData(labelCampo: "Tipo paso", controller: tipoPaso),
        FieldData(labelCampo: "Primero (S/N)", controller: primero),
        FieldData(labelCampo: "Sup/Inf(S/I)", controller: supInf),
        FieldData(labelCampo: "Galibo I", controller: galiboI),
        FieldData(labelCampo: "Galibo IM", controller: galiboIM),
        FieldData(labelCampo: "Galibo DM", controller: galiboDM),
        FieldData(labelCampo: "Galibo D", controller: galiboD),
      ]),
      SectionData(tituloSeccion: "DATOS ADMINISTRATIVOS", campos: [
        FieldData(
            labelCampo: "Año de construcción", controller: anioConstruccion),
        FieldData(
            labelCampo: "Año de reconstrucción",
            controller: anioReconstruccion),
        FieldData(
            labelCampo: "Dirección de absc. de la carret. (N/S/E/O)",
            controller: direccionCarretera),
        FieldData(
            labelCampo: "Numero de secciones de inspección",
            controller: requisitosInspec),
        FieldData(labelCampo: "Estación de conteo", controller: estacionConteo),
        FieldData(
            labelCampo: "Fecha de recolección de datos",
            controller: fechaRecoleccion),
        FieldData(
            labelCampo: "Iniciales de inspector", controller: inspectorIni),
      ]),
      SectionData(tituloSeccion: "DATOS TECNICOS, GEOMETRIA", campos: [
        FieldData(labelCampo: "Numero de luces", controller: numLuces),
        FieldData(
            labelCampo: "Longitud Luz menor (m)", controller: longLuzMayor),
        FieldData(
            labelCampo: "Longitud luz mayor (m)", controller: longLuzMenor),
        FieldData(labelCampo: "Longitud total (m)", controller: longTotal),
        FieldData(
            labelCampo: "Ancho del tablero (m)", controller: anchoTablero),
        FieldData(
            labelCampo: "Ancho del separador (m)", controller: anchoSeparador),
        FieldData(
            labelCampo: "Ancho del anden izquierdo (m)",
            controller: anchoAndenIzq),
        FieldData(
            labelCampo: "Ancho del anden derecho (m)",
            controller: anchoAndenDer),
        FieldData(labelCampo: "Ancho de calzada (m)", controller: anchoCalzada),
        FieldData(
            labelCampo: "Ancho entre bordillos (m)",
            controller: anchoEntreBordillos),
        FieldData(labelCampo: "Ancho del acceso (m)", controller: anchoAcceso),
        FieldData(labelCampo: "Altura de pilas (m)", controller: alturaPilas),
        FieldData(
            labelCampo: "Altura de estribos (m)", controller: alturaEstribos),
        FieldData(
            labelCampo: "Longitud de apoyo en pilas (m)",
            controller: longApoyoPilas),
        FieldData(
            labelCampo: "Longitud de apoyo en estribos (m)",
            controller: longApoyoEstribos),
        FieldData(
            labelCampo: "Puente en terraplén (s/N)",
            controller: puenteTerraplen),
        FieldData(
            labelCampo: "Puente en curva / Tangente (C/T)",
            controller: puenteCurva),
        FieldData(labelCampo: "Esviajamiento (gra)", controller: galiboI),
      ]),
      SectionData(tituloSeccion: "SUPERESTRUCTURA, TIPO PRINCIPAL", campos: [
        FieldData(labelCampo: "Diseño tipo (S/N)", controller: disenioTipo),
        FieldData(
            labelCampo: "Tipo de estructuración transversal",
            controller: tipoEstructTrans),
        FieldData(
            labelCampo: "Tipo de estructuración longitudinal",
            controller: tipoEstructlong),
        FieldData(labelCampo: "Material", controller: material),
      ]),
      SectionData(tituloSeccion: "SUPERESTRUCTURA, TIPO SECUNDARIO", campos: [
        FieldData(labelCampo: "Diseño tipo (S/N)", controller: disenioTipo2),
        FieldData(
            labelCampo: "Tipo de estructuración transversal",
            controller: tipoEstructTrans2),
        FieldData(
            labelCampo: "Tipo de estructuración longitudinal",
            controller: tipoEstructlong2),
        FieldData(labelCampo: "Material", controller: material2),
      ]),
      SectionData(tituloSeccion: "SUBESTRUCTURA, ESTRIBOS", campos: [
        FieldData(labelCampo: "Tipo", controller: subEstructTipo),
        FieldData(labelCampo: "Material", controller: subEstructMaterial),
        FieldData(
            labelCampo: "Tipo de Cimentacion", controller: tipoCimentacion),
      ]),
      SectionData(tituloSeccion: "SUBESTRUCTURA, DETALLES", campos: [
        FieldData(labelCampo: "Tipo de baranda", controller: tipoBaranda),
        FieldData(
            labelCampo: "Superficie de rodadura", controller: superfRodadura),
        FieldData(labelCampo: "junta de expansion", controller: juntaExpancion),
      ]),
      SectionData(tituloSeccion: "SUBESTRUCTURA, PILAS ", campos: [
        FieldData(labelCampo: "Tipo", controller: subPilasTipo),
        FieldData(labelCampo: "Material", controller: subPilasMaterial),
        FieldData(
            labelCampo: "Tipo de cimentacion ",
            controller: subPilastipoCimentacion),
      ]),
      SectionData(tituloSeccion: "SUBESTRUCTURA, SEÑALES", campos: [
        FieldData(labelCampo: "Carga maxima ", controller: subSenialesCargaMax),
        FieldData(
            labelCampo: "Velocidad Maxima", controller: subSenialesVelMax),
        FieldData(labelCampo: "Otra", controller: subSenialesOtra),
      ]),
      SectionData(tituloSeccion: "APOYOS", campos: [
        FieldData(
            labelCampo: "Tipo de apoyos fijos sobre estribos ",
            controller: apoyosFijosEstribos),
        FieldData(
            labelCampo: "Tipo de apoyos moviles sobre estribos",
            controller: apoyosMovilesEstribos),
        FieldData(
            labelCampo: "Tipo de apoyos fijos en pilas",
            controller: apoyosFijosPilas),
        FieldData(
            labelCampo: "Tipo de apoyos moviles en pilas ",
            controller: apoyosMovilesPilas),
        FieldData(
            labelCampo: "Tipo de apoyos fijos en vigas",
            controller: apoyosFijosVigas),
        FieldData(
            labelCampo: "Tipo de apoyos moviles en vigas",
            controller: apoyosMovilesVigas),
        FieldData(
            labelCampo: "Vehiculo de diseño",
            controller: apoyosVehiculosDisenio),
        FieldData(
            labelCampo: "Clase de distribución de carga ",
            controller: apoyosDistrCarga),
      ]),
      SectionData(tituloSeccion: "MIEMBROS INTERESADOS", campos: [
        FieldData(labelCampo: "Propietario", controller: propietarios),
        FieldData(labelCampo: "Departamento", controller: departamento),
        FieldData(labelCampo: "Administrador Vial", controller: adminVial),
        FieldData(labelCampo: "Proyectista", controller: proyectista),
        FieldData(labelCampo: "Municipio", controller: municipio),
      ]),
      SectionData(tituloSeccion: "POCISION GEOGRAFICA", campos: [
        FieldData(labelCampo: "Latitud (N)", controller: latitud),
        FieldData(labelCampo: "Longitud (O)", controller: departamento),
        FieldData(
            labelCampo: "Coeficiente de aceleración sísmica (Aa)",
            controller: acelSismica),
        FieldData(labelCampo: "Paso por el cause (S/N)", controller: pasoCause),
        FieldData(labelCampo: "Existe variante (S/N)", controller: variante),
        FieldData(labelCampo: "Longitud variante", controller: longVariante),
        FieldData(labelCampo: "Estado (B/R/M)", controller: estado),
      ]),
      SectionData(tituloSeccion: "CARGA", campos: [
        FieldData(
            labelCampo: "Long. Luz critica (m)", controller: longLuzCritic),
        FieldData(
            labelCampo: "Factor de clasificacion",
            controller: factorClasificacion),
        FieldData(
            labelCampo: "Fuerza cortante (t)", controller: fuerzaCortante),
        FieldData(labelCampo: "Momento(t.m.)", controller: momento),
        FieldData(
            labelCampo: "Linea de carga por rueda (t)",
            controller: lineaCargaRueda),
        FieldData(labelCampo: "Observaciones", controller: observaciones),
      ]),
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
        body: buildForm(tituloSeccion: "", secciones: secciones));
  }
}
