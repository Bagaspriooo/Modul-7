import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_navigasi/main.dart';
import 'package:demo_navigasi/home.dart';
import 'package:demo_navigasi/tujuan.dart';

void main() {
  testWidgets('Konfigurasi navigasi sesuai modul', (tester) async {
    await tester.pumpWidget(const MyApp());
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.initialRoute, '/');
    expect(app.routes!.keys, containsAll(['/', '/tujuan']));
  });

  testWidgets('Home ke Tujuan lalu kembali ke Home dua kali', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    final originalHome = tester.element(find.byType(HomePage));
    expect(find.byType(TujuanPage), findsNothing);
    for (var i = 0; i < 2; i++) {
      await tester.ensureVisible(find.text('Ke Halaman Tujuan'));
      await tester.tap(find.text('Ke Halaman Tujuan'));
      await tester.pumpAndSettle();
      expect(find.byType(TujuanPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
      expect(
        ModalRoute.of(tester.element(find.byType(TujuanPage)))!.settings.name,
        '/tujuan',
      );
      await tester.ensureVisible(find.text('Kembali ke Home'));
      await tester.tap(find.text('Kembali ke Home'));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
      expect(tester.element(find.byType(HomePage)), same(originalHome));
      expect(find.byType(TujuanPage), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });
}
