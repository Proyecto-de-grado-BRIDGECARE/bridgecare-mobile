import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bridgecare/features/assets/presentation/pages/buildForm.dart';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController puenteImg = TextEditingController();

  //pasos
  TextEditingController tipoPaso = TextEditingController();
  TextEditingController primero = TextEditingController();
  TextEditingController supInf = TextEditingController();
  TextEditingController galiboI = TextEditingController();
  TextEditingController galiboIM = TextEditingController();
  TextEditingController galiboDM = TextEditingController();
  TextEditingController galiboD = TextEditingController();

  //datos administrativos
  TextEditingController constuctionYear = TextEditingController();
  TextEditingController reconstuctionYear = TextEditingController();
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
  TextEditingController imgTecnico = TextEditingController();

  //Super estructura tipo principal
  TextEditingController disenioTipo = TextEditingController(); //bool
  TextEditingController tipoEstructTrans = TextEditingController();
  TextEditingController tipoEstructlong = TextEditingController();
  TextEditingController material = TextEditingController();
  TextEditingController imgSuperEstruct = TextEditingController();

  //Super estructura tipo secundario
  TextEditingController disenioTipo2 = TextEditingController(); //bool
  TextEditingController tipoEstructTrans2 = TextEditingController();
  TextEditingController tipoEstructlong2 = TextEditingController();
  TextEditingController material2 = TextEditingController();
  TextEditingController imgSuperEstruct2 = TextEditingController();

  //Subestructura
  TextEditingController subEstructTipo = TextEditingController();
  TextEditingController subEstructMaterial = TextEditingController();
  TextEditingController tipoCimentacion = TextEditingController();
  TextEditingController subEstructImg = TextEditingController();

  //Subestructura detalles
  TextEditingController tipoBaranda = TextEditingController();
  TextEditingController superfRodadura = TextEditingController();
  TextEditingController juntaExpancion = TextEditingController();
  TextEditingController subDetallesImg = TextEditingController();

  //Subestructura pilas
  TextEditingController subPilasTipo = TextEditingController();
  TextEditingController subPilasMaterial = TextEditingController();
  TextEditingController subPilastipoCimentacion = TextEditingController();
  TextEditingController subPilasImg = TextEditingController();

  //Subestructura señales
  TextEditingController subSenialesCargaMax = TextEditingController();
  TextEditingController subSenialesVelMax = TextEditingController();
  TextEditingController subSenialesOtra = TextEditingController();
  TextEditingController subSenialesImg = TextEditingController();

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
  TextEditingController apoyosImg = TextEditingController();

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
  TextEditingController imgCarga = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<SectionData> secciones = [
      SectionData(tituloSeccion: "informacion basica", campos: [
        FieldData(labelCampo: "nombre", controller: bridgeName),
        FieldData(labelCampo: "region id", controller: regionalId),
        FieldData(labelCampo: "id del camino", controller: roadId),
      ]),
      SectionData(tituloSeccion: "informacion basica", campos: [
        FieldData(labelCampo: "nombre", controller: bridgeName),
        FieldData(labelCampo: "region id", controller: regionalId),
        FieldData(labelCampo: "id del camino", controller: roadId),
      ])
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
