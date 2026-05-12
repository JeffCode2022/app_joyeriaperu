import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/cart_item.dart';

const _uuid = Uuid();

/// Manages the shopping cart state with Hive persistence.
/// Cart data persists locally even without login.
class CartNotifier extends StateNotifier<List<CartItem>> {
  final Box<String> _box;

  CartNotifier(this._box) : super([]) {
    _loadFromBox();
  }

  // ── Public API ──

  void addItem({
    required String productId,
    required String productName,
    required String productImage,
    required double unitPrice,
    Map<String, String> selectedOptions = const {},
    int quantity = 1,
  }) {
    // Check if same product with same options already in cart
    final existingIndex = state.indexWhere((item) =>
        item.productId == productId &&
        _optionsMatch(item.selectedOptions, selectedOptions));

    if (existingIndex >= 0) {
      final existing = state[existingIndex];
      final updated = existing.copyWith(quantity: existing.quantity + quantity);
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex) updated else state[i],
      ];
    } else {
      final newItem = CartItem(
        id: _uuid.v4(),
        productId: productId,
        productName: productName,
        productImage: productImage,
        unitPrice: unitPrice,
        quantity: quantity,
        selectedOptions: selectedOptions,
      );
      state = [...state, newItem];
    }
    _saveToBox();
  }

  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
    _saveToBox();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }
    state = [
      for (final item in state)
        if (item.id == itemId) item.copyWith(quantity: quantity) else item,
    ];
    _saveToBox();
  }

  void clearCart() {
    state = [];
    _box.clear();
  }

  double get subtotal =>
      state.fold(0.0, (sum, item) => sum + item.totalPrice);

  int get totalItems =>
      state.fold(0, (sum, item) => sum + item.quantity);

  // ── Persistence ──

  void _loadFromBox() {
    final items = <CartItem>[];
    for (final key in _box.keys) {
      final jsonStr = _box.get(key);
      if (jsonStr != null) {
        items.add(CartItem.fromJson(
            jsonDecode(jsonStr) as Map<String, dynamic>));
      }
    }
    state = items;
  }

  void _saveToBox() {
    _box.clear();
    for (final item in state) {
      _box.put(item.id, jsonEncode(item.toJson()));
    }
  }

  bool _optionsMatch(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}

// ── Providers ──

final cartBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError('Must be overridden at app startup');
});

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final box = ref.watch(cartBoxProvider);
  return CartNotifier(box);
});

final cartSubtotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0.0, (sum, item) => sum + item.totalPrice);
});

final cartItemCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (sum, item) => sum + item.quantity);
});
