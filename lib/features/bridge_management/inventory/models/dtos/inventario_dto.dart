class InventarioDTO {
  String? observaciones;
  PuenteDTO puente;
  ApoyoDTO? apoyo;
  CargaDTO? carga;
  DatosAdministrativosDTO? datosAdministrativos;
  DatosTecnicosDTO? datosTecnicos;
  MiembrosInteresadosDTO? miembrosInteresados;
  List<PasoDTO> pasos;
  PosicionGeograficaDTO? posicionGeografica;
  SubestructuraDTO? subestructura;
  List<SuperestructuraDTO> superestructuras;

  InventarioDTO({
    this.observaciones,
    required this.puente,
    this.apoyo,
    this.carga,
    this.datosAdministrativos,
    this.datosTecnicos,
    this.miembrosInteresados,
    required this.pasos,
    this.posicionGeografica,
    this.subestructura,
    required this.superestructuras,
  });

  Map<String, dynamic> toJson() => {
        'observaciones': observaciones,
        'puente': puente.toJson(),
        'datosTecnicos': datosTecnicos?.toJson(),
        'subestructura': subestructura?.toJson(),
      };
}

class ApoyoDTO {
  final int? fijoSobreEstribo;
  final int? movilSobreEstribo;
  final int? fijoEnPila;
  final int? movilEnPila;
  final int? fijoEnViga;
  final int? movilEnViga;
  final int? vehiculoDiseno;
  final int? claseDistribucionCarga;

  ApoyoDTO({
    this.fijoSobreEstribo,
    this.movilSobreEstribo,
    this.fijoEnPila,
    this.movilEnPila,
    this.fijoEnViga,
    this.movilEnViga,
    this.vehiculoDiseno,
    this.claseDistribucionCarga,
  });

  Map<String, dynamic> toJson() => {
        'fijoSobreEstribo': fijoSobreEstribo,
        'movilSobreEstribo': movilSobreEstribo,
        'fijoEnPila': fijoEnPila,
        'movilEnPila': movilEnPila,
        'fijoEnViga': fijoEnViga,
        'movilEnViga': movilEnViga,
        'vehiculoDiseno': vehiculoDiseno,
        'claseDistribucionCarga': claseDistribucionCarga,
      };
}

class CargaDTO {
  final double? longitudLuzCritica;
  final String? factorClasificacion;
  final String? fuerzaCortante;
  final String? momento;
  final String? lineaCargaPorRueda;

  CargaDTO({
    this.longitudLuzCritica,
    this.factorClasificacion,
    this.fuerzaCortante,
    this.momento,
    this.lineaCargaPorRueda,
  });

  Map<String, dynamic> toJson() => {
        'longitudLuzCritica': longitudLuzCritica,
        'factorClasificacion': factorClasificacion,
        'fuerzaCortante': fuerzaCortante,
        'momento': momento,
        'lineaCargaPorRueda': lineaCargaPorRueda,
      };
}

class DatosAdministrativosDTO {
  final int? anioConstruccion;
  final int? anioReconstruccion;
  final String? direccionAbscCarretera;
  final String? requisitosInspeccion;
  final String? numeroSeccionesInspeccion;
  final String? estacionConteo;
  final DateTime? fechaRecoleccionDatos;

  DatosAdministrativosDTO({
    this.anioConstruccion,
    this.anioReconstruccion,
    this.direccionAbscCarretera,
    this.requisitosInspeccion,
    this.numeroSeccionesInspeccion,
    this.estacionConteo,
    this.fechaRecoleccionDatos,
  });

  Map<String, dynamic> toJson() => {
        'anioConstruccion': anioConstruccion,
        'anioReconstruccion': anioReconstruccion,
        'direccionAbscCarretera': direccionAbscCarretera,
        'requisitosInspeccion': requisitosInspeccion,
        'numeroSeccionesInspeccion': numeroSeccionesInspeccion,
        'estacionConteo': estacionConteo,
        'fechaRecoleccionDatos': fechaRecoleccionDatos?.toIso8601String(),
      };
}

class DatosTecnicosDTO {
  final double? longitudLuzMenor;
  final double? longitudLuzMayor;
  final double? longitudTotal;
  final double? anchoTablero;

  DatosTecnicosDTO({
    this.longitudLuzMenor,
    this.longitudLuzMayor,
    this.longitudTotal,
    this.anchoTablero,
  });

  Map<String, dynamic> toJson() => {
        'longitudLuzMenor': longitudLuzMenor,
        'longitudLuzMayor': longitudLuzMayor,
        'longitudTotal': longitudTotal,
        'anchoTablero': anchoTablero,
      };
}

class DetalleDTO {
  final int? tipoBaranda;
  final int? superficieRodadura;
  final int? juntaExpansion;

  DetalleDTO({
    this.tipoBaranda,
    this.superficieRodadura,
    this.juntaExpansion,
  });

  Map<String, dynamic> toJson() => {
        'tipoBaranda': tipoBaranda,
        'superficieRodadura': superficieRodadura,
        'juntaExpansion': juntaExpansion,
      };
}

class EstriboDTO {
  final int? tipo;
  final int? material;
  final int? tipoCimentacion;

  EstriboDTO({
    this.tipo,
    this.material,
    this.tipoCimentacion,
  });

  Map<String, dynamic> toJson() => {
        'tipo': tipo,
        'material': material,
        'tipoCimentacion': tipoCimentacion,
      };
}

class MiembrosInteresadosDTO {
  final String? propietario;
  final String? departamento;
  final String? administradorVial;
  final String? proyectista;
  final String? municipio;

  MiembrosInteresadosDTO({
    this.propietario,
    this.departamento,
    this.administradorVial,
    this.proyectista,
    this.municipio,
  });

  Map<String, dynamic> toJson() => {
        'propietario': propietario,
        'departamento': departamento,
        'administradorVial': administradorVial,
        'proyectista': proyectista,
        'municipio': municipio,
      };
}

class PasoDTO {
  final int? numero;
  final String? tipoPaso;
  final bool? primero;
  final String? supInf;
  double? galiboI;
  double? galiboIm;
  double? galiboDm;
  double? galiboD;

  PasoDTO({
    this.numero,
    this.tipoPaso,
    this.primero,
    this.supInf,
    this.galiboI,
    this.galiboIm,
    this.galiboDm,
    this.galiboD,
  });

  Map<String, dynamic> toJson() => {
        'numero': numero,
        'tipoPaso': tipoPaso,
        'primero': primero,
        'supInf': supInf,
        'galiboI': galiboI,
        'galiboIm': galiboIm,
        'galiboDm': galiboDm,
        'galiboD': galiboD,
      };
}

class PilaDTO {
  final int? tipo;
  final int? material;
  final int? tipoCimentacion;

  PilaDTO({
    this.tipo,
    this.material,
    this.tipoCimentacion,
  });

  Map<String, dynamic> toJson() => {
        'tipo': tipo,
        'material': material,
        'tipoCimentacion': tipoCimentacion,
      };
}

class PosicionGeograficaDTO {
  final double? latitud;
  final double? longitud;
  final double? altitud;
  final String? coeficienteAceleracionSismica;
  final bool? pasoCauce;
  final bool? existeVariante;
  final double? longitudVariante;
  final String? estado;

  PosicionGeograficaDTO({
    this.latitud,
    this.longitud,
    this.altitud,
    this.coeficienteAceleracionSismica,
    this.pasoCauce,
    this.existeVariante,
    this.longitudVariante,
    this.estado,
  });

  Map<String, dynamic> toJson() => {
        'latitud': latitud,
        'longitud': longitud,
        'altitud': altitud,
        'coeficienteAceleracionSismica': coeficienteAceleracionSismica,
        'pasoCauce': pasoCauce,
        'existeVariante': existeVariante,
        'longitudVariante': longitudVariante,
        'estado': estado,
      };
}

class PuenteDTO {
  final int? id;
  final String? nombre;
  final String? identif;
  final String? carretera;
  final String? pr;
  final String? regional;

  PuenteDTO({
    this.id,
    this.nombre,
    this.identif,
    this.carretera,
    this.pr,
    this.regional,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'identif': identif,
        'carretera': carretera,
        'pr': pr,
        'regional': regional,
      };
}

class SenialDTO {
  String? cargaMaxima;
  String? velocidadMaxima;
  String? otra;

  SenialDTO({this.cargaMaxima, this.velocidadMaxima, this.otra});

  Map<String, dynamic> toJson() => {
        'cargaMaxima': cargaMaxima,
        'velocidadMaxima': velocidadMaxima,
        'otra': otra,
      };
}

class SubestructuraDTO {
  EstriboDTO? estribo;
  DetalleDTO? detalle;
  SenialDTO? senial;
  PilaDTO? pila;

  SubestructuraDTO({this.estribo, this.detalle, this.senial, this.pila});

  Map<String, dynamic> toJson() => {
        'estribo': estribo?.toJson(),
        'detalle': detalle?.toJson(),
        'senial': senial?.toJson(),
        'pila': pila?.toJson(),
      };
}

class SuperestructuraDTO {
  final int? tipo;
  final bool? disenioTipo;
  final int? tipoEstructuracionTransversal;
  final int? tipoEstructuracionLongitudinal;
  final int? material;

  SuperestructuraDTO({
    this.tipo,
    this.disenioTipo,
    this.tipoEstructuracionTransversal,
    this.tipoEstructuracionLongitudinal,
    this.material,
  });

  Map<String, dynamic> toJson() => {
        'tipo': tipo,
        'disenioTipo': disenioTipo,
        'tipoEstructuracionTransversal': tipoEstructuracionTransversal,
        'tipoEstructuracionLongitudinal': tipoEstructuracionLongitudinal,
        'material': material,
      };
}
