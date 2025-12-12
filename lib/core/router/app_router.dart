import 'package:flutter/material.dart';
import 'package:chauffeur_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:chauffeur_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:chauffeur_app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:chauffeur_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:chauffeur_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:chauffeur_app/features/home/presentation/screens/main_screen.dart';
import 'package:chauffeur_app/features/booking/presentation/screens/location_search_screen.dart';
import 'package:chauffeur_app/features/booking/presentation/screens/vehicle_selection_screen.dart';
import 'package:chauffeur_app/features/booking/presentation/screens/booking_confirmation_screen.dart';
import 'package:chauffeur_app/features/ride/presentation/screens/ride_tracking_screen.dart';
import 'package:chauffeur_app/features/ride/presentation/screens/ride_completed_screen.dart';
import 'package:chauffeur_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:chauffeur_app/features/wallet/presentation/screens/add_funds_screen.dart';

/// App router configuration
class AppRouter {
  AppRouter._();

  // Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String main = '/main';
  static const String locationSearch = '/location-search';
  static const String vehicleSelection = '/vehicle-selection';
  static const String bookingConfirmation = '/booking-confirmation';
  static const String rideTracking = '/ride-tracking';
  static const String rideCompleted = '/ride-completed';
  static const String editProfile = '/edit-profile';
  static const String addFunds = '/add-funds';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashScreen(), settings);
      
      case onboarding:
        return _buildRoute(const OnboardingScreen(), settings);
      
      case signIn:
        return _buildRoute(const SignInScreen(), settings);
      
      case signUp:
        return _buildRoute(const SignUpScreen(), settings);
      
      case forgotPassword:
        return _buildRoute(const ForgotPasswordScreen(), settings);
      
      case main:
        return _buildRoute(const MainScreen(), settings);
      
      case locationSearch:
        return _buildSlideRoute(const LocationSearchScreen(), settings);
      
      case vehicleSelection:
        return _buildSlideRoute(const VehicleSelectionScreen(), settings);
      
      case bookingConfirmation:
        return _buildSlideRoute(const BookingConfirmationScreen(), settings);
      
      case rideTracking:
        return _buildRoute(const RideTrackingScreen(), settings);
      
      case rideCompleted:
        return _buildRoute(const RideCompletedScreen(), settings);
      
      case editProfile:
        return _buildSlideRoute(const EditProfileScreen(), settings);
      
      case addFunds:
        return _buildSlideRoute(const AddFundsScreen(), settings);
      
      default:
        return _buildRoute(const SplashScreen(), settings);
    }
  }

  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _buildSlideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

