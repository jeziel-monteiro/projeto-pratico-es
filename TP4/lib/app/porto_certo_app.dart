import 'package:flutter/material.dart';

import '../core/network/api_exception.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/data/auth_service.dart';
import '../features/auth/auth_screens.dart';
import '../features/onboarding/onboarding_screens.dart';
import '../features/owner/owner_panel_screen.dart';
import '../features/profile/profile_screens.dart';
import '../features/purchase/data/purchase_draft.dart';
import '../features/purchase/purchase_screens.dart';
import '../features/travel/data/favorites_repository.dart';
import '../features/travel/data/travel_repository.dart';
import '../features/travel/travel_screens.dart';
import '../features/travelers/data/traveler_repository.dart';
import '../data/mock_data.dart';
import '../models/my_trip.dart';
import '../models/trip.dart';
import 'app_routes.dart';

class PortoCertoApp extends StatelessWidget {
  const PortoCertoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Porto Certo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const PortoCertoShell(),
    );
  }
}

class PortoCertoShell extends StatefulWidget {
  const PortoCertoShell({super.key});

  @override
  State<PortoCertoShell> createState() => _PortoCertoShellState();
}

class _PortoCertoShellState extends State<PortoCertoShell> {
  AppScreen _screen = AppScreen.splash;
  final _favoritesRepository = FavoritesRepository();
  final _travelerRepository = TravelerRepository();
  final List<String> _favorites = [];
  final List<Trip> _favoriteTrips = [];
  TripSearchCriteria _searchCriteria = TripSearchCriteria(
    origin: 'Manaus',
    destination: 'Santarem',
    date: DateTime(2026, 7, 4),
  );
  Trip? _selectedTrip;
  PurchaseDraft? _purchaseDraft;
  MyTrip? _selectedBooking;
  String? _selectedTrackingTripId;
  bool _highContrast = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadHighContrastPreference();
  }

  @override
  void dispose() {
    _favoritesRepository.close();
    _travelerRepository.close();
    super.dispose();
  }

  void _nav(AppScreen screen) {
    setState(() {
      _screen = screen;
      if (screen == AppScreen.login && AuthService().currentUser == null) {
        _highContrast = false;
      }
    });
    if (screen == AppScreen.home) {
      _loadHighContrastPreference();
    }
  }

  Future<void> _loadHighContrastPreference() async {
    try {
      final user = AuthService().currentUser;
      if (user == null) return;

      final idToken = await user.getIdToken();
      if (idToken == null || idToken.isEmpty) return;

      final profile = await _travelerRepository.fetchMe(
        firebaseUid: user.uid,
        idToken: idToken,
        email: user.email,
      );
      if (!mounted) return;
      _applyHighContrast(profile.highContrast);
    } catch (_) {
      // A preferência será carregada novamente ao entrar ou abrir o perfil.
    }
  }

  void _toggleFavorite(String tripId) {
    _syncFavorite(tripId);
  }

  Future<void> _syncFavorite(String tripId) async {
    final wasFavorite = _favorites.contains(tripId);
    final previousIds = List<String>.from(_favorites);
    final previousTrips = List<Trip>.from(_favoriteTrips);

    setState(() {
      if (wasFavorite) {
        _favorites.remove(tripId);
        _favoriteTrips.removeWhere((trip) => trip.id == tripId);
      } else {
        _favorites.add(tripId);
      }
    });

    try {
      if (wasFavorite) {
        await _favoritesRepository.removeFavorite(tripId);
      } else {
        final trip = await _favoritesRepository.addFavorite(tripId);
        if (!mounted) return;
        setState(() {
          _favoriteTrips.removeWhere((item) => item.id == trip.id);
          _favoriteTrips.insert(0, trip);
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _favorites
          ..clear()
          ..addAll(previousIds);
        _favoriteTrips
          ..clear()
          ..addAll(previousTrips);
      });
      _showMessage(_favoriteErrorMessage(error));
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final trips = await _favoritesRepository.listFavorites();
      if (!mounted) return;
      setState(() {
        _favoriteTrips
          ..clear()
          ..addAll(trips);
        _favorites
          ..clear()
          ..addAll(trips.map((trip) => trip.id));
      });
    } catch (_) {
      // Favoritos exigem login; a navegação principal continua disponível.
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _favoriteErrorMessage(Object error) {
    if (error is FavoritesRepositoryException) return error.message;
    if (error is ApiException) return error.message;
    return 'Não foi possível atualizar seus favoritos.';
  }

  void _applyHighContrast(bool enabled) {
    setState(() => _highContrast = enabled);
  }

  void _setHighContrast(bool enabled) {
    final previousValue = _highContrast;
    _applyHighContrast(enabled);
    _saveHighContrastPreference(enabled, previousValue);
  }

  Future<void> _saveHighContrastPreference(
    bool enabled,
    bool previousValue,
  ) async {
    try {
      final user = AuthService().currentUser;
      if (user == null) return;

      final idToken = await user.getIdToken();
      if (idToken == null || idToken.isEmpty) return;

      await _travelerRepository.updatePreferences(
        firebaseUid: user.uid,
        idToken: idToken,
        email: user.email,
        highContrast: enabled,
      );
    } catch (_) {
      if (!mounted) return;
      _applyHighContrast(previousValue);
      _showMessage('Não foi possível salvar a preferência de acessibilidade.');
    }
  }

  void _setSearchCriteria(TripSearchCriteria criteria) {
    setState(() => _searchCriteria = criteria);
  }

  void _selectTrip(Trip trip) {
    setState(() {
      _selectedTrip = trip;
      _selectedBooking = null;
      _selectedTrackingTripId = trip.id;
      if (_purchaseDraft?.trip.id != trip.id) {
        _purchaseDraft = PurchaseDraft.fromTrip(trip);
      }
    });
  }

  PurchaseDraft get _activePurchaseDraft {
    return _purchaseDraft ??
        PurchaseDraft.fromTrip(_selectedTrip ?? MockData.trips.first);
  }

  void _setPurchaseDraft(PurchaseDraft draft) {
    setState(() {
      _purchaseDraft = draft;
      _selectedBooking = null;
      _selectedTrackingTripId = draft.trip.id;
    });
  }

  void _openBookingTicket(MyTrip booking) {
    setState(() {
      _selectedBooking = booking;
      _selectedTrackingTripId = booking.tripId;
      _screen = AppScreen.ticket;
    });
  }

  void _trackBooking(MyTrip booking) {
    setState(() {
      _selectedBooking = booking;
      _selectedTrackingTripId = booking.tripId;
      _screen = AppScreen.tracking;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: KeyedSubtree(key: ValueKey(_screen), child: _buildScreen()),
    );

    if (!_highContrast) return screen;

    final mediaQuery = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQuery.copyWith(boldText: true, highContrast: true),
      child: Theme(data: AppTheme.light(highContrast: true), child: screen),
    );
  }

  Widget _buildScreen() {
    return switch (_screen) {
      AppScreen.splash => SplashScreen(nav: _nav),
      AppScreen.onboarding => OnboardingScreen(nav: _nav),
      AppScreen.assistant => AssistantScreen(nav: _nav),
      AppScreen.login => LoginScreen(nav: _nav),
      AppScreen.register => RegisterScreen(nav: _nav),
      AppScreen.forgot => ForgotScreen(nav: _nav),
      AppScreen.home => HomeScreen(
        nav: _nav,
        favoriteIds: _favorites,
        toggleFavorite: _toggleFavorite,
        onTripSelected: _selectTrip,
        onSearch: _setSearchCriteria,
      ),
      AppScreen.search => SearchScreen(nav: _nav, onSearch: _setSearchCriteria),
      AppScreen.results => ResultsScreen(
        nav: _nav,
        searchCriteria: _searchCriteria,
        favoriteIds: _favorites,
        toggleFavorite: _toggleFavorite,
        onTripSelected: _selectTrip,
      ),
      AppScreen.vessel => VesselScreen(
        nav: _nav,
        selectedTrip: _selectedTrip,
        onTripSelected: _selectTrip,
      ),
      AppScreen.vesselTrips => VesselTripsScreen(
        nav: _nav,
        selectedTrip: _selectedTrip,
        onTripSelected: _selectTrip,
      ),
      AppScreen.vesselReviews => VesselReviewsScreen(
        nav: _nav,
        selectedTrip: _selectedTrip,
      ),
      AppScreen.purchase => PurchaseScreen(
        nav: _nav,
        draft: _activePurchaseDraft,
        onDraftChanged: _setPurchaseDraft,
      ),
      AppScreen.accommodation => AccommodationScreen(
        nav: _nav,
        draft: _activePurchaseDraft,
        onDraftChanged: _setPurchaseDraft,
      ),
      AppScreen.summary => SummaryScreen(
        nav: _nav,
        draft: _activePurchaseDraft,
      ),
      AppScreen.payment => PaymentScreen(
        nav: _nav,
        draft: _activePurchaseDraft,
      ),
      AppScreen.pix => PixScreen(
        nav: _nav,
        draft: _activePurchaseDraft,
        onDraftChanged: _setPurchaseDraft,
      ),
      AppScreen.boleto => BoletoScreen(
        nav: _nav,
        draft: _activePurchaseDraft,
        onDraftChanged: _setPurchaseDraft,
      ),
      AppScreen.creditCard => CreditCardScreen(
        nav: _nav,
        draft: _activePurchaseDraft,
        onDraftChanged: _setPurchaseDraft,
      ),
      AppScreen.rejected => RejectedScreen(nav: _nav),
      AppScreen.approved => ApprovedScreen(
        nav: _nav,
        draft: _activePurchaseDraft,
      ),
      AppScreen.ticket => TicketScreen(
        nav: _nav,
        draft: _activePurchaseDraft,
        booking: _selectedBooking,
      ),
      AppScreen.myTrips => MyTripsScreen(
        nav: _nav,
        onBookingSelected: _openBookingTicket,
        onTrackingSelected: _trackBooking,
      ),
      AppScreen.favorites => FavoritesScreen(
        nav: _nav,
        favoriteIds: _favorites,
        favoriteTrips: _favoriteTrips,
        toggleFavorite: _toggleFavorite,
        onTripSelected: _selectTrip,
      ),
      AppScreen.tracking => TrackingScreen(
        nav: _nav,
        tripId: _selectedTrackingTripId ?? _selectedTrip?.id,
      ),
      AppScreen.notifications => NotificationsScreen(nav: _nav),
      AppScreen.profile => ProfileScreen(
        nav: _nav,
        applyHighContrast: _applyHighContrast,
      ),
      AppScreen.settings => SettingsScreen(nav: _nav),
      AppScreen.changePassword => ChangePasswordScreen(nav: _nav),
      AppScreen.accessibility => AccessibilityScreen(
        nav: _nav,
        highContrast: _highContrast,
        setHighContrast: _setHighContrast,
      ),
      AppScreen.highContrast => HighContrastScreen(
        nav: _nav,
        setHighContrast: _setHighContrast,
      ),
      AppScreen.help => HelpScreen(nav: _nav),
      AppScreen.terms => TermsScreen(nav: _nav),
      AppScreen.privacy => PrivacyScreen(nav: _nav),
      AppScreen.guidePurchase => GuideScreen(
        nav: _nav,
        topic: GuideTopic.purchase,
      ),
      AppScreen.guidePayment => GuideScreen(
        nav: _nav,
        topic: GuideTopic.payment,
      ),
      AppScreen.guideAccommodation => GuideScreen(
        nav: _nav,
        topic: GuideTopic.accommodation,
      ),
      AppScreen.ownerPanel => OwnerPanelScreen(nav: _nav),
    };
  }
}
