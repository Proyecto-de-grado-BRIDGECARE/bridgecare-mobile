class Galibo {
  final int? id;
  final double i;
  final double im;
  final double dm;
  final double d;
  final int pasoId;

  Galibo({
    this.id,
    required this.i,
    required this.im,
    required this.dm,
    required this.d,
    required this.pasoId,
  });

  static const Map<String, dynamic> formFields = {
    'i': {'type': 'number', 'label': 'I'},
    'im': {'type': 'number', 'label': 'IM'},
    'dm': {'type': 'number', 'label': 'DM'},
    'd': {'type': 'number', 'label': 'D'},
  };
}
