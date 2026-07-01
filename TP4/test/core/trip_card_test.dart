import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:porto_certo_tp4/core/widgets/trip_card.dart';
import 'package:porto_certo_tp4/data/mock_data.dart';

void main() {
  testWidgets('aciona favorito ao tocar no coração do card', (tester) async {
    var favoriteTaps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TripCard(
              trip: MockData.trips.first,
              isFavorite: false,
              onFavorite: () => favoriteTaps++,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Adicionar aos favoritos'));
    await tester.pump();

    expect(favoriteTaps, 1);
  });
}
