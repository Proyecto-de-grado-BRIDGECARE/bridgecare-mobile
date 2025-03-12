import 'package:flutter/material.dart';
import 'package:bridgecare/features/formularioInspeccion/buildForm2.dart';

class FormInspection extends StatefulWidget {
  const FormInspection({super.key});

  @override
  State<FormInspection> createState() => _FormInspectionState();
}

class _FormInspectionState extends State<FormInspection> {
  // Controllers para los campos de la inspección
  //Datos Generales
  final TextEditingController nombre = TextEditingController();
  final TextEditingController identificacion = TextEditingController();
  final TextEditingController carretera = TextEditingController();
  final TextEditingController pr = TextEditingController();
  final TextEditingController fechaInspeccion = TextEditingController();
  final TextEditingController inspector = TextEditingController();
  final TextEditingController proxInspec = TextEditingController();
  //Superficies del puente
  final TextEditingController calificacion = TextEditingController();
  final TextEditingController mantenimiento = TextEditingController();
  final TextEditingController inspeccionEspecial = TextEditingController();
  final TextEditingController numeroFotos = TextEditingController();
  final TextEditingController tipoDano = TextEditingController();

  final TextEditingController tipoReparacion = TextEditingController();
  final TextEditingController cantidadReparacion = TextEditingController();
  final TextEditingController anioReparacion = TextEditingController();
  final TextEditingController costoReparacion = TextEditingController();
  final TextEditingController danoReparacion = TextEditingController();
  final TextEditingController fotoReparacion = TextEditingController();

  //Juntas de expancion
  final TextEditingController calificacionJuntas = TextEditingController();
  final TextEditingController mantenimientoJuntas = TextEditingController();
  final TextEditingController inspeccionEspecialJuntas = TextEditingController();
  final TextEditingController numeroFotosJuntas = TextEditingController();
  final TextEditingController tipoDanoJuntas = TextEditingController();

  final TextEditingController tipoReparacionJuntas = TextEditingController();
  final TextEditingController cantidadReparacionJuntas = TextEditingController();
  final TextEditingController anioReparacionJuntas = TextEditingController();
  final TextEditingController costoReparacionJuntas = TextEditingController();
  final TextEditingController danoReparacionJuntas = TextEditingController();
  final TextEditingController fotoReparacionJuntas = TextEditingController();

// Andenes / Bordillos
  final TextEditingController calificacionAndenes = TextEditingController();
  final TextEditingController mantenimientoAndenes = TextEditingController();
  final TextEditingController inspeccionEspecialAndenes = TextEditingController();
  final TextEditingController numeroFotosAndenes = TextEditingController();
  final TextEditingController tipoDanoAndenes = TextEditingController();

  final TextEditingController tipoReparacionAndenes = TextEditingController();
  final TextEditingController cantidadReparacionAndenes = TextEditingController();
  final TextEditingController anioReparacionAndenes = TextEditingController();
  final TextEditingController costoReparacionAndenes = TextEditingController();
  final TextEditingController danoReparacionAndenes = TextEditingController();
  final TextEditingController fotoReparacionAndenes = TextEditingController();

// Barandas
  final TextEditingController calificacionBarandas = TextEditingController();
  final TextEditingController mantenimientoBarandas = TextEditingController();
  final TextEditingController inspeccionEspecialBarandas = TextEditingController();
  final TextEditingController numeroFotosBarandas = TextEditingController();
  final TextEditingController tipoDanoBarandas = TextEditingController();

  final TextEditingController tipoReparacionBarandas = TextEditingController();
  final TextEditingController cantidadReparacionBarandas = TextEditingController();
  final TextEditingController anioReparacionBarandas = TextEditingController();
  final TextEditingController costoReparacionBarandas = TextEditingController();
  final TextEditingController danoReparacionBarandas = TextEditingController();
  final TextEditingController fotoReparacionBarandas = TextEditingController();

// Conos / Taludes
  final TextEditingController calificacionConos = TextEditingController();
  final TextEditingController mantenimientoConos = TextEditingController();
  final TextEditingController inspeccionEspecialConos = TextEditingController();
  final TextEditingController numeroFotosConos = TextEditingController();
  final TextEditingController tipoDanoConos = TextEditingController();

  final TextEditingController tipoReparacionConos = TextEditingController();
  final TextEditingController cantidadReparacionConos = TextEditingController();
  final TextEditingController anioReparacionConos = TextEditingController();
  final TextEditingController costoReparacionConos = TextEditingController();
  final TextEditingController danoReparacionConos = TextEditingController();
  final TextEditingController fotoReparacionConos = TextEditingController();

// Aletas
  final TextEditingController calificacionAletas = TextEditingController();
  final TextEditingController mantenimientoAletas = TextEditingController();
  final TextEditingController inspeccionEspecialAletas = TextEditingController();
  final TextEditingController numeroFotosAletas = TextEditingController();
  final TextEditingController tipoDanoAletas = TextEditingController();

  final TextEditingController tipoReparacionAletas = TextEditingController();
  final TextEditingController cantidadReparacionAletas = TextEditingController();
  final TextEditingController anioReparacionAletas = TextEditingController();
  final TextEditingController costoReparacionAletas = TextEditingController();
  final TextEditingController danoReparacionAletas = TextEditingController();
  final TextEditingController fotoReparacionAletas = TextEditingController();

// Estribos
  final TextEditingController calificacionEstribos = TextEditingController();
  final TextEditingController mantenimientoEstribos = TextEditingController();
  final TextEditingController inspeccionEspecialEstribos = TextEditingController();
  final TextEditingController numeroFotosEstribos = TextEditingController();
  final TextEditingController tipoDanoEstribos = TextEditingController();

  final TextEditingController tipoReparacionEstribos = TextEditingController();
  final TextEditingController cantidadReparacionEstribos = TextEditingController();
  final TextEditingController anioReparacionEstribos = TextEditingController();
  final TextEditingController costoReparacionEstribos = TextEditingController();
  final TextEditingController danoReparacionEstribos = TextEditingController();
  final TextEditingController fotoReparacionEstribos = TextEditingController();

// Pilas
  final TextEditingController calificacionPilas = TextEditingController();
  final TextEditingController mantenimientoPilas = TextEditingController();
  final TextEditingController inspeccionEspecialPilas = TextEditingController();
  final TextEditingController numeroFotosPilas = TextEditingController();
  final TextEditingController tipoDanoPilas = TextEditingController();

  final TextEditingController tipoReparacionPilas = TextEditingController();
  final TextEditingController cantidadReparacionPilas = TextEditingController();
  final TextEditingController anioReparacionPilas = TextEditingController();
  final TextEditingController costoReparacionPilas = TextEditingController();
  final TextEditingController danoReparacionPilas = TextEditingController();
  final TextEditingController fotoReparacionPilas = TextEditingController();

// Apoyos
  final TextEditingController calificacionApoyos = TextEditingController();
  final TextEditingController mantenimientoApoyos = TextEditingController();
  final TextEditingController inspeccionEspecialApoyos = TextEditingController();
  final TextEditingController numeroFotosApoyos = TextEditingController();
  final TextEditingController tipoDanoApoyos = TextEditingController();

  final TextEditingController tipoReparacionApoyos = TextEditingController();
  final TextEditingController cantidadReparacionApoyos = TextEditingController();
  final TextEditingController anioReparacionApoyos = TextEditingController();
  final TextEditingController costoReparacionApoyos = TextEditingController();
  final TextEditingController danoReparacionApoyos = TextEditingController();
  final TextEditingController fotoReparacionApoyos = TextEditingController();

// Losa
  final TextEditingController calificacionLosa = TextEditingController();
  final TextEditingController mantenimientoLosa = TextEditingController();
  final TextEditingController inspeccionEspecialLosa = TextEditingController();
  final TextEditingController numeroFotosLosa = TextEditingController();
  final TextEditingController tipoDanoLosa = TextEditingController();

  final TextEditingController tipoReparacionLosa = TextEditingController();
  final TextEditingController cantidadReparacionLosa = TextEditingController();
  final TextEditingController anioReparacionLosa = TextEditingController();
  final TextEditingController costoReparacionLosa = TextEditingController();
  final TextEditingController danoReparacionLosa = TextEditingController();
  final TextEditingController fotoReparacionLosa = TextEditingController();

// Superficie Vigas / Largueros / Diafragmas Puente
  final TextEditingController calificacionVigasLarguerosDiafragmas = TextEditingController();
  final TextEditingController mantenimientoVigasLarguerosDiafragmas = TextEditingController();
  final TextEditingController inspeccionEspecialVigasLarguerosDiafragmas = TextEditingController();
  final TextEditingController numeroFotosVigasLarguerosDiafragmas = TextEditingController();
  final TextEditingController tipoDanoVigasLarguerosDiafragmas = TextEditingController();

  final TextEditingController tipoReparacionVigasLarguerosDiafragmas = TextEditingController();
  final TextEditingController cantidadReparacionVigasLarguerosDiafragmas = TextEditingController();
  final TextEditingController anioReparacionVigasLarguerosDiafragmas = TextEditingController();
  final TextEditingController costoReparacionVigasLarguerosDiafragmas = TextEditingController();
  final TextEditingController danoReparacionVigasLarguerosDiafragmas = TextEditingController();
  final TextEditingController fotoReparacionVigasLarguerosDiafragmas = TextEditingController();

// Elementos de Arco
  final TextEditingController calificacionElementosArco = TextEditingController();
  final TextEditingController mantenimientoElementosArco = TextEditingController();
  final TextEditingController inspeccionEspecialElementosArco = TextEditingController();
  final TextEditingController numeroFotosElementosArco = TextEditingController();
  final TextEditingController tipoDanoElementosArco = TextEditingController();

  final TextEditingController tipoReparacionElementosArco = TextEditingController();
  final TextEditingController cantidadReparacionElementosArco = TextEditingController();
  final TextEditingController anioReparacionElementosArco = TextEditingController();
  final TextEditingController costoReparacionElementosArco = TextEditingController();
  final TextEditingController danoReparacionElementosArco = TextEditingController();
  final TextEditingController fotoReparacionElementosArco = TextEditingController();

// Cables / Pendolones / Torres / Macizos
  final TextEditingController calificacionCablesPendolonesTorresMacizos = TextEditingController();
  final TextEditingController mantenimientoCablesPendolonesTorresMacizos = TextEditingController();
  final TextEditingController inspeccionEspecialCablesPendolonesTorresMacizos = TextEditingController();
  final TextEditingController numeroFotosCablesPendolonesTorresMacizos = TextEditingController();
  final TextEditingController tipoDanoCablesPendolonesTorresMacizos = TextEditingController();

  final TextEditingController tipoReparacionCablesPendolonesTorresMacizos = TextEditingController();
  final TextEditingController cantidadReparacionCablesPendolonesTorresMacizos = TextEditingController();
  final TextEditingController anioReparacionCablesPendolonesTorresMacizos = TextEditingController();
  final TextEditingController costoReparacionCablesPendolonesTorresMacizos = TextEditingController();
  final TextEditingController danoReparacionCablesPendolonesTorresMacizos = TextEditingController();
  final TextEditingController fotoReparacionCablesPendolonesTorresMacizos = TextEditingController();

// Elementos de Armadura
  final TextEditingController calificacionElementosArmadura = TextEditingController();
  final TextEditingController mantenimientoElementosArmadura = TextEditingController();
  final TextEditingController inspeccionEspecialElementosArmadura = TextEditingController();
  final TextEditingController numeroFotosElementosArmadura = TextEditingController();
  final TextEditingController tipoDanoElementosArmadura = TextEditingController();

  final TextEditingController tipoReparacionElementosArmadura = TextEditingController();
  final TextEditingController cantidadReparacionElementosArmadura = TextEditingController();
  final TextEditingController anioReparacionElementosArmadura = TextEditingController();
  final TextEditingController costoReparacionElementosArmadura = TextEditingController();
  final TextEditingController danoReparacionElementosArmadura = TextEditingController();
  final TextEditingController fotoReparacionElementosArmadura = TextEditingController();

// Cauce
  final TextEditingController calificacionCauce = TextEditingController();
  final TextEditingController mantenimientoCauce = TextEditingController();
  final TextEditingController inspeccionEspecialCauce = TextEditingController();
  final TextEditingController numeroFotosCauce = TextEditingController();
  final TextEditingController tipoDanoCauce = TextEditingController();

  final TextEditingController tipoReparacionCauce = TextEditingController();
  final TextEditingController cantidadReparacionCauce = TextEditingController();
  final TextEditingController anioReparacionCauce = TextEditingController();
  final TextEditingController costoReparacionCauce = TextEditingController();
  final TextEditingController danoReparacionCauce = TextEditingController();
  final TextEditingController fotoReparacionCauce = TextEditingController();




  @override
  Widget build(BuildContext context) {
    List<SectionData> secciones = [
      SectionData(tituloSeccion: "DATOS GENERALES DE LA INSPECCIÓN", campos: [
        FieldData(labelCampo: "Nombre", controller: nombre),
        FieldData(labelCampo: "Identificacion", controller: identificacion),
        FieldData(labelCampo: "Carretera", controller: carretera),
        FieldData(labelCampo: "Pr", controller: pr),
        FieldData(labelCampo: "Fecha de inspeccion", controller: fechaInspeccion),
        FieldData(labelCampo: "Inspector", controller: inspector),
        FieldData(labelCampo: "Proxima inspeccion", controller: proxInspec),
      ]),
      SectionData(tituloSeccion: "SUPERFICIE PUENTE", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacion),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimiento),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecial),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotos),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDano),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacion),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacion),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacion),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacion),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacion),
        ])
      ]),
      SectionData(tituloSeccion: "JUNTAS DE EXPANSIÓN", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacionJuntas),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimientoJuntas),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecialJuntas),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotosJuntas),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDanoJuntas),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacionJuntas),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacionJuntas),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacionJuntas),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacionJuntas),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacionJuntas),
        ])
      ]),

      SectionData(tituloSeccion: "ANDENES / BORDILLOS", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacionAndenes),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimientoAndenes),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecialAndenes),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotosAndenes),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDanoAndenes),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacionAndenes),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacionAndenes),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacionAndenes),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacionAndenes),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacionAndenes),
        ])
      ]),

      SectionData(tituloSeccion: "BARANDAS", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacionBarandas),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimientoBarandas),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecialBarandas),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotosBarandas),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDanoBarandas),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacionBarandas),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacionBarandas),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacionBarandas),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacionBarandas),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacionBarandas),
        ])
      ]),

      SectionData(tituloSeccion: "CONOS / TALUDES", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacionConos),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimientoConos),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecialConos),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotosConos),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDanoConos),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacionConos),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacionConos),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacionConos),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacionConos),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacionConos),
        ])
      ]),

      SectionData(tituloSeccion: "ALETAS", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacionAletas),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimientoAletas),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecialAletas),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotosAletas),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDanoAletas),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacionAletas),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacionAletas),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacionAletas),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacionAletas),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacionAletas),
        ])
      ]),

      SectionData(tituloSeccion: "ESTRIBOS", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacionEstribos),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimientoEstribos),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecialEstribos),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotosEstribos),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDanoEstribos),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacionEstribos),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacionEstribos),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacionEstribos),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacionEstribos),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacionEstribos),
        ])
      ]),
      SectionData(tituloSeccion: "PILAS", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacionPilas),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimientoPilas),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecialPilas),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotosPilas),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDanoPilas),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacionPilas),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacionPilas),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacionPilas),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacionPilas),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacionPilas),
        ])
      ]),

      // Apoyos
      SectionData(tituloSeccion: "APOYOS", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacionApoyos),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimientoApoyos),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecialApoyos),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotosApoyos),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDanoApoyos),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacionApoyos),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacionApoyos),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacionApoyos),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacionApoyos),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacionApoyos),
        ])
      ]),

      // Losa
      SectionData(tituloSeccion: "LOSA", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacionLosa),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimientoLosa),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecialLosa),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotosLosa),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDanoLosa),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacionLosa),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacionLosa),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacionLosa),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacionLosa),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacionLosa),
        ])
      ]),

      // Superficie Vigas / Largueros / Diafragmas Puente
      SectionData(tituloSeccion: "SUPERFICIE VIGAS / LARGUEROS / DIAFRAGMAS", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacionVigasLarguerosDiafragmas),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimientoVigasLarguerosDiafragmas),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecialVigasLarguerosDiafragmas),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotosVigasLarguerosDiafragmas),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDanoVigasLarguerosDiafragmas),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacionVigasLarguerosDiafragmas),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacionVigasLarguerosDiafragmas),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacionVigasLarguerosDiafragmas),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacionVigasLarguerosDiafragmas),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacionVigasLarguerosDiafragmas),
        ])
      ]),

      // Elementos de Arco
      SectionData(tituloSeccion: "ELEMENTOS DE ARCO", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacionElementosArco),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimientoElementosArco),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecialElementosArco),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotosElementosArco),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDanoElementosArco),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacionElementosArco),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacionElementosArco),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacionElementosArco),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacionElementosArco),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacionElementosArco),
        ])
      ]),

      // Cables / Pendolones / Torres / Macizos
      SectionData(tituloSeccion: "CABLES / PENDOLONES / TORRES / MACIZOS", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacionCablesPendolonesTorresMacizos),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimientoCablesPendolonesTorresMacizos),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecialCablesPendolonesTorresMacizos),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotosCablesPendolonesTorresMacizos),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDanoCablesPendolonesTorresMacizos),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacionCablesPendolonesTorresMacizos),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacionCablesPendolonesTorresMacizos),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacionCablesPendolonesTorresMacizos),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacionCablesPendolonesTorresMacizos),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacionCablesPendolonesTorresMacizos),
        ])
      ]),

      // Cauce
      SectionData(tituloSeccion: "CAUCE", campos: [
        FieldData(labelCampo: "Calificación", controller: calificacionCauce),
        FieldData(labelCampo: "Mantenimiento", controller: mantenimientoCauce),
        FieldData(labelCampo: "Inspección Especial", controller: inspeccionEspecialCauce),
        FieldData(labelCampo: "No. Fotos", controller: numeroFotosCauce),
        FieldData(labelCampo: "Tipo de daño", controller: tipoDanoCauce),
      ], subsecciones: [
        SectionData(tituloSeccion: "Reparaciones", campos: [
          FieldData(labelCampo: "Tipo de Reparación", controller: tipoReparacionCauce),
          FieldData(labelCampo: "Cantidad de Reparación", controller: cantidadReparacionCauce),
          FieldData(labelCampo: "Año de Reparación", controller: anioReparacionCauce),
          FieldData(labelCampo: "Costo de Reparación", controller: costoReparacionCauce),
          FieldData(labelCampo: "Daño Reparado", controller: danoReparacionCauce),
        ])
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