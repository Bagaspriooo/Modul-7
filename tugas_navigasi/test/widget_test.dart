import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_navigasi/main.dart';
import 'package:tugas_navigasi/home.dart';
import 'package:tugas_navigasi/tujuan.dart';

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
      await tester.ensureVisible(find.text('Ke halaman tujuan'));
      await tester.tap(find.text('Ke halaman tujuan'));
      await tester.pumpAndSettle();
      expect(find.byType(TujuanPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
      expect(
        ModalRoute.of(tester.element(find.byType(TujuanPage)))!.settings.name,
        '/tujuan',
      );
      await tester.ensureVisible(find.text('Kembali ke home'));
      await tester.tap(find.text('Kembali ke home'));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
      expect(tester.element(find.byType(HomePage)), same(originalHome));
      expect(find.byType(TujuanPage), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Tampilan tugas tidak overflow pada layar sempit', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsOneWidget);
    await tester.ensureVisible(find.text('Ke halaman tujuan'));
    await tester.tap(find.text('Ke halaman tujuan'));
    await tester.pumpAndSettle();
    expect(find.byType(TujuanPage), findsOneWidget);
    await tester.ensureVisible(find.text('Kembali ke home'));
    await tester.tap(find.text('Kembali ke home'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
