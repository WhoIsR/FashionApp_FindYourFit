import 'package:fashion_app/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('starts in light mode', () {
    final provider = ThemeProvider();

    expect(provider.isDark, isFalse);
    expect(provider.isDarkMode, isFalse);
    expect(provider.themeMode, ThemeMode.light);
  });

  test('toggle switches between light and dark mode', () {
    final provider = ThemeProvider();

    provider.toggle();

    expect(provider.isDark, isTrue);
    expect(provider.isDarkMode, isTrue);
    expect(provider.themeMode, ThemeMode.dark);

    provider.toggleTheme();

    expect(provider.isDark, isFalse);
    expect(provider.isDarkMode, isFalse);
    expect(provider.themeMode, ThemeMode.light);
  });
}
