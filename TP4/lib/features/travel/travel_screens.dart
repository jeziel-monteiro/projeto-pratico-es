import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../app/app_state.dart';
import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/network_image_box.dart';
import '../../core/widgets/pc_badge.dart';
import '../../core/widgets/pc_button.dart';
import '../../core/widgets/pc_card.dart';
import '../../core/widgets/pc_chip.dart';
import '../../core/widgets/pc_text_field.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/star_rating.dart';
import '../../core/widgets/trip_card.dart';
import '../../data/mock_data.dart';
import '../../models/my_trip.dart';
import '../../models/notification_item.dart';
import '../../models/review.dart';
import '../../models/trip.dart';
import '../../models/trip_tracking.dart';
import 'data/my_trips_repository.dart';
import 'data/notifications_repository.dart';
import 'data/reviews_repository.dart';
import 'data/travel_repository.dart';
import 'validation/trip_search_validator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.nav,
    required this.travelerName,
    required this.favoriteIds,
    required this.toggleFavorite,
    required this.onTripSelected,
    required this.onSearch,
  });

  final AppNavigator nav;
  final String? travelerName;
  final List<String> favoriteIds;
  final FavoriteToggle toggleFavorite;
  final TripSelector onTripSelected;
  final ValueChanged<TripSearchCriteria> onSearch;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = TravelRepository();
  List<Trip> _featuredTrips = const [];
  bool _loadingFeaturedTrips = true;
  String? _featuredTripsError;

  String _buildGreetingName(String? fullName) {
    final normalizedName = fullName?.trim();
    if (normalizedName == null || normalizedName.isEmpty) {
      return 'Viajante Porto Certo';
    }

    return normalizedName.split(RegExp(r'\s+')).first;
  }

  @override
  void initState() {
    super.initState();
    _loadFeaturedTrips();
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }

  Future<void> _loadFeaturedTrips() async {
    setState(() {
      _loadingFeaturedTrips = true;
      _featuredTripsError = null;
    });

    try {
      final trips = await _repository.listFeaturedTrips();
      if (!mounted) return;
      setState(() {
        _featuredTrips = trips;
        _loadingFeaturedTrips = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _featuredTripsError =
            'Não foi possível carregar os destaques. Verifique se a API está rodando.';
        _loadingFeaturedTrips = false;
      });
    }
  }

  void _openPopularRoute(String origin, String destination, DateTime date) {
    widget.onSearch(
      TripSearchCriteria(origin: origin, destination: destination, date: date),
    );
    widget.nav(AppScreen.results);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final highContrast = Theme.of(context).brightness == Brightness.dark;
    final greetingName = _buildGreetingName(widget.travelerName);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: PortoBottomNav(
        active: AppScreen.home,
        nav: widget.nav,
      ),
      body: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: highContrast
                    ? [Colors.black, Colors.black]
                    : [AppColors.navy, AppColors.primary],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bom dia,',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                greetingName,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        _HeaderAction(
                          icon: Icons.notifications_outlined,
                          onTap: () => widget.nav(AppScreen.notifications),
                          dot: true,
                        ),
                        const SizedBox(width: 10),
                        _HeaderAction(
                          icon: Icons.person_outline,
                          onTap: () => widget.nav(AppScreen.profile),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Material(
                      color: colors.surfaceContainer,
                      elevation: highContrast ? 0 : 8,
                      shadowColor: colors.primary.withValues(alpha: 0.25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: highContrast
                            ? BorderSide(color: colors.outline, width: 2)
                            : BorderSide.none,
                      ),
                      child: InkWell(
                        onTap: () => widget.nav(AppScreen.search),
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: colors.primary),
                              const SizedBox(width: 12),
                              Text(
                                'Para onde você vai?',
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
              children: [
                Transform.translate(
                  offset: const Offset(0, -14),
                  child: PcCard(
                    child: Column(
                      children: [
                        SectionTitle(
                          title: 'Viagens em Destaque',
                          actionLabel: 'Ver todas',
                          onAction: () => widget.nav(AppScreen.search),
                        ),
                        const SizedBox(height: 8),
                        if (_loadingFeaturedTrips)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_featuredTripsError != null)
                          _HomeTripsMessage(
                            icon: Icons.cloud_off_outlined,
                            title: 'Destaques indisponíveis',
                            message: _featuredTripsError!,
                            onRetry: _loadFeaturedTrips,
                          )
                        else if (_featuredTrips.isEmpty)
                          _HomeTripsMessage(
                            icon: Icons.directions_boat_outlined,
                            title: 'Sem viagens em destaque',
                            message:
                                'Novas saídas aparecerão aqui assim que forem cadastradas.',
                            onRetry: _loadFeaturedTrips,
                          )
                        else
                          ..._featuredTrips
                              .take(2)
                              .map(
                                (trip) => TripCard(
                                  trip: trip,
                                  isFavorite: widget.favoriteIds.contains(
                                    trip.id,
                                  ),
                                  onFavorite: () =>
                                      widget.toggleFavorite(trip.id),
                                  onDetails: () {
                                    widget.onTripSelected(trip);
                                    widget.nav(AppScreen.vessel);
                                  },
                                  onBuy: () {
                                    widget.onTripSelected(trip);
                                    widget.nav(AppScreen.purchase);
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                PcCard(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Rotas Populares'),
                      const SizedBox(height: 8),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.55,
                        children: [
                          _RouteTile(
                            origin: 'Manaus',
                            destination: 'Santarem',
                            onTap: () => _openPopularRoute(
                              'Manaus',
                              'Santarem',
                              DateTime(2026, 7, 4),
                            ),
                          ),
                          _RouteTile(
                            origin: 'Manaus',
                            destination: 'Parintins',
                            onTap: () => _openPopularRoute(
                              'Manaus',
                              'Parintins',
                              DateTime(2026, 7, 5),
                            ),
                          ),
                          _RouteTile(
                            origin: 'Santarem',
                            destination: 'Belem',
                            onTap: () => _openPopularRoute(
                              'Santarem',
                              'Belem',
                              DateTime(2026, 7, 7),
                            ),
                          ),
                          _RouteTile(
                            origin: 'Belem',
                            destination: 'Santana/Macapa',
                            onTap: () => _openPopularRoute(
                              'Belem',
                              'Santana/Macapa',
                              DateTime(2026, 7, 9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Acesso Rápido'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _QuickAction(
                            icon: Icons.search,
                            label: 'Buscar',
                            onTap: () => widget.nav(AppScreen.search),
                          ),
                          _QuickAction(
                            icon: Icons.favorite_border,
                            label: 'Favoritos',
                            onTap: () => widget.nav(AppScreen.favorites),
                          ),
                          _QuickAction(
                            icon: Icons.navigation_outlined,
                            label: 'Rastrear',
                            onTap: () => widget.nav(AppScreen.tracking),
                          ),
                          _QuickAction(
                            icon: Icons.help_outline,
                            label: 'Ajuda',
                            onTap: () => widget.nav(AppScreen.help),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.nav, required this.onSearch});

  final AppNavigator nav;
  final ValueChanged<TripSearchCriteria> onSearch;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _origin = TextEditingController();
  final _destination = TextEditingController();
  final _date = TextEditingController();
  final _repository = TravelRepository();
  List<PortOption> _ports = const [];
  bool _loadingPorts = true;
  String? _error;

  @override
  void dispose() {
    _origin.dispose();
    _destination.dispose();
    _date.dispose();
    _repository.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPorts();
  }

  Future<void> _loadPorts() async {
    try {
      final ports = await _repository.listPorts();
      if (!mounted) return;
      setState(() {
        _ports = ports;
        _loadingPorts = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingPorts = false);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
      initialDate: DateTime(now.year, now.month, now.day + 1),
    );
    if (picked != null) {
      _date.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  void _submit() {
    final validation = TripSearchValidator.validate(
      origin: _origin.text,
      destination: _destination.text,
      date: _date.text,
    );
    if (!validation.isValid) {
      setState(() => _error = validation.message);
      return;
    }
    setState(() => _error = null);
    widget.onSearch(
      TripSearchCriteria(
        origin: _origin.text.trim(),
        destination: _destination.text.trim(),
        date: validation.date!,
      ),
    );
    widget.nav(AppScreen.results);
  }

  void _quickSearch(String origin, String destination, DateTime date) {
    widget.onSearch(
      TripSearchCriteria(origin: origin, destination: destination, date: date),
    );
    widget.nav(AppScreen.results);
  }

  @override
  Widget build(BuildContext context) {
    final cities = _ports.isEmpty
        ? [
            'Manaus',
            'Itacoatiara',
            'Parintins',
            'Obidos',
            'Santarem',
            'Monte Alegre',
            'Almeirim',
            'Belem',
            'Santana/Macapa',
          ]
        : _ports.map((port) => port.city).toSet().toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: PortoBottomNav(
        active: AppScreen.search,
        nav: widget.nav,
      ),
      body: Column(
        children: [
          AppHeader(
            title: 'Buscar Viagem',
            backTo: AppScreen.home,
            nav: widget.nav,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PcCard(
                  child: Column(
                    children: [
                      if (_error != null) ...[
                        _WarningBox(message: _error!),
                        const SizedBox(height: 14),
                      ],
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            children: [
                              PcTextField(
                                label: 'Origem',
                                hint: 'De onde você sai?',
                                icon: Icons.place_outlined,
                                controller: _origin,
                              ),
                              const SizedBox(height: 14),
                              PcTextField(
                                label: 'Destino',
                                hint: 'Para onde vai?',
                                icon: Icons.location_on_outlined,
                                controller: _destination,
                              ),
                            ],
                          ),
                          Positioned(
                            right: -24,
                            top: 73,
                            child: IconButton.filledTonal(
                              tooltip: 'Inverter origem e destino',
                              onPressed: () {
                                final temp = _origin.text;
                                _origin.text = _destination.text;
                                _destination.text = temp;
                              },
                              icon: const Icon(Icons.swap_vert, size: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      PcTextField(
                        label: 'Data',
                        hint: 'DD/MM/AAAA',
                        icon: Icons.calendar_month_outlined,
                        controller: _date,
                        readOnly: true,
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 16),
                      PcButton(
                        label: 'Buscar Viagens',
                        icon: Icons.search,
                        full: true,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle(
                        title: _loadingPorts
                            ? 'Carregando Portos'
                            : 'Cidades Populares',
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: cities.map((city) {
                          final active =
                              _origin.text == city || _destination.text == city;
                          return PcChip(
                            label: city,
                            active: active,
                            onTap: () {
                              setState(() {
                                if (_origin.text.isEmpty) {
                                  _origin.text = city;
                                } else {
                                  _destination.text = city;
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Buscas Recentes'),
                      _RecentSearch(
                        label: 'Manaus -> Santarem',
                        date: '04/07',
                        onTap: () => _quickSearch(
                          'Manaus',
                          'Santarem',
                          DateTime(2026, 7, 4),
                        ),
                      ),
                      _RecentSearch(
                        label: 'Belem -> Santana/Macapa',
                        date: '09/07',
                        onTap: () => _quickSearch(
                          'Belem',
                          'Santana/Macapa',
                          DateTime(2026, 7, 9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({
    super.key,
    required this.nav,
    required this.searchCriteria,
    required this.favoriteIds,
    required this.toggleFavorite,
    required this.onTripSelected,
  });

  final AppNavigator nav;
  final TripSearchCriteria searchCriteria;
  final List<String> favoriteIds;
  final FavoriteToggle toggleFavorite;
  final TripSelector onTripSelected;

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final _repository = TravelRepository();
  String _filter = '';
  List<Trip> _trips = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  @override
  void didUpdateWidget(covariant ResultsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchCriteria.apiDate != widget.searchCriteria.apiDate ||
        oldWidget.searchCriteria.origin != widget.searchCriteria.origin ||
        oldWidget.searchCriteria.destination !=
            widget.searchCriteria.destination) {
      _loadTrips();
    }
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }

  Future<void> _loadTrips() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final trips = await _repository.searchTrips(widget.searchCriteria);
      if (!mounted) return;
      setState(() {
        _trips = trips;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error =
            'Não foi possível buscar viagens. Verifique se a API está rodando.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final trips = _trips.where((trip) {
      if (_filter == 'available') return trip.seats > 0;
      if (_filter == 'ac') return trip.amenities.contains('AC');
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: widget.searchCriteria.routeLabel,
            subtitle:
                '${widget.searchCriteria.displayDate} - ${trips.length} viagens',
            backTo: AppScreen.search,
            nav: widget.nav,
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  PcChip(
                    label: 'Todas',
                    active: _filter.isEmpty,
                    onTap: () => setState(() => _filter = ''),
                  ),
                  const SizedBox(width: 8),
                  PcChip(
                    label: 'Com vagas',
                    active: _filter == 'available',
                    onTap: () => setState(() => _filter = 'available'),
                  ),
                  const SizedBox(width: 8),
                  PcChip(
                    label: 'Com AC',
                    active: _filter == 'ac',
                    onTap: () => setState(() => _filter = 'ac'),
                  ),
                  const SizedBox(width: 8),
                  const PcChip(label: 'Menor preço'),
                  const SizedBox(width: 8),
                  const PcChip(label: 'Mais avaliados'),
                ],
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: _error != null
                        ? [
                            const SizedBox(height: 90),
                            const Icon(
                              Icons.cloud_off_outlined,
                              color: AppColors.muted,
                              size: 56,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Falha na busca',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.muted),
                            ),
                            const SizedBox(height: 18),
                            PcButton(
                              label: 'Tentar Novamente',
                              icon: Icons.refresh,
                              onPressed: _loadTrips,
                            ),
                          ]
                        : trips.isEmpty
                        ? [
                            const SizedBox(height: 90),
                            const Icon(
                              Icons.search_off,
                              color: AppColors.muted,
                              size: 56,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Nenhuma viagem encontrada',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Tente alterar os filtros ou a data de busca.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.muted),
                            ),
                          ]
                        : trips
                              .map(
                                (trip) => TripCard(
                                  trip: trip,
                                  isFavorite: widget.favoriteIds.contains(
                                    trip.id,
                                  ),
                                  onFavorite: () =>
                                      widget.toggleFavorite(trip.id),
                                  onDetails: () {
                                    widget.onTripSelected(trip);
                                    widget.nav(AppScreen.vessel);
                                  },
                                  onBuy: () {
                                    widget.onTripSelected(trip);
                                    widget.nav(AppScreen.purchase);
                                  },
                                ),
                              )
                              .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class VesselScreen extends StatefulWidget {
  const VesselScreen({
    super.key,
    required this.nav,
    required this.onTripSelected,
    this.selectedTrip,
  });

  final AppNavigator nav;
  final TripSelector onTripSelected;
  final Trip? selectedTrip;

  @override
  State<VesselScreen> createState() => _VesselScreenState();
}

class _VesselScreenState extends State<VesselScreen> {
  final _repository = TravelRepository();
  final _reviewsRepository = ReviewsRepository();
  late Trip _trip = widget.selectedTrip ?? MockData.trips.first;
  List<Trip> _relatedTrips = const [];
  List<Review> _reviewPreview = const [];
  ReviewSummary _reviewSummary = ReviewSummary.empty;
  bool _loading = false;
  bool _loadingRelatedTrips = true;
  bool _loadingReviews = true;
  String? _error;
  String? _relatedTripsError;
  String? _reviewsError;

  @override
  void initState() {
    super.initState();
    _loadSelectedTrip();
    _loadRelatedTrips();
    _loadReviews();
  }

  @override
  void didUpdateWidget(covariant VesselScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTrip?.id != widget.selectedTrip?.id) {
      _trip = widget.selectedTrip ?? MockData.trips.first;
      _loadSelectedTrip();
      _loadRelatedTrips();
      _loadReviews();
    }
  }

  @override
  void dispose() {
    _repository.close();
    _reviewsRepository.close();
    super.dispose();
  }

  Future<void> _loadSelectedTrip() async {
    final selectedTrip = widget.selectedTrip;
    if (selectedTrip == null || selectedTrip.id.startsWith('mock-')) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final trip = await _repository.getTrip(selectedTrip.id);
      if (!mounted) return;
      setState(() {
        _trip = trip;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error =
            'Não foi possível atualizar os detalhes. Exibindo dados carregados da busca.';
        _loading = false;
      });
    }
  }

  Future<void> _loadRelatedTrips() async {
    final selectedTrip = widget.selectedTrip;
    if (selectedTrip == null || selectedTrip.id.startsWith('mock-')) {
      setState(() {
        _relatedTrips = const [];
        _loadingRelatedTrips = false;
        _relatedTripsError = null;
      });
      return;
    }

    setState(() {
      _loadingRelatedTrips = true;
      _relatedTripsError = null;
    });

    try {
      final trips = await _repository.listRelatedTrips(selectedTrip.id);
      if (!mounted) return;
      setState(() {
        _relatedTrips = trips;
        _loadingRelatedTrips = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _relatedTripsError =
            'Não foi possível carregar as próximas viagens desta embarcação.';
        _loadingRelatedTrips = false;
      });
    }
  }

  Future<void> _loadReviews() async {
    final selectedTrip = widget.selectedTrip;
    if (selectedTrip == null || selectedTrip.id.startsWith('mock-')) {
      setState(() {
        _reviewPreview = const [];
        _reviewSummary = ReviewSummary.empty;
        _loadingReviews = false;
        _reviewsError = null;
      });
      return;
    }

    setState(() {
      _loadingReviews = true;
      _reviewsError = null;
    });

    try {
      final bundle = await _reviewsRepository.listTripReviews(selectedTrip.id);
      if (!mounted) return;
      setState(() {
        _reviewSummary = bundle.summary;
        _reviewPreview = bundle.reviews.take(2).toList();
        _loadingReviews = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _reviewsError =
            'Não foi possível carregar as avaliações desta embarcação.';
        _loadingReviews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = _trip;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 230,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton.filledTonal(
              onPressed: () => widget.nav(AppScreen.results),
              icon: const Icon(Icons.chevron_left),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  NetworkImageBox(url: trip.imageUrl, borderRadius: 0),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.70),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: Text(
                      trip.vessel,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                PcCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_loading) ...[
                        const LinearProgressIndicator(minHeight: 3),
                        const SizedBox(height: 14),
                      ],
                      if (_error != null) ...[
                        _WarningBox(message: _error!),
                        const SizedBox(height: 14),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              trip.vessel,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(fontSize: 21),
                            ),
                          ),
                          PcBadge(
                            label: '${trip.rating}',
                            tone: PcBadgeTone.orange,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Reg. ${trip.registration}',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _Metric(
                            label: 'Capacidade',
                            value: '${trip.capacity} pass.',
                            icon: Icons.groups_outlined,
                          ),
                          _Metric(
                            label: 'Velocidade',
                            value: trip.speed,
                            icon: Icons.navigation_outlined,
                          ),
                          _Metric(
                            label: 'Registro',
                            value: trip.registration,
                            icon: Icons.anchor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(title: 'Comodidades'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: trip.amenities
                            .map((item) => PcChip(label: item, active: true))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      SectionTitle(
                        title: 'Próximas Viagens',
                        actionLabel: 'Ver todas',
                        onAction: () => widget.nav(AppScreen.vesselTrips),
                      ),
                      if (_loadingRelatedTrips)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_relatedTripsError != null)
                        _HomeTripsMessage(
                          icon: Icons.cloud_off_outlined,
                          title: 'Viagens indisponíveis',
                          message: _relatedTripsError!,
                          onRetry: _loadRelatedTrips,
                        )
                      else if (_relatedTrips.isEmpty)
                        _HomeTripsMessage(
                          icon: Icons.directions_boat_outlined,
                          title: 'Nenhuma próxima viagem',
                          message:
                              'Novas saídas desta embarcação aparecerão aqui.',
                          onRetry: _loadRelatedTrips,
                        )
                      else
                        ..._relatedTrips
                            .take(2)
                            .map(
                              (item) => _VesselTripRow(
                                trip: item,
                                onBuy: item.seats > 0
                                    ? () {
                                        widget.onTripSelected(item);
                                        widget.nav(AppScreen.purchase);
                                      }
                                    : null,
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      SectionTitle(
                        title: 'Avaliações dos Passageiros',
                        actionLabel: 'Ver todas',
                        onAction: () => widget.nav(AppScreen.vesselReviews),
                      ),
                      const SizedBox(height: 8),
                      if (_loadingReviews)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_reviewsError != null)
                        _HomeTripsMessage(
                          icon: Icons.cloud_off_outlined,
                          title: 'Avaliações indisponíveis',
                          message: _reviewsError!,
                          onRetry: _loadReviews,
                        )
                      else if (_reviewSummary.total == 0)
                        _HomeTripsMessage(
                          icon: Icons.star_outline,
                          title: 'Ainda sem avaliações',
                          message:
                              'As avaliações dos passageiros aparecerão aqui.',
                          onRetry: _loadReviews,
                        )
                      else ...[
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  _reviewSummary.average.toStringAsFixed(1),
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontSize: 34),
                                ),
                                StarRating(
                                  value: _reviewSummary.roundedAverage,
                                  size: 14,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${_reviewSummary.total} avaliações',
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                children: [5, 4, 3, 2, 1]
                                    .map(
                                      (star) => _RatingLine(
                                        star: star,
                                        count:
                                            _reviewSummary.distribution[star] ??
                                            0,
                                        total: _reviewSummary.total,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ..._reviewPreview.map(
                          (review) => ReviewCard(review: review),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PcButton(
                  label: 'Comprar Passagem',
                  icon: Icons.arrow_forward,
                  full: true,
                  onPressed: trip.seats > 0
                      ? () {
                          widget.onTripSelected(trip);
                          widget.nav(AppScreen.purchase);
                        }
                      : null,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class VesselTripsScreen extends StatefulWidget {
  const VesselTripsScreen({
    super.key,
    required this.nav,
    required this.onTripSelected,
    this.selectedTrip,
  });

  final AppNavigator nav;
  final TripSelector onTripSelected;
  final Trip? selectedTrip;

  @override
  State<VesselTripsScreen> createState() => _VesselTripsScreenState();
}

class _VesselTripsScreenState extends State<VesselTripsScreen> {
  final _repository = TravelRepository();
  List<Trip> _trips = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  @override
  void didUpdateWidget(covariant VesselTripsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTrip?.id != widget.selectedTrip?.id) {
      _loadTrips();
    }
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }

  Future<void> _loadTrips() async {
    final selectedTrip = widget.selectedTrip;
    if (selectedTrip == null || selectedTrip.id.startsWith('mock-')) {
      setState(() {
        _trips = const [];
        _error = 'Selecione uma viagem real para ver próximas saídas.';
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final trips = await _repository.listRelatedTrips(selectedTrip.id);
      if (!mounted) return;
      setState(() {
        _trips = trips;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error =
            'Não foi possível carregar as próximas viagens desta embarcação.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTrip = widget.selectedTrip;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: selectedTrip?.vessel ?? 'Embarcação',
            subtitle: 'Próximas viagens',
            backTo: AppScreen.vessel,
            nav: widget.nav,
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? _VesselTripsMessage(
                    icon: Icons.cloud_off_outlined,
                    title: 'Viagens indisponíveis',
                    message: _error!,
                    onRetry: _loadTrips,
                  )
                : _trips.isEmpty
                ? _VesselTripsMessage(
                    icon: Icons.directions_boat_outlined,
                    title: 'Nenhuma próxima viagem',
                    message:
                        'Novas saídas desta embarcação aparecerão aqui quando forem cadastradas.',
                    onRetry: _loadTrips,
                  )
                : RefreshIndicator(
                    onRefresh: _loadTrips,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: _trips
                          .map(
                            (trip) => PcCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: _VesselTripRow(
                                trip: trip,
                                onBuy: trip.seats > 0
                                    ? () {
                                        widget.onTripSelected(trip);
                                        widget.nav(AppScreen.purchase);
                                      }
                                    : null,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class VesselReviewsScreen extends StatefulWidget {
  const VesselReviewsScreen({
    super.key,
    required this.nav,
    required this.selectedTrip,
  });

  final AppNavigator nav;
  final Trip? selectedTrip;

  @override
  State<VesselReviewsScreen> createState() => _VesselReviewsScreenState();
}

class _VesselReviewsScreenState extends State<VesselReviewsScreen> {
  final _repository = ReviewsRepository();
  bool _showForm = false;
  bool _loading = true;
  bool _publishing = false;
  int _rating = 0;
  final _comment = TextEditingController();
  List<Review> _reviews = const [];
  ReviewSummary _summary = ReviewSummary.empty;
  String? _error;
  String? _formError;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  @override
  void didUpdateWidget(covariant VesselReviewsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTrip?.id != widget.selectedTrip?.id) {
      _loadReviews();
    }
  }

  @override
  void dispose() {
    _comment.dispose();
    _repository.close();
    super.dispose();
  }

  Future<void> _loadReviews() async {
    final selectedTrip = widget.selectedTrip;
    if (selectedTrip == null || selectedTrip.id.startsWith('mock-')) {
      setState(() {
        _reviews = const [];
        _summary = ReviewSummary.empty;
        _error = 'Selecione uma viagem real para ver avaliações.';
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _formError = null;
    });

    try {
      final bundle = await _repository.listTripReviews(selectedTrip.id);
      if (!mounted) return;
      setState(() {
        _reviews = bundle.reviews;
        _summary = bundle.summary;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Não foi possível carregar as avaliações desta embarcação.';
        _loading = false;
      });
    }
  }

  Future<void> _publish() async {
    final selectedTrip = widget.selectedTrip;
    final comment = _comment.text.trim();

    if (selectedTrip == null || selectedTrip.id.startsWith('mock-')) {
      setState(() => _formError = 'Selecione uma viagem real para avaliar.');
      return;
    }
    if (_rating == 0) {
      setState(() => _formError = 'Selecione uma nota para publicar.');
      return;
    }
    if (comment.length < 12) {
      setState(
        () => _formError = 'A avaliação deve ter pelo menos 12 caracteres.',
      );
      return;
    }

    setState(() {
      _publishing = true;
      _formError = null;
    });

    try {
      final submission = await _repository.publishReview(
        tripId: selectedTrip.id,
        rating: _rating,
        comment: comment,
      );
      if (!mounted) return;
      final nextReviews = [
        submission.review,
        ..._reviews.where((review) => review.id != submission.review.id),
      ];
      setState(() {
        _reviews = nextReviews;
        _summary = submission.summary;
        _publishing = false;
        _showForm = false;
        _rating = 0;
        _comment.clear();
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _formError = _reviewErrorMessage(error);
        _publishing = false;
      });
    }
  }

  String _reviewErrorMessage(Object error) {
    if (error is ReviewsRepositoryException) return error.message;
    if (error is ApiException) return error.message;
    return 'Não foi possível publicar sua avaliação.';
  }

  void _closeForm() {
    setState(() {
      _showForm = false;
      _rating = 0;
      _formError = null;
      _comment.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTrip = widget.selectedTrip;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Avaliações',
            subtitle: selectedTrip?.vessel ?? 'Embarcação',
            backTo: AppScreen.vessel,
            nav: widget.nav,
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? _VesselTripsMessage(
                    icon: Icons.star_outline,
                    title: 'Avaliações indisponíveis',
                    message: _error!,
                    onRetry: _loadReviews,
                  )
                : RefreshIndicator(
                    onRefresh: _loadReviews,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        PcCard(
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    _summary.average.toStringAsFixed(1),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontSize: 42),
                                  ),
                                  StarRating(
                                    value: _summary.roundedAverage,
                                    size: 17,
                                  ),
                                  Text(
                                    '${_summary.total} avaliações',
                                    style: const TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  children: [5, 4, 3, 2, 1]
                                      .map(
                                        (star) => _RatingLine(
                                          star: star,
                                          count:
                                              _summary.distribution[star] ?? 0,
                                          total: _summary.total,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (!_showForm)
                          PcButton(
                            label: 'Escrever uma avaliação',
                            icon: Icons.star_outline,
                            full: true,
                            variant: PcButtonVariant.outline,
                            onPressed: () => setState(() => _showForm = true),
                          )
                        else
                          PcCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SectionTitle(title: 'Sua avaliação'),
                                if (_formError != null) ...[
                                  const SizedBox(height: 8),
                                  _WarningBox(message: _formError!),
                                ],
                                const SizedBox(height: 8),
                                StarRating(
                                  value: _rating,
                                  size: 28,
                                  onChanged: (value) =>
                                      setState(() => _rating = value),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _comment,
                                  maxLines: 4,
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Conte sua experiência a bordo...',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: PcButton(
                                        label: 'Cancelar',
                                        variant: PcButtonVariant.outline,
                                        onPressed: _publishing
                                            ? null
                                            : _closeForm,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: PcButton(
                                        label: 'Publicar',
                                        loading: _publishing,
                                        onPressed: _publish,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),
                        PcCard(
                          child: _reviews.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                  child: Text(
                                    'Ainda não há avaliações publicadas para esta embarcação.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: AppColors.muted),
                                  ),
                                )
                              : Column(
                                  children: _reviews
                                      .map(
                                        (review) => ReviewCard(review: review),
                                      )
                                      .toList(),
                                ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.nav,
    required this.favoriteIds,
    required this.favoriteTrips,
    required this.toggleFavorite,
    required this.onTripSelected,
  });

  final AppNavigator nav;
  final List<String> favoriteIds;
  final List<Trip> favoriteTrips;
  final FavoriteToggle toggleFavorite;
  final TripSelector onTripSelected;

  @override
  Widget build(BuildContext context) {
    final favorites = favoriteTrips
        .where((trip) => favoriteIds.contains(trip.id))
        .toList();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: PortoBottomNav(
        active: AppScreen.favorites,
        nav: nav,
      ),
      body: Column(
        children: [
          AppHeader(
            title: 'Embarcações Favoritas',
            trailing: PcBadge(label: '${favorites.length}'),
          ),
          Expanded(
            child: favorites.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 36,
                            backgroundColor: Color(0xFFFFEEF2),
                            child: Icon(
                              Icons.favorite_border,
                              color: Colors.redAccent,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Nenhuma embarcação favorita',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Adicione embarcações aos favoritos tocando no coração nos cards de viagem.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: favorites.map((trip) {
                      return TripCard(
                        trip: trip,
                        isFavorite: true,
                        onFavorite: () => toggleFavorite(trip.id),
                        onDetails: () {
                          onTripSelected(trip);
                          nav(AppScreen.vessel);
                        },
                        onBuy: () {
                          onTripSelected(trip);
                          nav(AppScreen.purchase);
                        },
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key, required this.nav, this.tripId});

  final AppNavigator nav;
  final String? tripId;

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final _repository = TravelRepository();
  bool _gps = true;
  bool _loading = true;
  String? _error;
  TripTracking? _tracking;

  @override
  void initState() {
    super.initState();
    _loadTracking();
  }

  @override
  void didUpdateWidget(covariant TrackingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tripId != widget.tripId) {
      _loadTracking();
    }
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }

  Future<void> _loadTracking() async {
    final tripId = widget.tripId;
    if (tripId == null) {
      setState(() {
        _loading = false;
        _error = 'Selecione uma viagem ou reserva para rastrear.';
        _tracking = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final tracking = await _repository.getTripTracking(tripId);
      if (!mounted) return;
      setState(() {
        _tracking = tracking;
        _loading = false;
        _gps = tracking.currentPosition != null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Não foi possível carregar o rastreamento desta viagem.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracking = _tracking;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Rastreamento em Tempo Real',
            backTo: AppScreen.home,
            nav: widget.nav,
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? _TrackingMessage(
                    icon: Icons.location_searching,
                    title: 'Rastreamento indisponível',
                    message: _error!,
                    onRetry: _loadTracking,
                  )
                : tracking == null
                ? _TrackingMessage(
                    icon: Icons.location_off_outlined,
                    title: 'Sem dados de posição',
                    message: 'Ainda não há rastreamento para esta viagem.',
                    onRetry: _loadTracking,
                  )
                : !_gps
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(26),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.wifi_off,
                            color: AppColors.muted,
                            size: 54,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'GPS Indisponível',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'O GPS da embarcação está desligado ou com sinal instável. Tente novamente em alguns momentos.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.muted),
                          ),
                          const SizedBox(height: 18),
                          PcButton(
                            label: 'Tentar novamente',
                            icon: Icons.refresh,
                            onPressed: _loadTracking,
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(painter: _MapPainter()),
                            ),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: PcCard(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Próxima parada',
                                      style: TextStyle(
                                        color: AppColors.muted,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      tracking.nextStopLabel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(color: AppColors.accent),
                                    ),
                                    Text(
                                      'Tempo restante: ${tracking.remainingLabel}',
                                      style: const TextStyle(
                                        color: AppColors.muted,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: Row(
                                children: [
                                  IconButton.filledTonal(
                                    onPressed: _loadTracking,
                                    icon: const Icon(Icons.refresh),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton.filledTonal(
                                    onPressed: () =>
                                        setState(() => _gps = false),
                                    icon: const Icon(Icons.wifi_off),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -12),
                        child: PcCard(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Color(0xFFE8F1FF),
                                    child: Icon(
                                      Icons.directions_boat,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tracking.vesselName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Text(
                                          tracking.routeLabel,
                                          style: const TextStyle(
                                            color: AppColors.muted,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const PcBadge(
                                    label: 'Em viagem',
                                    tone: PcBadgeTone.teal,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  _SmallStat(
                                    label: 'Velocidade',
                                    value: tracking.averageSpeed == null
                                        ? 'Variável'
                                        : '${tracking.averageSpeed} km/h',
                                    icon: Icons.navigation_outlined,
                                  ),
                                  _SmallStat(
                                    label: 'Posição',
                                    value: tracking.positionLabel,
                                    icon: Icons.place_outlined,
                                  ),
                                  _SmallStat(
                                    label: 'Atualizado',
                                    value: tracking.updatedLabel,
                                    icon: Icons.refresh,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(99),
                                child: LinearProgressIndicator(
                                  value: tracking.progressPercentage / 100,
                                  minHeight: 9,
                                  backgroundColor: const Color(0xFFE5E7EB),
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${tracking.progressPercentage}% do trajeto concluído - última parada: ${tracking.previousStop?.label ?? 'Origem'}',
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _TrackingMessage extends StatelessWidget {
  const _TrackingMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.muted, size: 54),
            const SizedBox(height: 14),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 18),
            PcButton(
              label: 'Tentar novamente',
              icon: Icons.refresh,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _repository = NotificationsRepository();
  List<NotificationItem> _items = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final items = await _repository.listNotifications();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Não foi possível carregar suas notificações.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final unread = _items.where((item) => !item.read).length;
    final groups = <String, List<NotificationItem>>{};
    for (final item in _items) {
      groups.putIfAbsent(item.date, () => []).add(item);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Notificações',
            subtitle: unread == 0 ? 'Tudo em dia' : '$unread não lidas',
            backTo: AppScreen.home,
            nav: widget.nav,
            trailing: unread == 0
                ? null
                : TextButton(
                    onPressed: () => setState(
                      () => _items = _items
                          .map((item) => item.copyWith(read: true))
                          .toList(),
                    ),
                    child: const Text(
                      'Marcar todas',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? _VesselTripsMessage(
                    icon: Icons.notifications_off_outlined,
                    title: 'Notificações indisponíveis',
                    message: _error!,
                    onRetry: _loadNotifications,
                  )
                : _items.isEmpty
                ? _VesselTripsMessage(
                    icon: Icons.notifications_none_outlined,
                    title: 'Sem notificações',
                    message:
                        'Avisos sobre embarque, atrasos e reservas aparecerão aqui.',
                    onRetry: _loadNotifications,
                  )
                : RefreshIndicator(
                    onRefresh: _loadNotifications,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: groups.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4,
                                bottom: 8,
                                top: 4,
                              ),
                              child: Text(
                                entry.key.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            PcCard(
                              padding: EdgeInsets.zero,
                              margin: const EdgeInsets.only(bottom: 14),
                              child: Column(
                                children: entry.value.map((item) {
                                  return ListTile(
                                    onTap: () => setState(() {
                                      final index = _items.indexWhere(
                                        (candidate) => candidate.id == item.id,
                                      );
                                      _items[index] = _items[index].copyWith(
                                        read: true,
                                      );
                                    }),
                                    leading: CircleAvatar(
                                      backgroundColor: _notificationColor(
                                        item.type,
                                      ).withValues(alpha: 0.12),
                                      child: Icon(
                                        _notificationIcon(item.type),
                                        color: _notificationColor(item.type),
                                      ),
                                    ),
                                    title: Text(
                                      item.title,
                                      style: TextStyle(
                                        fontWeight: item.read
                                            ? FontWeight.w700
                                            : FontWeight.w900,
                                      ),
                                    ),
                                    subtitle: Text(item.body),
                                    trailing: Text(
                                      item.time,
                                      style: const TextStyle(
                                        color: AppColors.muted,
                                        fontSize: 11,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({
    super.key,
    required this.nav,
    required this.onBookingSelected,
    required this.onTrackingSelected,
  });

  final AppNavigator nav;
  final ValueChanged<MyTrip> onBookingSelected;
  final ValueChanged<MyTrip> onTrackingSelected;

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  final _repository = MyTripsRepository();
  bool _active = true;
  bool _loading = true;
  String? _error;
  String? _openingTicketId;
  List<MyTrip> _trips = const [];

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }

  Future<void> _loadTrips() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final trips = await _repository.listMyTrips();
      if (!mounted) return;
      setState(() {
        _trips = trips;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is MyTripsRepositoryException
            ? error.message
            : 'Não foi possível carregar suas viagens.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeTrips = _trips
        .where((trip) => trip.status == 'confirmada')
        .toList();
    final history = _trips
        .where((trip) => trip.status != 'confirmada')
        .toList();
    final list = _active ? activeTrips : history;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Minhas Viagens',
            backTo: AppScreen.profile,
            nav: widget.nav,
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                PcChip(
                  label: 'Ativas (${activeTrips.length})',
                  active: _active,
                  onTap: () => setState(() => _active = true),
                ),
                const SizedBox(width: 8),
                PcChip(
                  label: 'Histórico (${history.length})',
                  active: !_active,
                  onTap: () => setState(() => _active = false),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? _MyTripsMessage(
                    icon: Icons.cloud_off_outlined,
                    title: 'Viagens indisponíveis',
                    message: _error!,
                    actionLabel: 'Tentar novamente',
                    onAction: _loadTrips,
                  )
                : list.isEmpty
                ? _MyTripsMessage(
                    icon: _active
                        ? Icons.confirmation_number_outlined
                        : Icons.history,
                    title: _active ? 'Nenhuma viagem ativa' : 'Histórico vazio',
                    message: _active
                        ? 'Suas próximas reservas confirmadas aparecerão aqui.'
                        : 'Viagens concluídas ou canceladas aparecerão aqui.',
                    actionLabel: 'Buscar viagem',
                    onAction: () => widget.nav(AppScreen.search),
                  )
                : RefreshIndicator(
                    onRefresh: _loadTrips,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: list.map(_tripCard).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _tripCard(MyTrip trip) {
    return PcCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  trip.vessel,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              _TripStatusBadge(status: trip.status),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            trip.route,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            '${trip.date} - ${trip.time}',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            trip.id,
            style: const TextStyle(
              color: AppColors.muted,
              fontFamily: 'monospace',
              fontSize: 11,
            ),
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'R\$ ${trip.price},00',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: AppColors.primary),
                ),
              ),
              if (trip.status == 'confirmada') ...[
                PcButton(
                  label: 'Rastrear',
                  icon: Icons.navigation_outlined,
                  small: true,
                  variant: PcButtonVariant.outline,
                  onPressed: () => widget.onTrackingSelected(trip),
                ),
                const SizedBox(width: 8),
                PcButton(
                  label: _openingTicketId == trip.bookingId
                      ? 'Abrindo...'
                      : 'Bilhete',
                  icon: Icons.confirmation_number_outlined,
                  small: true,
                  loading: _openingTicketId == trip.bookingId,
                  onPressed: () => _openTicket(trip),
                ),
              ] else if (trip.status == 'concluida')
                PcButton(
                  label: 'Comprar novamente',
                  small: true,
                  variant: PcButtonVariant.outline,
                  onPressed: () => widget.nav(AppScreen.search),
                ),
            ],
          ),
          if (trip.status == 'confirmada') ...[
            const SizedBox(height: 10),
            PcButton(
              label: 'Cancelar reserva',
              icon: Icons.cancel_outlined,
              full: true,
              variant: PcButtonVariant.danger,
              onPressed: () => _cancelTrip(trip),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openTicket(MyTrip trip) async {
    final bookingId = trip.bookingId;
    if (bookingId == null) {
      _showMessage('Não foi possível identificar a reserva.');
      return;
    }

    setState(() => _openingTicketId = bookingId);

    try {
      final booking = await _repository.getBooking(bookingId);
      if (!mounted) return;
      widget.onBookingSelected(booking);
    } catch (error) {
      if (!mounted) return;
      _showMessage(_bookingErrorMessage(error));
    } finally {
      if (mounted) setState(() => _openingTicketId = null);
    }
  }

  Future<void> _cancelTrip(MyTrip trip) async {
    final bookingId = trip.bookingId;
    if (bookingId == null) {
      _showMessage('Não foi possível identificar a reserva.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancelar reserva?'),
          content: const Text(
            'A reserva será cancelada e a vaga voltará a ficar disponível para outros passageiros.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Manter'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Cancelar reserva'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _repository.cancelBooking(bookingId);
      if (!mounted) return;
      _showMessage('Reserva cancelada com sucesso.');
      setState(() => _active = false);
      await _loadTrips();
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showMessage(_cancelErrorMessage(error));
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _cancelErrorMessage(Object error) {
    return _bookingErrorMessage(error);
  }

  String _bookingErrorMessage(Object error) {
    if (error is MyTripsRepositoryException) return error.message;
    if (error is ApiException) return error.message;
    return 'Não foi possível completar esta operação.';
  }
}

class _MyTripsMessage extends StatelessWidget {
  const _MyTripsMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 90),
        Icon(icon, color: AppColors.muted, size: 56),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 18),
        PcButton(label: actionLabel, icon: Icons.refresh, onPressed: onAction),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.10),
            child: Text(
              review.avatar,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        review.user,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      review.date,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                StarRating(value: review.rating, size: 12),
                const SizedBox(height: 5),
                Text(
                  review.comment,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Útil (${review.helpful})',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTripsMessage extends StatelessWidget {
  const _HomeTripsMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Icon(icon, color: AppColors.muted, size: 38),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          PcButton(
            label: 'Tentar novamente',
            icon: Icons.refresh,
            small: true,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

class _VesselTripsMessage extends StatelessWidget {
  const _VesselTripsMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 90),
        Icon(icon, color: AppColors.muted, size: 56),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 18),
        PcButton(
          label: 'Tentar novamente',
          icon: Icons.refresh,
          onPressed: onRetry,
        ),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.onTap,
    this.dot = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          color: Colors.white.withValues(alpha: 0.16),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(icon, color: Colors.white, size: 21),
            ),
          ),
        ),
        if (dot)
          Positioned(
            top: 7,
            right: 7,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _RouteTile extends StatelessWidget {
  const _RouteTile({
    required this.origin,
    required this.destination,
    required this.onTap,
  });

  final String origin;
  final String destination;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.place_outlined,
                color: AppColors.primary,
                size: 17,
              ),
              const SizedBox(height: 5),
              Text(
                origin,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
              Text(
                destination,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF4B5563),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFB77900),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFB77900),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentSearch extends StatelessWidget {
  const _RecentSearch({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final String date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFF3F4F6),
        child: Icon(Icons.search, color: AppColors.muted),
      ),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
      ),
      subtitle: Text(date),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _VesselTripRow extends StatelessWidget {
  const _VesselTripRow({required this.trip, this.onBuy});

  final Trip trip;
  final VoidCallback? onBuy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE8F1FF),
            child: Icon(Icons.directions_boat, color: AppColors.primary),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${trip.origin} -> ${trip.destination}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${trip.date} - ${trip.time} - ${trip.duration}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${trip.price}',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 5),
              if (onBuy != null)
                PcButton(label: 'Comprar', small: true, onPressed: onBuy)
              else
                const PcBadge(label: 'Esgotado', tone: PcBadgeTone.red),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingLine extends StatelessWidget {
  const _RatingLine({required this.star, this.count = 0, this.total = 0});

  final int star;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : count / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Text(
              '$star',
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ),
          const Icon(Icons.star, color: AppColors.accent, size: 11),
          const SizedBox(width: 7),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 6,
                color: AppColors.accent,
                backgroundColor: const Color(0xFFF3F4F6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: AppColors.muted, fontSize: 9),
            ),
            Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripStatusBadge extends StatelessWidget {
  const _TripStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final tone = switch (status) {
      'confirmada' => PcBadgeTone.green,
      'concluida' => PcBadgeTone.gray,
      'cancelada' => PcBadgeTone.red,
      _ => PcBadgeTone.blue,
    };
    final label = switch (status) {
      'confirmada' => 'Confirmada',
      'concluida' => 'Concluída',
      'cancelada' => 'Cancelada',
      _ => status,
    };
    return PcBadge(label: label, tone: tone);
  }
}

IconData _notificationIcon(String type) {
  return switch (type) {
    'embarque' => Icons.directions_boat,
    'atraso' => Icons.schedule,
    'confirmacao' => Icons.check_circle_outline,
    'cancelamento' => Icons.cancel_outlined,
    'system' => Icons.info_outline,
    _ => Icons.notifications_outlined,
  };
}

Color _notificationColor(String type) {
  return switch (type) {
    'embarque' => AppColors.primary,
    'atraso' => AppColors.accent,
    'confirmacao' => AppColors.success,
    'cancelamento' => AppColors.danger,
    'system' => AppColors.teal,
    _ => AppColors.teal,
  };
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final water = Paint()..color = AppColors.mapWater;
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF0F2A4A),
    );

    final north = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.30)
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.22,
        size.width * 0.48,
        size.height * 0.30,
      )
      ..quadraticBezierTo(
        size.width * 0.26,
        size.height * 0.39,
        0,
        size.height * 0.29,
      )
      ..close();
    canvas.drawPath(north, Paint()..color = const Color(0xFF1E5230));

    final south = Path()
      ..moveTo(0, size.height * 0.69)
      ..quadraticBezierTo(
        size.width * 0.32,
        size.height * 0.56,
        size.width * 0.55,
        size.height * 0.69,
      )
      ..quadraticBezierTo(
        size.width * 0.77,
        size.height * 0.80,
        size.width,
        size.height * 0.67,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(south, Paint()..color = const Color(0xFF1E5230));

    final river = Path()
      ..moveTo(0, size.height * 0.30)
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.42,
        size.width * 0.55,
        size.height * 0.38,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.35,
        size.width,
        size.height * 0.42,
      )
      ..lineTo(size.width, size.height * 0.67)
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.58,
        size.width * 0.48,
        size.height * 0.64,
      )
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height * 0.72,
        0,
        size.height * 0.62,
      )
      ..close();
    canvas.drawPath(river, water);

    final route = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final path = Path()
      ..moveTo(size.width * 0.10, size.height * 0.45)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.35,
        size.width * 0.52,
        size.height * 0.42,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.52,
        size.width * 0.90,
        size.height * 0.46,
      );
    canvas.drawPath(path, route);

    _drawPoint(
      canvas,
      Offset(size.width * 0.10, size.height * 0.45),
      AppColors.secondary,
    );
    _drawPoint(
      canvas,
      Offset(size.width * 0.52, size.height * 0.42),
      AppColors.accent,
      radius: 9,
    );
    _drawPoint(
      canvas,
      Offset(size.width * 0.90, size.height * 0.46),
      AppColors.success,
    );
  }

  void _drawPoint(
    Canvas canvas,
    Offset center,
    Color color, {
    double radius = 7,
  }) {
    canvas.drawCircle(
      center,
      radius * 2.1,
      Paint()..color = color.withValues(alpha: 0.20),
    );
    canvas.drawCircle(center, radius, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
