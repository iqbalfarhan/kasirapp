import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Sumber foto produk: galeri atau kamera langsung.
enum ProductImageSource { gallery, camera }

final _picker = ImagePicker();

/// Ambil foto produk (galeri/kamera) lalu salin ke folder aplikasi agar
/// path permanen (tidak hilang saat cache OS dibersihkan).
///
/// Return path file permanen, atau null bila pengguna membatalkan.
Future<String?> pickAndStoreProductImage(ProductImageSource source) async {
  final picked = await _picker.pickImage(
    source: source == ProductImageSource.camera
        ? ImageSource.camera
        : ImageSource.gallery,
    maxWidth: 1024,
    imageQuality: 85,
  );
  if (picked == null) return null;

  final dir = await getApplicationDocumentsDirectory();
  final targetDir = Directory(p.join(dir.path, 'product_images'));
  if (!await targetDir.exists()) {
    await targetDir.create(recursive: true);
  }
  final ext = p.extension(picked.path).isEmpty
      ? '.jpg'
      : p.extension(picked.path);
  final target = File(
    p.join(
      targetDir.path,
      '${DateTime.now().millisecondsSinceEpoch}$ext',
    ),
  );
  await File(picked.path).copy(target.path);
  return target.path;
}

/// Thumbnail foto produk. Fallback ikon bila path kosong / file hilang.
class ProductImageThumb extends StatelessWidget {
  const ProductImageThumb({
    super.key,
    required this.path,
    this.size = 48,
    this.borderRadius = 8,
    this.iconSize,
  });

  final String? path;
  final double size;
  final double borderRadius;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        Icons.fastfood,
        size: iconSize ?? size * 0.5,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
    if (path == null || path!.isEmpty) return fallback;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.file(
        File(path!),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}
