import 'package:flutter/foundation.dart';

class AppConfig {
  static const String googleMapsApiKey = 'AIzaSyDT4RYNcUdQ6279kqNgHV1Tgn2d9biKKKY';
  static const String mapboxApiKey = 'pk.eyJ1IjoiYXJ0dXJvMjgwMSIsImEiOiJjbWN2YnMzeGgwOXl4Mm5xMndzZ2ljN3RnIn0.zRVCH2FuwOgyVersI38xHw';
  static const String appName = 'SIG Shoes - Repartidor';
  static const String companyName = 'SIG Shoes';
  
  // Coordenadas de Santa Cruz de la Sierra, Bolivia
  static const double defaultLatitude = -17.7837;
  static const double defaultLongitude = -63.1821;
  
  // Configuraciones de la aplicación
  static const int maxOrdersPerRoute = 10;
  static const int deliveryTimeoutMinutes = 30;
  
  // URLs de la API (simuladas)
  static const String baseApiUrl = 'https://api.sigshoes.com/v1';
  static const String ordersEndpoint = '/orders';
  static const String deliveryEndpoint = '/delivery';
  
  // Configuración de debug
  static bool get isDebugMode => kDebugMode;
}
