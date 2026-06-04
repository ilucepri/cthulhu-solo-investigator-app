import 'package:cthulhu_solo_investigator_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('SessionPage muestra los botones de tirada', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.text('EVENTOS'), findsOneWidget);
    expect(find.text('HISTORIAL'), findsOneWidget);
    expect(find.textContaining('CONTADOR DE MITOS'), findsOneWidget);
    expect(find.text('NPC'), findsOneWidget);
    expect(find.text('VERBOS'), findsOneWidget);
  });
}
