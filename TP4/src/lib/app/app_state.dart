import 'app_routes.dart';
import '../models/trip.dart';

typedef AppNavigator = void Function(AppScreen screen);
typedef FavoriteToggle = void Function(String tripId);
typedef ContrastSetter = void Function(bool enabled);
typedef TravelerNameSetter = void Function(String fullName);
typedef TripSelector = void Function(Trip trip);
