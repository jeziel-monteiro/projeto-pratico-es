import 'package:flutter/widgets.dart';

import '../features/auth/auth_screens.dart';
import '../features/onboarding/onboarding_screens.dart';
import '../features/owner/owner_panel_screen.dart';
import '../features/profile/profile_screens.dart';
import '../features/purchase/data/purchase_draft.dart';
import '../features/purchase/purchase_screens.dart';
import '../features/travel/data/travel_repository.dart';
import '../features/travel/travel_screens.dart';
import '../models/my_trip.dart';
import '../models/trip.dart';
import 'app_routes.dart';
import 'app_state.dart';

Widget buildPortoCertoScreen({
  required AppScreen screen,
  required AppNavigator nav,
  required String? travelerName,
  required List<String> favoriteIds,
  required List<Trip> favoriteTrips,
  required TripSearchCriteria searchCriteria,
  required PurchaseDraft activePurchaseDraft,
  required bool highContrast,
  required FavoriteToggle toggleFavorite,
  required TripSelector onTripSelected,
  required ValueChanged<TripSearchCriteria> onSearch,
  required ValueChanged<PurchaseDraft> onDraftChanged,
  required ValueChanged<MyTrip> onBookingSelected,
  required ValueChanged<MyTrip> onTrackingSelected,
  required ContrastSetter setHighContrast,
  required ContrastSetter applyHighContrast,
  required TravelerNameSetter setTravelerName,
  Trip? selectedTrip,
  MyTrip? selectedBooking,
  String? selectedTrackingTripId,
}) {
  return switch (screen) {
    AppScreen.splash => SplashScreen(nav: nav),
    AppScreen.onboarding => OnboardingScreen(nav: nav),
    AppScreen.assistant => AssistantScreen(nav: nav),
    AppScreen.login => LoginScreen(nav: nav, setTravelerName: setTravelerName),
    AppScreen.register => RegisterScreen(
      nav: nav,
      setTravelerName: setTravelerName,
    ),
    AppScreen.forgot => ForgotScreen(nav: nav),
    AppScreen.home => HomeScreen(
      nav: nav,
      travelerName: travelerName,
      favoriteIds: favoriteIds,
      toggleFavorite: toggleFavorite,
      onTripSelected: onTripSelected,
      onSearch: onSearch,
    ),
    AppScreen.search => SearchScreen(nav: nav, onSearch: onSearch),
    AppScreen.results => ResultsScreen(
      nav: nav,
      searchCriteria: searchCriteria,
      favoriteIds: favoriteIds,
      toggleFavorite: toggleFavorite,
      onTripSelected: onTripSelected,
    ),
    AppScreen.vessel => VesselScreen(
      nav: nav,
      selectedTrip: selectedTrip,
      onTripSelected: onTripSelected,
    ),
    AppScreen.vesselTrips => VesselTripsScreen(
      nav: nav,
      selectedTrip: selectedTrip,
      onTripSelected: onTripSelected,
    ),
    AppScreen.vesselReviews => VesselReviewsScreen(
      nav: nav,
      selectedTrip: selectedTrip,
    ),
    AppScreen.purchase => PurchaseScreen(
      nav: nav,
      draft: activePurchaseDraft,
      onDraftChanged: onDraftChanged,
    ),
    AppScreen.accommodation => AccommodationScreen(
      nav: nav,
      draft: activePurchaseDraft,
      onDraftChanged: onDraftChanged,
    ),
    AppScreen.summary => SummaryScreen(nav: nav, draft: activePurchaseDraft),
    AppScreen.payment => PaymentScreen(nav: nav, draft: activePurchaseDraft),
    AppScreen.pix => PixScreen(
      nav: nav,
      draft: activePurchaseDraft,
      onDraftChanged: onDraftChanged,
    ),
    AppScreen.boleto => BoletoScreen(
      nav: nav,
      draft: activePurchaseDraft,
      onDraftChanged: onDraftChanged,
    ),
    AppScreen.creditCard => CreditCardScreen(
      nav: nav,
      draft: activePurchaseDraft,
      onDraftChanged: onDraftChanged,
    ),
    AppScreen.rejected => RejectedScreen(nav: nav),
    AppScreen.approved => ApprovedScreen(nav: nav, draft: activePurchaseDraft),
    AppScreen.ticket => TicketScreen(
      nav: nav,
      draft: activePurchaseDraft,
      booking: selectedBooking,
    ),
    AppScreen.myTrips => MyTripsScreen(
      nav: nav,
      onBookingSelected: onBookingSelected,
      onTrackingSelected: onTrackingSelected,
    ),
    AppScreen.favorites => FavoritesScreen(
      nav: nav,
      favoriteIds: favoriteIds,
      favoriteTrips: favoriteTrips,
      toggleFavorite: toggleFavorite,
      onTripSelected: onTripSelected,
    ),
    AppScreen.tracking => TrackingScreen(
      nav: nav,
      tripId: selectedTrackingTripId ?? selectedTrip?.id,
    ),
    AppScreen.notifications => NotificationsScreen(nav: nav),
    AppScreen.profile => ProfileScreen(
      nav: nav,
      applyHighContrast: applyHighContrast,
      setTravelerName: setTravelerName,
    ),
    AppScreen.settings => SettingsScreen(nav: nav),
    AppScreen.changePassword => ChangePasswordScreen(nav: nav),
    AppScreen.accessibility => AccessibilityScreen(
      nav: nav,
      highContrast: highContrast,
      setHighContrast: setHighContrast,
    ),
    AppScreen.highContrast => HighContrastScreen(
      nav: nav,
      setHighContrast: setHighContrast,
    ),
    AppScreen.help => HelpScreen(nav: nav),
    AppScreen.terms => TermsScreen(nav: nav),
    AppScreen.privacy => PrivacyScreen(nav: nav),
    AppScreen.guidePurchase => GuideScreen(
      nav: nav,
      topic: GuideTopic.purchase,
    ),
    AppScreen.guidePayment => GuideScreen(nav: nav, topic: GuideTopic.payment),
    AppScreen.guideAccommodation => GuideScreen(
      nav: nav,
      topic: GuideTopic.accommodation,
    ),
    AppScreen.ownerPanel => OwnerPanelScreen(nav: nav),
  };
}
