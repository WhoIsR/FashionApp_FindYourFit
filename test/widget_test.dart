import 'package:fashion_app/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('theme provider can rebuild a simple widget', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final isDark = context.watch<ThemeProvider>().isDark;
              return Scaffold(
                body: Text(isDark ? 'Mode Gelap' : 'Mode Terang'),
                floatingActionButton: FloatingActionButton(
                  onPressed: context.read<ThemeProvider>().toggle,
                  child: const Icon(Icons.brightness_6),
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Mode Terang'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.brightness_6));
    await tester.pump();

    expect(find.text('Mode Gelap'), findsOneWidget);
  });
}
