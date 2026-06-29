import 'app_routes.dart';
import '../models/trip.dart';

typedef AppNavigator = void Function(AppScreen screen);
typedef FavoriteToggle = void Function(String tripId);
typedef ContrastSetter = void Function(bool enabled);
typedef TripSelector = void Function(Trip trip);
