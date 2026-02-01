class ApiConfig {
  // Production (Render deployment) - USE THIS
  static const String _baseUrlProd = 'https://flutter-pickerball.onrender.com/api';
  static const String _signalRUrlProd = 'https://flutter-pickerball.onrender.com/hubs/pcm';

  // Local development (Backend running on localhost:8000)
  static const String _baseUrlDev = 'http://localhost:8000/api';
  static const String _signalRUrlDev = 'http://localhost:8000/hubs/pcm';

  /// Get the appropriate base URL based on environment
  static String get baseUrl {
    // Use Render production URL
    return _baseUrlProd;
  }

  /// Get the appropriate SignalR URL based on environment
  static String get signalRUrl {
    return _signalRUrlProd;
  }

  /// Get full API endpoint
  static String getEndpoint(String path) {
    return '$baseUrl$path';
  }
}
