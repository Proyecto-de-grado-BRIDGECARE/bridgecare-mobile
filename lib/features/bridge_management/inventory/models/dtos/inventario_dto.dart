class InventarioDTO {
  int? id;
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
    required id,
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
  factory InventarioDTO.fromJson(Map<String, dynamic> json) {
    return InventarioDTO(
      id: json['id'],
      observaciones: json['observaciones'],
      puente: PuenteDTO.fromJson(json['puente']),
      apoyo: json['apoyo'] != null ? ApoyoDTO.fromJson(json['apoyo']) : null,
      carga: json['carga'] != null ? CargaDTO.fromJson(json['carga']) : null,
      datosAdministrativos: json['datos_administrativos'] != null
          ? DatosAdministrativosDTO.fromJson(json['datos_administrativos'])
          : null,
      datosTecnicos: json['datos_tecnicos'] != null
          ? DatosTecnicosDTO.fromJson(json['datos_tecnicos'])
          : null,
      miembrosInteresados: json['miembros_interesados'] != null
          ? MiembrosInteresadosDTO.fromJson(json['miembros_interesados'])
          : null,
      pasos: (json['pasos'] as List<dynamic>)
          .map((p) => PasoDTO.fromJson(p))
          .toList(),
      posicionGeografica: json['posicion_geografica'] != null
          ? PosicionGeograficaDTO.fromJson(json['posicion_geografica'])
          : null,
      subestructura: json['subestructura'] != null
          ? SubestructuraDTO.fromJson(json['subestructura'])
          : null,
      superestructuras: (json['superestructuras'] as List<dynamic>)
          .map((s) => SuperestructuraDTO.fromJson(s))
          .toList(),
    );
  }
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
  factory ApoyoDTO.fromJson(Map<String, dynamic> json) {
    return ApoyoDTO(
      fijoSobreEstribo: json['fijoSobreEstribo'],
      movilSobreEstribo: json['movilSobreEstribo'],
      fijoEnPila: json['fijoEnPila'],
      movilEnPila: json['movilEnPila'],
      fijoEnViga: json['fijoEnViga'],
      movilEnViga: json['movilEnViga'],
      vehiculoDiseno: json['vehiculoDiseno'],
      claseDistribucionCarga: json['claseDistribucionCarga'],
    );
  }
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
  factory CargaDTO.fromJson(Map<String, dynamic> json) {
    return CargaDTO(
        longitudLuzCritica: json['longitudLuzCritica'],
        factorClasificacion: json['factorClasificacion'],
        fuerzaCortante: json['fuerzaCortante'],
        momento: json['momento'],
        lineaCargaPorRueda: json['lineaCargaPorRueda']);
  }
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
  factory DatosAdministrativosDTO.fromJson(Map<String, dynamic> json) {
    return DatosAdministrativosDTO(
      anioConstruccion: json['anioConstruccion'],
      anioReconstruccion: json['anioReconstruccion'],
      direccionAbscCarretera: json['direccionAbscCarretera'],
      requisitosInspeccion: json['requisitosInspeccion'],
      numeroSeccionesInspeccion: json['numeroSeccionesInspeccion'],
      estacionConteo: json['estacionConteo'],
      fechaRecoleccionDatos: json['fechaRecoleccionDatos'] != null
          ? DateTime.parse(json['fechaRecoleccionDatos'])
          : null,
    );
  }
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
  factory DatosTecnicosDTO.fromJson(Map<String, dynamic> json) {
    return DatosTecnicosDTO(
      longitudLuzMenor: (json['longitudLuzMenor'] as num?)?.toDouble(),
      longitudLuzMayor: (json['longitudLuzMayor'] as num?)?.toDouble(),
      longitudTotal: (json['longitudTotal'] as num?)?.toDouble(),
      anchoTablero: (json['anchoTablero'] as num?)?.toDouble(),
    );
  }
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
  factory DetalleDTO.fromJson(Map<String, dynamic> json) {
    return DetalleDTO(
        tipoBaranda: json['tipoBaranda'],
        superficieRodadura: json['superficieRodadura'],
        juntaExpansion: json['juntaExpansion']);
  }
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
  factory EstriboDTO.fromJson(Map<String, dynamic> json) {
    return EstriboDTO(
        tipo: json['tipo'],
        material: json['material'],
        tipoCimentacion: json['tipoCimentacion']);
  }
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
  factory MiembrosInteresadosDTO.fromJson(Map<String, dynamic> json) {
    return MiembrosInteresadosDTO(
      propietario: json['propietario'],
      departamento: json['departamento'],
      administradorVial: json['administradorVial'],
      proyectista: json['proyectista'],
      municipio: json['municipio'],
    );
  }

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
  factory PasoDTO.fromJson(Map<String, dynamic> json) {
    return PasoDTO(
      numero: json['numero'],
      tipoPaso: json['tipoPaso'],
      primero: json['primero'],
      supInf: json['supInf'],
      galiboI: (json['galiboI'] as num?)?.toDouble(),
      galiboIm: (json['galiboIm'] as num?)?.toDouble(),
      galiboDm: (json['galiboDm'] as num?)?.toDouble(),
      galiboD: (json['galiboD'] as num?)?.toDouble(),
    );
  }
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
  factory PilaDTO.fromJson(Map<String, dynamic> json) {
    return PilaDTO(
        tipo: json['tipo'],
        material: json['material'],
        tipoCimentacion: json['tipoCimentacion']);
  }
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
  factory PosicionGeograficaDTO.fromJson(Map<String, dynamic> json) {
    return PosicionGeograficaDTO(
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      altitud: (json['altitud'] as num?)?.toDouble(),
      coeficienteAceleracionSismica: json['coeficienteAceleracionSismica'],
      pasoCauce: json['pasoCauce'],
      existeVariante: json['existeVariante'],
      longitudVariante: (json['longitudVariante'] as num?)?.toDouble(),
      estado: json['estado'],
    );
  }
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
  factory PuenteDTO.fromJson(Map<String, dynamic> json) {
    return PuenteDTO(
      id: json['id'],
      nombre: json['nombre'],
      identif: json['identif'],
      carretera: json['carretera'],
      pr: json['pr'],
      regional: json['regional'],
    );
  }
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
  factory SenialDTO.fromJson(Map<String, dynamic> json) {
    return SenialDTO(
        cargaMaxima: json['cargaMaxima'],
        velocidadMaxima: json['velocidadMaxima'],
        otra: json['otra']);
  }
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
  factory SubestructuraDTO.fromJson(Map<String, dynamic> json) {
    return SubestructuraDTO(
      estribo:
      json['estribo'] != null ? EstriboDTO.fromJson(json['estribo']) : null,
      detalle:
      json['detalle'] != null ? DetalleDTO.fromJson(json['detalle']) : null,
      senial:
      json['senial'] != null ? SenialDTO.fromJson(json['senial']) : null,
      pila: json['pila'] != null ? PilaDTO.fromJson(json['pila']) : null,
    );
  }
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
  factory SuperestructuraDTO.fromJson(Map<String, dynamic> json) {
    return SuperestructuraDTO(
      tipo: json['tipo'],
      disenioTipo: json['disenioTipo'],
      tipoEstructuracionTransversal: json['tipoEstructuracionTransversal'],
      tipoEstructuracionLongitudinal: json['tipoEstructuracionLongitudinal'],
      material: json['material'],
    );
  }
}
extension InventarioDTODebugExtension on InventarioDTO {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'observaciones': observaciones,
      'puente': puente.toJson(),
      'apoyo': apoyo?.toJson(),
      'carga': carga?.toJson(),
      'datos_administrativos': datosAdministrativos?.toJson(),
      'datos_tecnicos': datosTecnicos?.toJson(),
      'miembros_interesados': miembrosInteresados?.toJson(),
      'pasos': pasos.map((p) => p.toJson()).toList(),
      'posicion_geografica': posicionGeografica?.toJson(),
      'subestructura': {
        'estribos': subestructura?.estribo?.toJson() ?? {},
        'detalles': subestructura?.detalle?.toJson() ?? {},
        'pilas': subestructura?.pila?.toJson() ?? {},
        'seniales': subestructura?.senial?.toJson() ?? {},
      },
      'superestructuras': superestructuras.map((s) => s.toJson()).toList(),
    };
  }
}

