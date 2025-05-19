class Constants {
  static const String authServiceUrl = 'https://api.bridgecare.com.co/auth';
  static const String bridgeServiceUrl = 'https://api.bridgecare.com.co/bridge';
  static const String inventoryServiceUrl =
      'https://api.bridgecare.com.co/inventory';
  static const String inspectionServiceUrl =
      'https://api.bridgecare.com.co/inspection';
  static const String imageServiceUrl = 'https://api.bridgecare.com.co/images';
  static const int chunkSize = 512 * 1024; // 512KB in bytes
  static const int maxImagesPerComponent = 5;
}
