import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';


/// Manages favorites list with Hive persistence.
class FavoritesNotifier extends StateNotifier<Set<String>> {
  final Box<String> _box;

  FavoritesNotifier(this._box) : super({}) {
    _loadFromBox();
  }

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
      _box.delete(productId);
    } else {
      state = {...state, productId};
      _box.put(productId, productId);
    }
  }

  bool isFavorite(String productId) => state.contains(productId);

  void _loadFromBox() {
    state = _box.values.toSet();
  }
}

// ── Providers ──

final favoritesBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError('Must be overridden at app startup');
});

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  final box = ref.watch(favoritesBoxProvider);
  return FavoritesNotifier(box);
});

final isFavoriteProvider = Provider.family<bool, String>((ref, productId) {
  return ref.watch(favoritesProvider).contains(productId);
});
