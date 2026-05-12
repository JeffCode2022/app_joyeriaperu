import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'features/cart/presentation/providers/cart_providers.dart';
import 'features/favorites/presentation/providers/favorites_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Hive
  await Hive.initFlutter();
  final cartBox = await Hive.openBox<String>('cart_box');
  final favoritesBox = await Hive.openBox<String>('favorites_box');

  runApp(
    ProviderScope(
      overrides: [
        cartBoxProvider.overrideWithValue(cartBox),
        favoritesBoxProvider.overrideWithValue(favoritesBox),
      ],
      child: const LuxeJoyasApp(),
    ),
  );
}
