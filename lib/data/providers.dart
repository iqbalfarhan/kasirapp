import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/data/db.dart';

/// Dioverride di main.dart dengan instance hasil openConnection().
final databaseProvider =
    Provider<AppDatabase>((ref) => throw UnimplementedError());
