import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_navigasi_pageroute/main.dart';
import 'package:demo_navigasi_pageroute/home.dart';
import 'package:demo_navigasi_pageroute/tujuan.dart';

void main() {
  testWidgets('Konfigurasi navigasi sesuai modul', (tester) async {
    await tester.pumpWidget(const MyApp());
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.home, isA<Home>());
    expect(app.routes, isEmpty);
  });

  testWidgets('Home ke Tujuan lalu kembali ke Home dua kali', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    final originalHome = tester.element(find.byType(Home));
    expect(find.byType(Tujuan), findsNothing);
    for (var i = 0; i < 2; i++) {
      await tester.ensureVisible(find.text('Ke Halaman Tujuan'));
      await tester.tap(find.text('Ke Halaman Tujuan'));
      await tester.pumpAndSettle();
      expect(find.byType(Tujuan), findsOneWidget);
      expect(find.byType(Home), findsNothing);

      await tester.ensureVisible(find.text('Kembali ke Home'));
      await tester.tap(find.text('Kembali ke Home'));
      await tester.pumpAndSettle();
      expect(find.byType(Home), findsOneWidget);
      expect(tester.element(find.byType(Home)), same(originalHome));
      expect(find.byType(Tujuan), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });
}
