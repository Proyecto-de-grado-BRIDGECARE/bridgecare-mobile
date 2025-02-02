import 'package:flutter/material.dart';
import 'package:bridgecare/features/assets/presentation/pages/buildForm2.dart';

class FormInspection extends StatefulWidget {
  const FormInspection({super.key});

  @override
  State<FormInspection> createState() => _FormInspectionState();
}

class _FormInspectionState extends State<FormInspection> {
  // Controllers para los campos de la inspección
  final TextEditingController fechaInspeccion = TextEditingController();
  final TextEditingController inspector = TextEditingController();
  final TextEditingController tiempo = TextEditingController();
  final TextEditingController temperatura = TextEditingController();
  final TextEditingController transitoPromedioDiarioSemanal = TextEditingController();
  final TextEditingController porcentajeAutos = TextEditingController();
  final TextEditingController porcentajeBuses = TextEditingController();
  final TextEditingController porcentajeCamiones = TextEditingController();
  final TextEditingController proximaInspeccion = TextEditingController();
  final TextEditingController superficiePuente = TextEditingController();
  final TextEditingController juntasExpansion = TextEditingController();
  final TextEditingController andenesBordillos = TextEditingController();
  final TextEditingController barandas = TextEditingController();
  final TextEditingController conosTaludes = TextEditingController();
  final TextEditingController aletas = TextEditingController();
  final TextEditingController estribos = TextEditingController();
  final TextEditingController pilas = TextEditingController();
  final TextEditingController apoyos = TextEditingController();
  final TextEditingController losa = TextEditingController();
  final TextEditingController vigasLarguerosDiafragmas = TextEditingController();
  final TextEditingController elementosArco = TextEditingController();
  final TextEditingController cablesPendolonesTorresMacizos = TextEditingController();
  final TextEditingController elementosArmadura = TextEditingController();
  final TextEditingController cauce = TextEditingController();
  final TextEditingController otrosElementos = TextEditingController();
  final TextEditingController puenteGeneral = TextEditingController();
  final TextEditingController mantenimientoLimpieza = TextEditingController();
  final TextEditingController inspeccionEspecial = TextEditingController();
  final TextEditingController danoObservaciones = TextEditingController();
  final TextEditingController tipoDano = TextEditingController();
  final TextEditingController numeroFotografias = TextEditingController();
  final TextEditingController obraReparacion1 = TextEditingController();
  final TextEditingController cantidadReparacion1 = TextEditingController();
  final TextEditingController anoReparacion1 = TextEditingController();
  final TextEditingController obraReparacion2 = TextEditingController();
  final TextEditingController cantidadReparacion2 = TextEditingController();
  final TextEditingController anoReparacion2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<SectionData> secciones = [
      SectionData(tituloSeccion: "DATOS GENERALES DE LA INSPECCIÓN", campos: [
        FieldData(labelCampo: "Fecha de inspección", controller: fechaInspeccion),
        FieldData(labelCampo: "Inspector", controller: inspector),
        FieldData(labelCampo: "Tiempo", controller: tiempo),
        FieldData(labelCampo: "Temperatura (°C)", controller: temperatura),
      ]),
      SectionData(tituloSeccion: "TRÁNSITO", campos: [
        FieldData(labelCampo: "Tránsito promedio diario semanal", controller: transitoPromedioDiarioSemanal),
        FieldData(labelCampo: "Porcentaje de autos", controller: porcentajeAutos),
        FieldData(labelCampo: "Porcentaje de buses", controller: porcentajeBuses),
        FieldData(labelCampo: "Porcentaje de camiones", controller: porcentajeCamiones),
      ]),
      SectionData(tituloSeccion: "PRÓXIMA INSPECCIÓN", campos: [
        FieldData(labelCampo: "Próxima inspección", controller: proximaInspeccion),
      ]),
      SectionData(tituloSeccion: "COMPONENTES DEL PUENTE", campos: [
        FieldData(labelCampo: "Superficie del puente", controller: superficiePuente),
        FieldData(labelCampo: "Juntas de expansión", controller: juntasExpansion),
        FieldData(labelCampo: "Andenes y bordillos", controller: andenesBordillos),
        FieldData(labelCampo: "Barandas", controller: barandas),
        FieldData(labelCampo: "Conos y taludes", controller: conosTaludes),
        FieldData(labelCampo: "Aletas", controller: aletas),
        FieldData(labelCampo: "Estribos", controller: estribos),
        FieldData(labelCampo: "Pilas", controller: pilas),
        FieldData(labelCampo: "Apoyos", controller: apoyos),
        FieldData(labelCampo: "Losa", controller: losa),
        FieldData(labelCampo: "Vigas, largueros y diafragmas", controller: vigasLarguerosDiafragmas),
        FieldData(labelCampo: "Elementos de arco", controller: elementosArco),
        FieldData(labelCampo: "Cables, pendolones, torres y macizos", controller: cablesPendolonesTorresMacizos),
        FieldData(labelCampo: "Elementos de armadura", controller: elementosArmadura),
        FieldData(labelCampo: "Cauce", controller: cauce),
        FieldData(labelCampo: "Otros elementos", controller: otrosElementos),
        FieldData(labelCampo: "Puente en general", controller: puenteGeneral),
      ]),
      SectionData(tituloSeccion: "MANTENIMIENTO Y LIMPIEZA", campos: [
        FieldData(labelCampo: "Mantenimiento y limpieza", controller: mantenimientoLimpieza),
      ]),
      SectionData(tituloSeccion: "INSPECCIÓN ESPECIAL", campos: [
        FieldData(labelCampo: "Requiere inspección especial", controller: inspeccionEspecial),
      ]),
      SectionData(tituloSeccion: "DAÑOS Y OBSERVACIONES", campos: [
        FieldData(labelCampo: "Daños y observaciones", controller: danoObservaciones),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDano),
      ]),
      SectionData(tituloSeccion: "FOTOGRAFÍAS", campos: [
        FieldData(labelCampo: "Número de fotografías", controller: numeroFotografias),
      ]),
      SectionData(tituloSeccion: "OBRAS DE REPARACIÓN", campos: [
        FieldData(labelCampo: "Obra de reparación 1", controller: obraReparacion1),
        FieldData(labelCampo: "Cantidad de reparación 1", controller: cantidadReparacion1),
        FieldData(labelCampo: "Año de reparación 1", controller: anoReparacion1),
        FieldData(labelCampo: "Obra de reparación 2", controller: obraReparacion2),
        FieldData(labelCampo: "Cantidad de reparación 2", controller: cantidadReparacion2),
        FieldData(labelCampo: "Año de reparación 2", controller: anoReparacion2),
      ]),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        title: Text(
          "Formulario de Inspección",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFEBEBEB),
      ),
      body: BuildForm(tituloSeccion: "", secciones: secciones),
    );
  }
}