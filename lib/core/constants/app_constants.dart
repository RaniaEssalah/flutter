/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Chauffeur';
  static const String appVersion = '1.0.0';
  
  // API Endpoints (placeholder)
  static const String baseUrl = 'https://api.chauffeur.com/v1';
  
  // Map Configuration
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;
  static const double defaultZoom = 15.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String onboardingKey = 'onboarding_completed';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int phoneLength = 10;
  
  // Vehicle Categories
  static const String economyCategory = 'economy';
  static const String premiumCategory = 'premium';
  static const String luxuryCategory = 'luxury';
}

/// App assets paths
class AppAssets {
  AppAssets._();

  // Images
  static const String logo = 'assets/images/logo.png';
  static const String logoWhite = 'assets/images/logo_white.png';
  static const String onboarding1 = 'assets/images/onboarding_1.png';
  static const String onboarding2 = 'assets/images/onboarding_2.png';
  static const String onboarding3 = 'assets/images/onboarding_3.png';
  static const String mapPlaceholder = 'assets/images/map_placeholder.png';
  static const String profilePlaceholder = 'assets/images/profile_placeholder.png';
  
  // Vehicle Images
  static const String carEconomy = 'assets/images/car_economy.png';
  static const String carPremium = 'assets/images/car_premium.png';
  static const String carLuxury = 'assets/images/car_luxury.png';
  
  // Icons
  static const String iconGoogle = 'assets/icons/google.svg';
  static const String iconApple = 'assets/icons/apple.svg';
  static const String iconFacebook = 'assets/icons/facebook.svg';
  static const String iconVisa = 'assets/icons/visa.svg';
  static const String iconMastercard = 'assets/icons/mastercard.svg';
  static const String iconPaypal = 'assets/icons/paypal.svg';
  
  // Animations
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String carAnimation = 'assets/animations/car.json';
  static const String locationAnimation = 'assets/animations/location.json';
}

