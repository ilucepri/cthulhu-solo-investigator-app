import 'package:cthulhu_solo_investigator_app/core/state/auth_controller.dart';
import 'package:cthulhu_solo_investigator_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  ProviderScope wrap(Widget child) {
    return ProviderScope(
      overrides: [
        authStateProvider.overrideWith((_) => Stream.value(null)),
        guestModeProvider.overrideWith((_) => true),
      ],
      child: child,
    );
  }

  testWidgets('CampaignsPage muestra estado vacío sin partidas', (tester) async {
    await tester.pumpWidget(wrap(const MyApp()));
    await tester.pumpAndSettle();

    expect(find.text('NUEVA PARTIDA'), findsOneWidget);
    expect(find.textContaining('No hay partidas'), findsOneWidget);
  });

  testWidgets('Crear partida lleva a SessionPage', (tester) async {
    await tester.pumpWidget(wrap(const MyApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('NUEVA PARTIDA'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'La casa Whateley');
    await tester.tap(find.text('CREAR'));
    await tester.pumpAndSettle();

    expect(find.text('La casa Whateley'), findsOneWidget);
    expect(find.text('EVENTOS'), findsOneWidget);
    expect(find.text('NOTAS'), findsOneWidget);
  });
}
