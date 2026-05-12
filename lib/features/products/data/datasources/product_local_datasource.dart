import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';

/// Local mock data source for products and categories.
/// In production, this would be replaced by an API data source.
class ProductLocalDataSource {
  List<Category> getCategories() => _categories;
  List<Product> getProducts() => _products;

  List<Product> getProductsByCategory(String categoryId) =>
      _products.where((p) => p.categoryId == categoryId).toList();

  List<Product> getFeaturedProducts() =>
      _products.where((p) => p.isFeatured).toList();

  List<Product> getNewProducts() =>
      _products.where((p) => p.isNew).toList();

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Product> searchProducts(String query) {
    final q = query.toLowerCase();
    return _products.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q)) ||
          p.material.toLowerCase().contains(q);
    }).toList();
  }

  List<Product> getRecommendations(String productId) {
    final product = getProductById(productId);
    if (product == null) return _products.take(4).toList();
    return _products
        .where((p) => p.id != productId && p.categoryId == product.categoryId)
        .take(4)
        .toList();
  }

  // ── Mock Categories ──
  static const _categories = [
    Category(id: 'rings', name: 'Anillos', icon: '💍', productCount: 12),
    Category(id: 'necklaces', name: 'Collares', icon: '📿', productCount: 8),
    Category(id: 'bracelets', name: 'Pulseras', icon: '⌚', productCount: 6),
    Category(id: 'earrings', name: 'Aretes', icon: '✨', productCount: 10),
    Category(id: 'watches', name: 'Relojes', icon: '⏱️', productCount: 5),
    Category(id: 'sets', name: 'Sets', icon: '🎁', productCount: 4),
  ];

  // ── Mock Products ──
  // Asset base path for local product images
  static const _imgBase = 'assets/images/';

  static final _products = [
    Product(
      id: 'p1',
      name: 'Anillo Solitario Diana',
      description:
          'Elegante anillo solitario con diamante central de 0.5 quilates montado en oro blanco de 18 kilates. Diseño clásico que resalta la pureza de la piedra.',
      categoryId: 'rings',
      price: 2450.00,
      promoPrice: 1899.00,
      images: [
        '${_imgBase}ring_solitaire.png',
        '${_imgBase}ring_eternity.png',
        '${_imgBase}ring_detail.png',
      ],
      options: [
        const ProductOption(
          label: 'Talla',
          values: ['5', '6', '7', '8', '9', '10'],
        ),
        const ProductOption(
          label: 'Material',
          values: ['Oro Blanco 18K', 'Oro Amarillo 18K', 'Platino'],
          priceModifiers: {
            'Oro Blanco 18K': 0,
            'Oro Amarillo 18K': 0,
            'Platino': 350,
          },
        ),
        const ProductOption(
          label: 'Quilates',
          values: ['0.25 ct', '0.50 ct', '0.75 ct', '1.0 ct'],
          priceModifiers: {
            '0.25 ct': -600,
            '0.50 ct': 0,
            '0.75 ct': 800,
            '1.0 ct': 1800,
          },
        ),
      ],
      tags: ['diamante', 'solitario', 'compromiso', 'elegante'],
      rating: 4.8,
      reviewCount: 124,
      isFeatured: true,
      material: 'Oro Blanco',
      karats: '18K',
    ),
    Product(
      id: 'p2',
      name: 'Collar Infinity Gold',
      description:
          'Collar con colgante infinito elaborado en oro amarillo de 14K con incrustaciones de zirconia. Cadena ajustable de 40-45cm.',
      categoryId: 'necklaces',
      price: 890.00,
      promoPrice: 699.00,
      images: [
        '${_imgBase}necklace_gold.png',
        '${_imgBase}pearls_set.png',
      ],
      options: [
        const ProductOption(
          label: 'Largo',
          values: ['40 cm', '42 cm', '45 cm'],
        ),
        const ProductOption(
          label: 'Material',
          values: ['Oro Amarillo 14K', 'Oro Rosa 14K', 'Plata 925'],
          priceModifiers: {
            'Oro Amarillo 14K': 0,
            'Oro Rosa 14K': 0,
            'Plata 925': -400,
          },
        ),
      ],
      tags: ['collar', 'infinito', 'oro', 'regalo'],
      rating: 4.6,
      reviewCount: 89,
      isFeatured: true,
      isNew: true,
      material: 'Oro Amarillo',
      karats: '14K',
    ),
    Product(
      id: 'p3',
      name: 'Pulsera Tennis Brillante',
      description:
          'Pulsera tennis con 42 diamantes naturales engastados en oro blanco. Total: 2.5 quilates. Cierre de seguridad doble.',
      categoryId: 'bracelets',
      price: 4200.00,
      images: [
        '${_imgBase}bracelet_tennis.png',
        '${_imgBase}ring_eternity.png',
      ],
      options: [
        const ProductOption(
          label: 'Largo',
          values: ['16 cm', '17 cm', '18 cm', '19 cm'],
        ),
        const ProductOption(
          label: 'Material',
          values: ['Oro Blanco 18K', 'Platino'],
          priceModifiers: {'Oro Blanco 18K': 0, 'Platino': 800},
        ),
      ],
      tags: ['tennis', 'diamantes', 'lujo', 'premium'],
      rating: 4.9,
      reviewCount: 56,
      isFeatured: true,
      material: 'Oro Blanco',
      karats: '18K',
    ),
    Product(
      id: 'p4',
      name: 'Aretes Gota Esmeralda',
      description:
          'Aretes tipo gota con esmeraldas colombianas naturales (1.2 ct total) rodeadas de micro-pavé de diamantes en oro amarillo.',
      categoryId: 'earrings',
      price: 3100.00,
      promoPrice: 2599.00,
      images: [
        '${_imgBase}earrings_emerald.png',
        '${_imgBase}necklace_gold.png',
      ],
      options: [
        const ProductOption(
          label: 'Piedra',
          values: ['Esmeralda', 'Rubí', 'Zafiro'],
          priceModifiers: {'Esmeralda': 0, 'Rubí': 200, 'Zafiro': 150},
        ),
        const ProductOption(
          label: 'Material',
          values: ['Oro Amarillo 18K', 'Oro Blanco 18K'],
        ),
      ],
      tags: ['aretes', 'esmeralda', 'gota', 'colombiana'],
      rating: 4.7,
      reviewCount: 43,
      isNew: true,
      material: 'Oro Amarillo',
      karats: '18K',
    ),
    Product(
      id: 'p5',
      name: 'Reloj Heritage Automático',
      description:
          'Reloj automático con caja de acero inoxidable 316L bañada en oro rosa. Mecanismo suizo, cristal de zafiro, resistente al agua 50m.',
      categoryId: 'watches',
      price: 5800.00,
      promoPrice: 4990.00,
      images: [
        '${_imgBase}watch_heritage.png',
        '${_imgBase}watch_detail.png',
      ],
      options: [
        const ProductOption(
          label: 'Caja',
          values: ['38 mm', '42 mm'],
          priceModifiers: {'38 mm': 0, '42 mm': 200},
        ),
        const ProductOption(
          label: 'Correa',
          values: ['Cuero Negro', 'Cuero Marrón', 'Acero'],
          priceModifiers: {'Cuero Negro': 0, 'Cuero Marrón': 0, 'Acero': 350},
        ),
      ],
      tags: ['reloj', 'automático', 'suizo', 'heritage'],
      rating: 4.9,
      reviewCount: 31,
      isFeatured: true,
      material: 'Acero / Oro Rosa',
      karats: null,
    ),
    Product(
      id: 'p6',
      name: 'Anillo Eternity Diamante',
      description:
          'Anillo eternity completo con diamantes naturales de corte brillante. Total 1.5 quilates en oro blanco 18K.',
      categoryId: 'rings',
      price: 3600.00,
      images: [
        '${_imgBase}ring_eternity.png',
        '${_imgBase}ring_solitaire.png',
      ],
      options: [
        const ProductOption(
          label: 'Talla',
          values: ['5', '6', '7', '8'],
        ),
        const ProductOption(
          label: 'Material',
          values: ['Oro Blanco 18K', 'Oro Amarillo 18K'],
        ),
      ],
      tags: ['eternity', 'diamante', 'boda', 'anillo'],
      rating: 4.8,
      reviewCount: 67,
      material: 'Oro Blanco',
      karats: '18K',
    ),
    Product(
      id: 'p7',
      name: 'Set Perlas del Mar',
      description:
          'Set completo de perlas cultivadas del Pacífico Sur: collar, aretes y pulsera. Perlas de 8-10mm AAA montadas en plata 925.',
      categoryId: 'sets',
      price: 1450.00,
      promoPrice: 1199.00,
      images: [
        '${_imgBase}pearls_set.png',
        '${_imgBase}bracelet_tennis.png',
      ],
      options: [
        const ProductOption(
          label: 'Color Perla',
          values: ['Blanca', 'Rosa', 'Crema'],
        ),
        const ProductOption(
          label: 'Material Base',
          values: ['Plata 925', 'Oro Amarillo 14K'],
          priceModifiers: {'Plata 925': 0, 'Oro Amarillo 14K': 800},
        ),
      ],
      tags: ['perlas', 'set', 'regalo', 'mar'],
      rating: 4.5,
      reviewCount: 38,
      isNew: true,
      isFeatured: true,
      material: 'Plata 925',
    ),
    Product(
      id: 'p8',
      name: 'Collar Choker Royal',
      description:
          'Choker artesanal en oro rosa 18K con eslabones cubanos pulidos. Largo 38cm, ancho 6mm. Acabado espejo.',
      categoryId: 'necklaces',
      price: 2200.00,
      images: [
        '${_imgBase}necklace_gold.png',
        '${_imgBase}pearls_set.png',
      ],
      options: [
        const ProductOption(
          label: 'Largo',
          values: ['36 cm', '38 cm', '40 cm'],
        ),
        const ProductOption(
          label: 'Ancho',
          values: ['4 mm', '6 mm', '8 mm'],
          priceModifiers: {'4 mm': -200, '6 mm': 0, '8 mm': 300},
        ),
      ],
      tags: ['choker', 'cubano', 'oro rosa', 'royal'],
      rating: 4.6,
      reviewCount: 52,
      material: 'Oro Rosa',
      karats: '18K',
    ),
  ];
}
