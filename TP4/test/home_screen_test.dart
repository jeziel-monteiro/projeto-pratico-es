import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:porto_certo_tp4/features/travel/data/travel_repository.dart';
import 'package:porto_certo_tp4/features/travel/travel_screens.dart';
import 'package:porto_certo_tp4/models/trip.dart';

void main() {
  testWidgets('Home exibe o nome do viajante autenticado', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          nav: (_) {},
          travelerName: 'Sérgio Simões',
          favoriteIds: const [],
          toggleFavorite: (_) {},
          onTripSelected: (_) {},
          onSearch: (_) {},
          repository: _FakeTravelRepository(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Sérgio Simões'), findsOneWidget);
    expect(find.text('Ana Carolina'), findsNothing);
  });
}

class _FakeTravelRepository extends TravelRepository {
  @override
  Future<List<Trip>> listFeaturedTrips() async => const [];

  @override
  void close() {}
}
