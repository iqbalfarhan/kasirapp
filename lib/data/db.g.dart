// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products
    with TableInfo<$ProductsTable, DbProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kategoriMeta = const VerificationMeta(
    'kategori',
  );
  @override
  late final GeneratedColumn<String> kategori = GeneratedColumn<String>(
    'kategori',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaMeta = const VerificationMeta('harga');
  @override
  late final GeneratedColumn<int> harga = GeneratedColumn<int>(
    'harga',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stokMeta = const VerificationMeta('stok');
  @override
  late final GeneratedColumn<int> stok = GeneratedColumn<int>(
    'stok',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _trackStockMeta = const VerificationMeta(
    'trackStock',
  );
  @override
  late final GeneratedColumn<int> trackStock = GeneratedColumn<int>(
    'track_stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _gambarPathMeta = const VerificationMeta(
    'gambarPath',
  );
  @override
  late final GeneratedColumn<String> gambarPath = GeneratedColumn<String>(
    'gambar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nama,
    kategori,
    harga,
    stok,
    trackStock,
    gambarPath,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('kategori')) {
      context.handle(
        _kategoriMeta,
        kategori.isAcceptableOrUnknown(data['kategori']!, _kategoriMeta),
      );
    } else if (isInserting) {
      context.missing(_kategoriMeta);
    }
    if (data.containsKey('harga')) {
      context.handle(
        _hargaMeta,
        harga.isAcceptableOrUnknown(data['harga']!, _hargaMeta),
      );
    } else if (isInserting) {
      context.missing(_hargaMeta);
    }
    if (data.containsKey('stok')) {
      context.handle(
        _stokMeta,
        stok.isAcceptableOrUnknown(data['stok']!, _stokMeta),
      );
    }
    if (data.containsKey('track_stock')) {
      context.handle(
        _trackStockMeta,
        trackStock.isAcceptableOrUnknown(data['track_stock']!, _trackStockMeta),
      );
    }
    if (data.containsKey('gambar_path')) {
      context.handle(
        _gambarPathMeta,
        gambarPath.isAcceptableOrUnknown(data['gambar_path']!, _gambarPathMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbProduct(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      kategori: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kategori'],
      )!,
      harga: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}harga'],
      )!,
      stok: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stok'],
      )!,
      trackStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_stock'],
      )!,
      gambarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gambar_path'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class DbProduct extends DataClass implements Insertable<DbProduct> {
  final String id;
  final String nama;
  final String kategori;
  final int harga;
  final int stok;
  final int trackStock;
  final String? gambarPath;
  final int isActive;
  final int createdAt;
  final int updatedAt;
  const DbProduct({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.stok,
    required this.trackStock,
    this.gambarPath,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama'] = Variable<String>(nama);
    map['kategori'] = Variable<String>(kategori);
    map['harga'] = Variable<int>(harga);
    map['stok'] = Variable<int>(stok);
    map['track_stock'] = Variable<int>(trackStock);
    if (!nullToAbsent || gambarPath != null) {
      map['gambar_path'] = Variable<String>(gambarPath);
    }
    map['is_active'] = Variable<int>(isActive);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      nama: Value(nama),
      kategori: Value(kategori),
      harga: Value(harga),
      stok: Value(stok),
      trackStock: Value(trackStock),
      gambarPath: gambarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(gambarPath),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DbProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbProduct(
      id: serializer.fromJson<String>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      kategori: serializer.fromJson<String>(json['kategori']),
      harga: serializer.fromJson<int>(json['harga']),
      stok: serializer.fromJson<int>(json['stok']),
      trackStock: serializer.fromJson<int>(json['trackStock']),
      gambarPath: serializer.fromJson<String?>(json['gambarPath']),
      isActive: serializer.fromJson<int>(json['isActive']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nama': serializer.toJson<String>(nama),
      'kategori': serializer.toJson<String>(kategori),
      'harga': serializer.toJson<int>(harga),
      'stok': serializer.toJson<int>(stok),
      'trackStock': serializer.toJson<int>(trackStock),
      'gambarPath': serializer.toJson<String?>(gambarPath),
      'isActive': serializer.toJson<int>(isActive),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DbProduct copyWith({
    String? id,
    String? nama,
    String? kategori,
    int? harga,
    int? stok,
    int? trackStock,
    Value<String?> gambarPath = const Value.absent(),
    int? isActive,
    int? createdAt,
    int? updatedAt,
  }) => DbProduct(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    kategori: kategori ?? this.kategori,
    harga: harga ?? this.harga,
    stok: stok ?? this.stok,
    trackStock: trackStock ?? this.trackStock,
    gambarPath: gambarPath.present ? gambarPath.value : this.gambarPath,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DbProduct copyWithCompanion(ProductsCompanion data) {
    return DbProduct(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      kategori: data.kategori.present ? data.kategori.value : this.kategori,
      harga: data.harga.present ? data.harga.value : this.harga,
      stok: data.stok.present ? data.stok.value : this.stok,
      trackStock: data.trackStock.present
          ? data.trackStock.value
          : this.trackStock,
      gambarPath: data.gambarPath.present
          ? data.gambarPath.value
          : this.gambarPath,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbProduct(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('kategori: $kategori, ')
          ..write('harga: $harga, ')
          ..write('stok: $stok, ')
          ..write('trackStock: $trackStock, ')
          ..write('gambarPath: $gambarPath, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nama,
    kategori,
    harga,
    stok,
    trackStock,
    gambarPath,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbProduct &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.kategori == this.kategori &&
          other.harga == this.harga &&
          other.stok == this.stok &&
          other.trackStock == this.trackStock &&
          other.gambarPath == this.gambarPath &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<DbProduct> {
  final Value<String> id;
  final Value<String> nama;
  final Value<String> kategori;
  final Value<int> harga;
  final Value<int> stok;
  final Value<int> trackStock;
  final Value<String?> gambarPath;
  final Value<int> isActive;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.kategori = const Value.absent(),
    this.harga = const Value.absent(),
    this.stok = const Value.absent(),
    this.trackStock = const Value.absent(),
    this.gambarPath = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String nama,
    required String kategori,
    required int harga,
    this.stok = const Value.absent(),
    this.trackStock = const Value.absent(),
    this.gambarPath = const Value.absent(),
    this.isActive = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nama = Value(nama),
       kategori = Value(kategori),
       harga = Value(harga),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DbProduct> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<String>? kategori,
    Expression<int>? harga,
    Expression<int>? stok,
    Expression<int>? trackStock,
    Expression<String>? gambarPath,
    Expression<int>? isActive,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (kategori != null) 'kategori': kategori,
      if (harga != null) 'harga': harga,
      if (stok != null) 'stok': stok,
      if (trackStock != null) 'track_stock': trackStock,
      if (gambarPath != null) 'gambar_path': gambarPath,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? nama,
    Value<String>? kategori,
    Value<int>? harga,
    Value<int>? stok,
    Value<int>? trackStock,
    Value<String?>? gambarPath,
    Value<int>? isActive,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kategori: kategori ?? this.kategori,
      harga: harga ?? this.harga,
      stok: stok ?? this.stok,
      trackStock: trackStock ?? this.trackStock,
      gambarPath: gambarPath ?? this.gambarPath,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (kategori.present) {
      map['kategori'] = Variable<String>(kategori.value);
    }
    if (harga.present) {
      map['harga'] = Variable<int>(harga.value);
    }
    if (stok.present) {
      map['stok'] = Variable<int>(stok.value);
    }
    if (trackStock.present) {
      map['track_stock'] = Variable<int>(trackStock.value);
    }
    if (gambarPath.present) {
      map['gambar_path'] = Variable<String>(gambarPath.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('kategori: $kategori, ')
          ..write('harga: $harga, ')
          ..write('stok: $stok, ')
          ..write('trackStock: $trackStock, ')
          ..write('gambarPath: $gambarPath, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, DbCustomer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hpMeta = const VerificationMeta('hp');
  @override
  late final GeneratedColumn<String> hp = GeneratedColumn<String>(
    'hp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alamatMeta = const VerificationMeta('alamat');
  @override
  late final GeneratedColumn<String> alamat = GeneratedColumn<String>(
    'alamat',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nama, hp, alamat, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbCustomer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('hp')) {
      context.handle(_hpMeta, hp.isAcceptableOrUnknown(data['hp']!, _hpMeta));
    }
    if (data.containsKey('alamat')) {
      context.handle(
        _alamatMeta,
        alamat.isAcceptableOrUnknown(data['alamat']!, _alamatMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbCustomer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbCustomer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      hp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hp'],
      ),
      alamat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alamat'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class DbCustomer extends DataClass implements Insertable<DbCustomer> {
  final String id;
  final String nama;
  final String? hp;
  final String? alamat;
  final int createdAt;
  const DbCustomer({
    required this.id,
    required this.nama,
    this.hp,
    this.alamat,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama'] = Variable<String>(nama);
    if (!nullToAbsent || hp != null) {
      map['hp'] = Variable<String>(hp);
    }
    if (!nullToAbsent || alamat != null) {
      map['alamat'] = Variable<String>(alamat);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      nama: Value(nama),
      hp: hp == null && nullToAbsent ? const Value.absent() : Value(hp),
      alamat: alamat == null && nullToAbsent
          ? const Value.absent()
          : Value(alamat),
      createdAt: Value(createdAt),
    );
  }

  factory DbCustomer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCustomer(
      id: serializer.fromJson<String>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      hp: serializer.fromJson<String?>(json['hp']),
      alamat: serializer.fromJson<String?>(json['alamat']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nama': serializer.toJson<String>(nama),
      'hp': serializer.toJson<String?>(hp),
      'alamat': serializer.toJson<String?>(alamat),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  DbCustomer copyWith({
    String? id,
    String? nama,
    Value<String?> hp = const Value.absent(),
    Value<String?> alamat = const Value.absent(),
    int? createdAt,
  }) => DbCustomer(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    hp: hp.present ? hp.value : this.hp,
    alamat: alamat.present ? alamat.value : this.alamat,
    createdAt: createdAt ?? this.createdAt,
  );
  DbCustomer copyWithCompanion(CustomersCompanion data) {
    return DbCustomer(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      hp: data.hp.present ? data.hp.value : this.hp,
      alamat: data.alamat.present ? data.alamat.value : this.alamat,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbCustomer(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('hp: $hp, ')
          ..write('alamat: $alamat, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nama, hp, alamat, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCustomer &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.hp == this.hp &&
          other.alamat == this.alamat &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<DbCustomer> {
  final Value<String> id;
  final Value<String> nama;
  final Value<String?> hp;
  final Value<String?> alamat;
  final Value<int> createdAt;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.hp = const Value.absent(),
    this.alamat = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String nama,
    this.hp = const Value.absent(),
    this.alamat = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nama = Value(nama),
       createdAt = Value(createdAt);
  static Insertable<DbCustomer> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<String>? hp,
    Expression<String>? alamat,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (hp != null) 'hp': hp,
      if (alamat != null) 'alamat': alamat,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? nama,
    Value<String?>? hp,
    Value<String?>? alamat,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      hp: hp ?? this.hp,
      alamat: alamat ?? this.alamat,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (hp.present) {
      map['hp'] = Variable<String>(hp.value);
    }
    if (alamat.present) {
      map['alamat'] = Variable<String>(alamat.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('hp: $hp, ')
          ..write('alamat: $alamat, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, DbUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinSaltMeta = const VerificationMeta(
    'pinSalt',
  );
  @override
  late final GeneratedColumn<String> pinSalt = GeneratedColumn<String>(
    'pin_salt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _mustChangePinMeta = const VerificationMeta(
    'mustChangePin',
  );
  @override
  late final GeneratedColumn<int> mustChangePin = GeneratedColumn<int>(
    'must_change_pin',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _failedAttemptsMeta = const VerificationMeta(
    'failedAttempts',
  );
  @override
  late final GeneratedColumn<int> failedAttempts = GeneratedColumn<int>(
    'failed_attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lockedUntilMeta = const VerificationMeta(
    'lockedUntil',
  );
  @override
  late final GeneratedColumn<int> lockedUntil = GeneratedColumn<int>(
    'locked_until',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nama,
    pinHash,
    pinSalt,
    role,
    isActive,
    mustChangePin,
    failedAttempts,
    lockedUntil,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('pin_salt')) {
      context.handle(
        _pinSaltMeta,
        pinSalt.isAcceptableOrUnknown(data['pin_salt']!, _pinSaltMeta),
      );
    } else if (isInserting) {
      context.missing(_pinSaltMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('must_change_pin')) {
      context.handle(
        _mustChangePinMeta,
        mustChangePin.isAcceptableOrUnknown(
          data['must_change_pin']!,
          _mustChangePinMeta,
        ),
      );
    }
    if (data.containsKey('failed_attempts')) {
      context.handle(
        _failedAttemptsMeta,
        failedAttempts.isAcceptableOrUnknown(
          data['failed_attempts']!,
          _failedAttemptsMeta,
        ),
      );
    }
    if (data.containsKey('locked_until')) {
      context.handle(
        _lockedUntilMeta,
        lockedUntil.isAcceptableOrUnknown(
          data['locked_until']!,
          _lockedUntilMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbUser(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      )!,
      pinSalt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_salt'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
      mustChangePin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}must_change_pin'],
      )!,
      failedAttempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}failed_attempts'],
      )!,
      lockedUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}locked_until'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class DbUser extends DataClass implements Insertable<DbUser> {
  final String id;
  final String nama;
  final String pinHash;
  final String pinSalt;
  final String role;
  final int isActive;
  final int mustChangePin;
  final int failedAttempts;
  final int? lockedUntil;
  const DbUser({
    required this.id,
    required this.nama,
    required this.pinHash,
    required this.pinSalt,
    required this.role,
    required this.isActive,
    required this.mustChangePin,
    required this.failedAttempts,
    this.lockedUntil,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama'] = Variable<String>(nama);
    map['pin_hash'] = Variable<String>(pinHash);
    map['pin_salt'] = Variable<String>(pinSalt);
    map['role'] = Variable<String>(role);
    map['is_active'] = Variable<int>(isActive);
    map['must_change_pin'] = Variable<int>(mustChangePin);
    map['failed_attempts'] = Variable<int>(failedAttempts);
    if (!nullToAbsent || lockedUntil != null) {
      map['locked_until'] = Variable<int>(lockedUntil);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      nama: Value(nama),
      pinHash: Value(pinHash),
      pinSalt: Value(pinSalt),
      role: Value(role),
      isActive: Value(isActive),
      mustChangePin: Value(mustChangePin),
      failedAttempts: Value(failedAttempts),
      lockedUntil: lockedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(lockedUntil),
    );
  }

  factory DbUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbUser(
      id: serializer.fromJson<String>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      pinSalt: serializer.fromJson<String>(json['pinSalt']),
      role: serializer.fromJson<String>(json['role']),
      isActive: serializer.fromJson<int>(json['isActive']),
      mustChangePin: serializer.fromJson<int>(json['mustChangePin']),
      failedAttempts: serializer.fromJson<int>(json['failedAttempts']),
      lockedUntil: serializer.fromJson<int?>(json['lockedUntil']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nama': serializer.toJson<String>(nama),
      'pinHash': serializer.toJson<String>(pinHash),
      'pinSalt': serializer.toJson<String>(pinSalt),
      'role': serializer.toJson<String>(role),
      'isActive': serializer.toJson<int>(isActive),
      'mustChangePin': serializer.toJson<int>(mustChangePin),
      'failedAttempts': serializer.toJson<int>(failedAttempts),
      'lockedUntil': serializer.toJson<int?>(lockedUntil),
    };
  }

  DbUser copyWith({
    String? id,
    String? nama,
    String? pinHash,
    String? pinSalt,
    String? role,
    int? isActive,
    int? mustChangePin,
    int? failedAttempts,
    Value<int?> lockedUntil = const Value.absent(),
  }) => DbUser(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    pinHash: pinHash ?? this.pinHash,
    pinSalt: pinSalt ?? this.pinSalt,
    role: role ?? this.role,
    isActive: isActive ?? this.isActive,
    mustChangePin: mustChangePin ?? this.mustChangePin,
    failedAttempts: failedAttempts ?? this.failedAttempts,
    lockedUntil: lockedUntil.present ? lockedUntil.value : this.lockedUntil,
  );
  DbUser copyWithCompanion(UsersCompanion data) {
    return DbUser(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      pinSalt: data.pinSalt.present ? data.pinSalt.value : this.pinSalt,
      role: data.role.present ? data.role.value : this.role,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      mustChangePin: data.mustChangePin.present
          ? data.mustChangePin.value
          : this.mustChangePin,
      failedAttempts: data.failedAttempts.present
          ? data.failedAttempts.value
          : this.failedAttempts,
      lockedUntil: data.lockedUntil.present
          ? data.lockedUntil.value
          : this.lockedUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbUser(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive, ')
          ..write('mustChangePin: $mustChangePin, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockedUntil: $lockedUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nama,
    pinHash,
    pinSalt,
    role,
    isActive,
    mustChangePin,
    failedAttempts,
    lockedUntil,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbUser &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.pinHash == this.pinHash &&
          other.pinSalt == this.pinSalt &&
          other.role == this.role &&
          other.isActive == this.isActive &&
          other.mustChangePin == this.mustChangePin &&
          other.failedAttempts == this.failedAttempts &&
          other.lockedUntil == this.lockedUntil);
}

class UsersCompanion extends UpdateCompanion<DbUser> {
  final Value<String> id;
  final Value<String> nama;
  final Value<String> pinHash;
  final Value<String> pinSalt;
  final Value<String> role;
  final Value<int> isActive;
  final Value<int> mustChangePin;
  final Value<int> failedAttempts;
  final Value<int?> lockedUntil;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.role = const Value.absent(),
    this.isActive = const Value.absent(),
    this.mustChangePin = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String nama,
    required String pinHash,
    required String pinSalt,
    required String role,
    this.isActive = const Value.absent(),
    this.mustChangePin = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nama = Value(nama),
       pinHash = Value(pinHash),
       pinSalt = Value(pinSalt),
       role = Value(role);
  static Insertable<DbUser> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<String>? pinHash,
    Expression<String>? pinSalt,
    Expression<String>? role,
    Expression<int>? isActive,
    Expression<int>? mustChangePin,
    Expression<int>? failedAttempts,
    Expression<int>? lockedUntil,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (pinHash != null) 'pin_hash': pinHash,
      if (pinSalt != null) 'pin_salt': pinSalt,
      if (role != null) 'role': role,
      if (isActive != null) 'is_active': isActive,
      if (mustChangePin != null) 'must_change_pin': mustChangePin,
      if (failedAttempts != null) 'failed_attempts': failedAttempts,
      if (lockedUntil != null) 'locked_until': lockedUntil,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? nama,
    Value<String>? pinHash,
    Value<String>? pinSalt,
    Value<String>? role,
    Value<int>? isActive,
    Value<int>? mustChangePin,
    Value<int>? failedAttempts,
    Value<int?>? lockedUntil,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      mustChangePin: mustChangePin ?? this.mustChangePin,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (pinSalt.present) {
      map['pin_salt'] = Variable<String>(pinSalt.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (mustChangePin.present) {
      map['must_change_pin'] = Variable<int>(mustChangePin.value);
    }
    if (failedAttempts.present) {
      map['failed_attempts'] = Variable<int>(failedAttempts.value);
    }
    if (lockedUntil.present) {
      map['locked_until'] = Variable<int>(lockedUntil.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive, ')
          ..write('mustChangePin: $mustChangePin, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, DbSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  DbSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class DbSetting extends DataClass implements Insertable<DbSetting> {
  final String key;
  final String value;
  const DbSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory DbSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  DbSetting copyWith({String? key, String? value}) =>
      DbSetting(key: key ?? this.key, value: value ?? this.value);
  DbSetting copyWithCompanion(SettingsCompanion data) {
    return DbSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<DbSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<DbSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, DbTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kasirIdMeta = const VerificationMeta(
    'kasirId',
  );
  @override
  late final GeneratedColumn<String> kasirId = GeneratedColumn<String>(
    'kasir_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diskonItemMeta = const VerificationMeta(
    'diskonItem',
  );
  @override
  late final GeneratedColumn<int> diskonItem = GeneratedColumn<int>(
    'diskon_item',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diskonStrukTipeMeta = const VerificationMeta(
    'diskonStrukTipe',
  );
  @override
  late final GeneratedColumn<String> diskonStrukTipe = GeneratedColumn<String>(
    'diskon_struk_tipe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _diskonStrukNilaiMeta = const VerificationMeta(
    'diskonStrukNilai',
  );
  @override
  late final GeneratedColumn<int> diskonStrukNilai = GeneratedColumn<int>(
    'diskon_struk_nilai',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pajakPersenMeta = const VerificationMeta(
    'pajakPersen',
  );
  @override
  late final GeneratedColumn<int> pajakPersen = GeneratedColumn<int>(
    'pajak_persen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _pajakNilaiMeta = const VerificationMeta(
    'pajakNilai',
  );
  @override
  late final GeneratedColumn<int> pajakNilai = GeneratedColumn<int>(
    'pajak_nilai',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bayarMeta = const VerificationMeta('bayar');
  @override
  late final GeneratedColumn<int> bayar = GeneratedColumn<int>(
    'bayar',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kembalianMeta = const VerificationMeta(
    'kembalian',
  );
  @override
  late final GeneratedColumn<int> kembalian = GeneratedColumn<int>(
    'kembalian',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metodeMeta = const VerificationMeta('metode');
  @override
  late final GeneratedColumn<String> metode = GeneratedColumn<String>(
    'metode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('sukses'),
  );
  static const VerificationMeta _voidReasonMeta = const VerificationMeta(
    'voidReason',
  );
  @override
  late final GeneratedColumn<String> voidReason = GeneratedColumn<String>(
    'void_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voidByMeta = const VerificationMeta('voidBy');
  @override
  late final GeneratedColumn<String> voidBy = GeneratedColumn<String>(
    'void_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voidAtMeta = const VerificationMeta('voidAt');
  @override
  late final GeneratedColumn<int> voidAt = GeneratedColumn<int>(
    'void_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    kasirId,
    subtotal,
    diskonItem,
    diskonStrukTipe,
    diskonStrukNilai,
    pajakPersen,
    pajakNilai,
    total,
    bayar,
    kembalian,
    metode,
    status,
    voidReason,
    voidBy,
    voidAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('kasir_id')) {
      context.handle(
        _kasirIdMeta,
        kasirId.isAcceptableOrUnknown(data['kasir_id']!, _kasirIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kasirIdMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('diskon_item')) {
      context.handle(
        _diskonItemMeta,
        diskonItem.isAcceptableOrUnknown(data['diskon_item']!, _diskonItemMeta),
      );
    } else if (isInserting) {
      context.missing(_diskonItemMeta);
    }
    if (data.containsKey('diskon_struk_tipe')) {
      context.handle(
        _diskonStrukTipeMeta,
        diskonStrukTipe.isAcceptableOrUnknown(
          data['diskon_struk_tipe']!,
          _diskonStrukTipeMeta,
        ),
      );
    }
    if (data.containsKey('diskon_struk_nilai')) {
      context.handle(
        _diskonStrukNilaiMeta,
        diskonStrukNilai.isAcceptableOrUnknown(
          data['diskon_struk_nilai']!,
          _diskonStrukNilaiMeta,
        ),
      );
    }
    if (data.containsKey('pajak_persen')) {
      context.handle(
        _pajakPersenMeta,
        pajakPersen.isAcceptableOrUnknown(
          data['pajak_persen']!,
          _pajakPersenMeta,
        ),
      );
    }
    if (data.containsKey('pajak_nilai')) {
      context.handle(
        _pajakNilaiMeta,
        pajakNilai.isAcceptableOrUnknown(data['pajak_nilai']!, _pajakNilaiMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('bayar')) {
      context.handle(
        _bayarMeta,
        bayar.isAcceptableOrUnknown(data['bayar']!, _bayarMeta),
      );
    } else if (isInserting) {
      context.missing(_bayarMeta);
    }
    if (data.containsKey('kembalian')) {
      context.handle(
        _kembalianMeta,
        kembalian.isAcceptableOrUnknown(data['kembalian']!, _kembalianMeta),
      );
    } else if (isInserting) {
      context.missing(_kembalianMeta);
    }
    if (data.containsKey('metode')) {
      context.handle(
        _metodeMeta,
        metode.isAcceptableOrUnknown(data['metode']!, _metodeMeta),
      );
    } else if (isInserting) {
      context.missing(_metodeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('void_reason')) {
      context.handle(
        _voidReasonMeta,
        voidReason.isAcceptableOrUnknown(data['void_reason']!, _voidReasonMeta),
      );
    }
    if (data.containsKey('void_by')) {
      context.handle(
        _voidByMeta,
        voidBy.isAcceptableOrUnknown(data['void_by']!, _voidByMeta),
      );
    }
    if (data.containsKey('void_at')) {
      context.handle(
        _voidAtMeta,
        voidAt.isAcceptableOrUnknown(data['void_at']!, _voidAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      kasirId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kasir_id'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal'],
      )!,
      diskonItem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diskon_item'],
      )!,
      diskonStrukTipe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diskon_struk_tipe'],
      )!,
      diskonStrukNilai: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diskon_struk_nilai'],
      )!,
      pajakPersen: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pajak_persen'],
      )!,
      pajakNilai: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pajak_nilai'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      bayar: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bayar'],
      )!,
      kembalian: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kembalian'],
      )!,
      metode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metode'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      voidReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}void_reason'],
      ),
      voidBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}void_by'],
      ),
      voidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}void_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class DbTransaction extends DataClass implements Insertable<DbTransaction> {
  final String id;
  final String? customerId;
  final String kasirId;
  final int subtotal;
  final int diskonItem;
  final String diskonStrukTipe;
  final int diskonStrukNilai;
  final int pajakPersen;
  final int pajakNilai;
  final int total;
  final int bayar;
  final int kembalian;
  final String metode;
  final String status;
  final String? voidReason;
  final String? voidBy;
  final int? voidAt;
  final int createdAt;
  const DbTransaction({
    required this.id,
    this.customerId,
    required this.kasirId,
    required this.subtotal,
    required this.diskonItem,
    required this.diskonStrukTipe,
    required this.diskonStrukNilai,
    required this.pajakPersen,
    required this.pajakNilai,
    required this.total,
    required this.bayar,
    required this.kembalian,
    required this.metode,
    required this.status,
    this.voidReason,
    this.voidBy,
    this.voidAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['kasir_id'] = Variable<String>(kasirId);
    map['subtotal'] = Variable<int>(subtotal);
    map['diskon_item'] = Variable<int>(diskonItem);
    map['diskon_struk_tipe'] = Variable<String>(diskonStrukTipe);
    map['diskon_struk_nilai'] = Variable<int>(diskonStrukNilai);
    map['pajak_persen'] = Variable<int>(pajakPersen);
    map['pajak_nilai'] = Variable<int>(pajakNilai);
    map['total'] = Variable<int>(total);
    map['bayar'] = Variable<int>(bayar);
    map['kembalian'] = Variable<int>(kembalian);
    map['metode'] = Variable<String>(metode);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || voidReason != null) {
      map['void_reason'] = Variable<String>(voidReason);
    }
    if (!nullToAbsent || voidBy != null) {
      map['void_by'] = Variable<String>(voidBy);
    }
    if (!nullToAbsent || voidAt != null) {
      map['void_at'] = Variable<int>(voidAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      kasirId: Value(kasirId),
      subtotal: Value(subtotal),
      diskonItem: Value(diskonItem),
      diskonStrukTipe: Value(diskonStrukTipe),
      diskonStrukNilai: Value(diskonStrukNilai),
      pajakPersen: Value(pajakPersen),
      pajakNilai: Value(pajakNilai),
      total: Value(total),
      bayar: Value(bayar),
      kembalian: Value(kembalian),
      metode: Value(metode),
      status: Value(status),
      voidReason: voidReason == null && nullToAbsent
          ? const Value.absent()
          : Value(voidReason),
      voidBy: voidBy == null && nullToAbsent
          ? const Value.absent()
          : Value(voidBy),
      voidAt: voidAt == null && nullToAbsent
          ? const Value.absent()
          : Value(voidAt),
      createdAt: Value(createdAt),
    );
  }

  factory DbTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbTransaction(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      kasirId: serializer.fromJson<String>(json['kasirId']),
      subtotal: serializer.fromJson<int>(json['subtotal']),
      diskonItem: serializer.fromJson<int>(json['diskonItem']),
      diskonStrukTipe: serializer.fromJson<String>(json['diskonStrukTipe']),
      diskonStrukNilai: serializer.fromJson<int>(json['diskonStrukNilai']),
      pajakPersen: serializer.fromJson<int>(json['pajakPersen']),
      pajakNilai: serializer.fromJson<int>(json['pajakNilai']),
      total: serializer.fromJson<int>(json['total']),
      bayar: serializer.fromJson<int>(json['bayar']),
      kembalian: serializer.fromJson<int>(json['kembalian']),
      metode: serializer.fromJson<String>(json['metode']),
      status: serializer.fromJson<String>(json['status']),
      voidReason: serializer.fromJson<String?>(json['voidReason']),
      voidBy: serializer.fromJson<String?>(json['voidBy']),
      voidAt: serializer.fromJson<int?>(json['voidAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String?>(customerId),
      'kasirId': serializer.toJson<String>(kasirId),
      'subtotal': serializer.toJson<int>(subtotal),
      'diskonItem': serializer.toJson<int>(diskonItem),
      'diskonStrukTipe': serializer.toJson<String>(diskonStrukTipe),
      'diskonStrukNilai': serializer.toJson<int>(diskonStrukNilai),
      'pajakPersen': serializer.toJson<int>(pajakPersen),
      'pajakNilai': serializer.toJson<int>(pajakNilai),
      'total': serializer.toJson<int>(total),
      'bayar': serializer.toJson<int>(bayar),
      'kembalian': serializer.toJson<int>(kembalian),
      'metode': serializer.toJson<String>(metode),
      'status': serializer.toJson<String>(status),
      'voidReason': serializer.toJson<String?>(voidReason),
      'voidBy': serializer.toJson<String?>(voidBy),
      'voidAt': serializer.toJson<int?>(voidAt),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  DbTransaction copyWith({
    String? id,
    Value<String?> customerId = const Value.absent(),
    String? kasirId,
    int? subtotal,
    int? diskonItem,
    String? diskonStrukTipe,
    int? diskonStrukNilai,
    int? pajakPersen,
    int? pajakNilai,
    int? total,
    int? bayar,
    int? kembalian,
    String? metode,
    String? status,
    Value<String?> voidReason = const Value.absent(),
    Value<String?> voidBy = const Value.absent(),
    Value<int?> voidAt = const Value.absent(),
    int? createdAt,
  }) => DbTransaction(
    id: id ?? this.id,
    customerId: customerId.present ? customerId.value : this.customerId,
    kasirId: kasirId ?? this.kasirId,
    subtotal: subtotal ?? this.subtotal,
    diskonItem: diskonItem ?? this.diskonItem,
    diskonStrukTipe: diskonStrukTipe ?? this.diskonStrukTipe,
    diskonStrukNilai: diskonStrukNilai ?? this.diskonStrukNilai,
    pajakPersen: pajakPersen ?? this.pajakPersen,
    pajakNilai: pajakNilai ?? this.pajakNilai,
    total: total ?? this.total,
    bayar: bayar ?? this.bayar,
    kembalian: kembalian ?? this.kembalian,
    metode: metode ?? this.metode,
    status: status ?? this.status,
    voidReason: voidReason.present ? voidReason.value : this.voidReason,
    voidBy: voidBy.present ? voidBy.value : this.voidBy,
    voidAt: voidAt.present ? voidAt.value : this.voidAt,
    createdAt: createdAt ?? this.createdAt,
  );
  DbTransaction copyWithCompanion(TransactionsCompanion data) {
    return DbTransaction(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      kasirId: data.kasirId.present ? data.kasirId.value : this.kasirId,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      diskonItem: data.diskonItem.present
          ? data.diskonItem.value
          : this.diskonItem,
      diskonStrukTipe: data.diskonStrukTipe.present
          ? data.diskonStrukTipe.value
          : this.diskonStrukTipe,
      diskonStrukNilai: data.diskonStrukNilai.present
          ? data.diskonStrukNilai.value
          : this.diskonStrukNilai,
      pajakPersen: data.pajakPersen.present
          ? data.pajakPersen.value
          : this.pajakPersen,
      pajakNilai: data.pajakNilai.present
          ? data.pajakNilai.value
          : this.pajakNilai,
      total: data.total.present ? data.total.value : this.total,
      bayar: data.bayar.present ? data.bayar.value : this.bayar,
      kembalian: data.kembalian.present ? data.kembalian.value : this.kembalian,
      metode: data.metode.present ? data.metode.value : this.metode,
      status: data.status.present ? data.status.value : this.status,
      voidReason: data.voidReason.present
          ? data.voidReason.value
          : this.voidReason,
      voidBy: data.voidBy.present ? data.voidBy.value : this.voidBy,
      voidAt: data.voidAt.present ? data.voidAt.value : this.voidAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbTransaction(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('kasirId: $kasirId, ')
          ..write('subtotal: $subtotal, ')
          ..write('diskonItem: $diskonItem, ')
          ..write('diskonStrukTipe: $diskonStrukTipe, ')
          ..write('diskonStrukNilai: $diskonStrukNilai, ')
          ..write('pajakPersen: $pajakPersen, ')
          ..write('pajakNilai: $pajakNilai, ')
          ..write('total: $total, ')
          ..write('bayar: $bayar, ')
          ..write('kembalian: $kembalian, ')
          ..write('metode: $metode, ')
          ..write('status: $status, ')
          ..write('voidReason: $voidReason, ')
          ..write('voidBy: $voidBy, ')
          ..write('voidAt: $voidAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    kasirId,
    subtotal,
    diskonItem,
    diskonStrukTipe,
    diskonStrukNilai,
    pajakPersen,
    pajakNilai,
    total,
    bayar,
    kembalian,
    metode,
    status,
    voidReason,
    voidBy,
    voidAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbTransaction &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.kasirId == this.kasirId &&
          other.subtotal == this.subtotal &&
          other.diskonItem == this.diskonItem &&
          other.diskonStrukTipe == this.diskonStrukTipe &&
          other.diskonStrukNilai == this.diskonStrukNilai &&
          other.pajakPersen == this.pajakPersen &&
          other.pajakNilai == this.pajakNilai &&
          other.total == this.total &&
          other.bayar == this.bayar &&
          other.kembalian == this.kembalian &&
          other.metode == this.metode &&
          other.status == this.status &&
          other.voidReason == this.voidReason &&
          other.voidBy == this.voidBy &&
          other.voidAt == this.voidAt &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<DbTransaction> {
  final Value<String> id;
  final Value<String?> customerId;
  final Value<String> kasirId;
  final Value<int> subtotal;
  final Value<int> diskonItem;
  final Value<String> diskonStrukTipe;
  final Value<int> diskonStrukNilai;
  final Value<int> pajakPersen;
  final Value<int> pajakNilai;
  final Value<int> total;
  final Value<int> bayar;
  final Value<int> kembalian;
  final Value<String> metode;
  final Value<String> status;
  final Value<String?> voidReason;
  final Value<String?> voidBy;
  final Value<int?> voidAt;
  final Value<int> createdAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.kasirId = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.diskonItem = const Value.absent(),
    this.diskonStrukTipe = const Value.absent(),
    this.diskonStrukNilai = const Value.absent(),
    this.pajakPersen = const Value.absent(),
    this.pajakNilai = const Value.absent(),
    this.total = const Value.absent(),
    this.bayar = const Value.absent(),
    this.kembalian = const Value.absent(),
    this.metode = const Value.absent(),
    this.status = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.voidBy = const Value.absent(),
    this.voidAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    this.customerId = const Value.absent(),
    required String kasirId,
    required int subtotal,
    required int diskonItem,
    this.diskonStrukTipe = const Value.absent(),
    this.diskonStrukNilai = const Value.absent(),
    this.pajakPersen = const Value.absent(),
    this.pajakNilai = const Value.absent(),
    required int total,
    required int bayar,
    required int kembalian,
    required String metode,
    this.status = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.voidBy = const Value.absent(),
    this.voidAt = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kasirId = Value(kasirId),
       subtotal = Value(subtotal),
       diskonItem = Value(diskonItem),
       total = Value(total),
       bayar = Value(bayar),
       kembalian = Value(kembalian),
       metode = Value(metode),
       createdAt = Value(createdAt);
  static Insertable<DbTransaction> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? kasirId,
    Expression<int>? subtotal,
    Expression<int>? diskonItem,
    Expression<String>? diskonStrukTipe,
    Expression<int>? diskonStrukNilai,
    Expression<int>? pajakPersen,
    Expression<int>? pajakNilai,
    Expression<int>? total,
    Expression<int>? bayar,
    Expression<int>? kembalian,
    Expression<String>? metode,
    Expression<String>? status,
    Expression<String>? voidReason,
    Expression<String>? voidBy,
    Expression<int>? voidAt,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (kasirId != null) 'kasir_id': kasirId,
      if (subtotal != null) 'subtotal': subtotal,
      if (diskonItem != null) 'diskon_item': diskonItem,
      if (diskonStrukTipe != null) 'diskon_struk_tipe': diskonStrukTipe,
      if (diskonStrukNilai != null) 'diskon_struk_nilai': diskonStrukNilai,
      if (pajakPersen != null) 'pajak_persen': pajakPersen,
      if (pajakNilai != null) 'pajak_nilai': pajakNilai,
      if (total != null) 'total': total,
      if (bayar != null) 'bayar': bayar,
      if (kembalian != null) 'kembalian': kembalian,
      if (metode != null) 'metode': metode,
      if (status != null) 'status': status,
      if (voidReason != null) 'void_reason': voidReason,
      if (voidBy != null) 'void_by': voidBy,
      if (voidAt != null) 'void_at': voidAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? customerId,
    Value<String>? kasirId,
    Value<int>? subtotal,
    Value<int>? diskonItem,
    Value<String>? diskonStrukTipe,
    Value<int>? diskonStrukNilai,
    Value<int>? pajakPersen,
    Value<int>? pajakNilai,
    Value<int>? total,
    Value<int>? bayar,
    Value<int>? kembalian,
    Value<String>? metode,
    Value<String>? status,
    Value<String?>? voidReason,
    Value<String?>? voidBy,
    Value<int?>? voidAt,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      kasirId: kasirId ?? this.kasirId,
      subtotal: subtotal ?? this.subtotal,
      diskonItem: diskonItem ?? this.diskonItem,
      diskonStrukTipe: diskonStrukTipe ?? this.diskonStrukTipe,
      diskonStrukNilai: diskonStrukNilai ?? this.diskonStrukNilai,
      pajakPersen: pajakPersen ?? this.pajakPersen,
      pajakNilai: pajakNilai ?? this.pajakNilai,
      total: total ?? this.total,
      bayar: bayar ?? this.bayar,
      kembalian: kembalian ?? this.kembalian,
      metode: metode ?? this.metode,
      status: status ?? this.status,
      voidReason: voidReason ?? this.voidReason,
      voidBy: voidBy ?? this.voidBy,
      voidAt: voidAt ?? this.voidAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (kasirId.present) {
      map['kasir_id'] = Variable<String>(kasirId.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    if (diskonItem.present) {
      map['diskon_item'] = Variable<int>(diskonItem.value);
    }
    if (diskonStrukTipe.present) {
      map['diskon_struk_tipe'] = Variable<String>(diskonStrukTipe.value);
    }
    if (diskonStrukNilai.present) {
      map['diskon_struk_nilai'] = Variable<int>(diskonStrukNilai.value);
    }
    if (pajakPersen.present) {
      map['pajak_persen'] = Variable<int>(pajakPersen.value);
    }
    if (pajakNilai.present) {
      map['pajak_nilai'] = Variable<int>(pajakNilai.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (bayar.present) {
      map['bayar'] = Variable<int>(bayar.value);
    }
    if (kembalian.present) {
      map['kembalian'] = Variable<int>(kembalian.value);
    }
    if (metode.present) {
      map['metode'] = Variable<String>(metode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (voidReason.present) {
      map['void_reason'] = Variable<String>(voidReason.value);
    }
    if (voidBy.present) {
      map['void_by'] = Variable<String>(voidBy.value);
    }
    if (voidAt.present) {
      map['void_at'] = Variable<int>(voidAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('kasirId: $kasirId, ')
          ..write('subtotal: $subtotal, ')
          ..write('diskonItem: $diskonItem, ')
          ..write('diskonStrukTipe: $diskonStrukTipe, ')
          ..write('diskonStrukNilai: $diskonStrukNilai, ')
          ..write('pajakPersen: $pajakPersen, ')
          ..write('pajakNilai: $pajakNilai, ')
          ..write('total: $total, ')
          ..write('bayar: $bayar, ')
          ..write('kembalian: $kembalian, ')
          ..write('metode: $metode, ')
          ..write('status: $status, ')
          ..write('voidReason: $voidReason, ')
          ..write('voidBy: $voidBy, ')
          ..write('voidAt: $voidAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionItemsTable extends TransactionItems
    with TableInfo<$TransactionItemsTable, DbTransactionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaSnapshotMeta = const VerificationMeta(
    'namaSnapshot',
  );
  @override
  late final GeneratedColumn<String> namaSnapshot = GeneratedColumn<String>(
    'nama_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaSnapshotMeta = const VerificationMeta(
    'hargaSnapshot',
  );
  @override
  late final GeneratedColumn<int> hargaSnapshot = GeneratedColumn<int>(
    'harga_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diskonTipeMeta = const VerificationMeta(
    'diskonTipe',
  );
  @override
  late final GeneratedColumn<String> diskonTipe = GeneratedColumn<String>(
    'diskon_tipe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _diskonNilaiMeta = const VerificationMeta(
    'diskonNilai',
  );
  @override
  late final GeneratedColumn<int> diskonNilai = GeneratedColumn<int>(
    'diskon_nilai',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    productId,
    namaSnapshot,
    hargaSnapshot,
    qty,
    diskonTipe,
    diskonNilai,
    subtotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbTransactionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('nama_snapshot')) {
      context.handle(
        _namaSnapshotMeta,
        namaSnapshot.isAcceptableOrUnknown(
          data['nama_snapshot']!,
          _namaSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_namaSnapshotMeta);
    }
    if (data.containsKey('harga_snapshot')) {
      context.handle(
        _hargaSnapshotMeta,
        hargaSnapshot.isAcceptableOrUnknown(
          data['harga_snapshot']!,
          _hargaSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hargaSnapshotMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('diskon_tipe')) {
      context.handle(
        _diskonTipeMeta,
        diskonTipe.isAcceptableOrUnknown(data['diskon_tipe']!, _diskonTipeMeta),
      );
    }
    if (data.containsKey('diskon_nilai')) {
      context.handle(
        _diskonNilaiMeta,
        diskonNilai.isAcceptableOrUnknown(
          data['diskon_nilai']!,
          _diskonNilaiMeta,
        ),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbTransactionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbTransactionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      namaSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_snapshot'],
      )!,
      hargaSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}harga_snapshot'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      diskonTipe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diskon_tipe'],
      )!,
      diskonNilai: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diskon_nilai'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal'],
      )!,
    );
  }

  @override
  $TransactionItemsTable createAlias(String alias) {
    return $TransactionItemsTable(attachedDatabase, alias);
  }
}

class DbTransactionItem extends DataClass
    implements Insertable<DbTransactionItem> {
  final String id;
  final String transactionId;
  final String productId;
  final String namaSnapshot;
  final int hargaSnapshot;
  final int qty;
  final String diskonTipe;
  final int diskonNilai;
  final int subtotal;
  const DbTransactionItem({
    required this.id,
    required this.transactionId,
    required this.productId,
    required this.namaSnapshot,
    required this.hargaSnapshot,
    required this.qty,
    required this.diskonTipe,
    required this.diskonNilai,
    required this.subtotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transaction_id'] = Variable<String>(transactionId);
    map['product_id'] = Variable<String>(productId);
    map['nama_snapshot'] = Variable<String>(namaSnapshot);
    map['harga_snapshot'] = Variable<int>(hargaSnapshot);
    map['qty'] = Variable<int>(qty);
    map['diskon_tipe'] = Variable<String>(diskonTipe);
    map['diskon_nilai'] = Variable<int>(diskonNilai);
    map['subtotal'] = Variable<int>(subtotal);
    return map;
  }

  TransactionItemsCompanion toCompanion(bool nullToAbsent) {
    return TransactionItemsCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      productId: Value(productId),
      namaSnapshot: Value(namaSnapshot),
      hargaSnapshot: Value(hargaSnapshot),
      qty: Value(qty),
      diskonTipe: Value(diskonTipe),
      diskonNilai: Value(diskonNilai),
      subtotal: Value(subtotal),
    );
  }

  factory DbTransactionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbTransactionItem(
      id: serializer.fromJson<String>(json['id']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      productId: serializer.fromJson<String>(json['productId']),
      namaSnapshot: serializer.fromJson<String>(json['namaSnapshot']),
      hargaSnapshot: serializer.fromJson<int>(json['hargaSnapshot']),
      qty: serializer.fromJson<int>(json['qty']),
      diskonTipe: serializer.fromJson<String>(json['diskonTipe']),
      diskonNilai: serializer.fromJson<int>(json['diskonNilai']),
      subtotal: serializer.fromJson<int>(json['subtotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transactionId': serializer.toJson<String>(transactionId),
      'productId': serializer.toJson<String>(productId),
      'namaSnapshot': serializer.toJson<String>(namaSnapshot),
      'hargaSnapshot': serializer.toJson<int>(hargaSnapshot),
      'qty': serializer.toJson<int>(qty),
      'diskonTipe': serializer.toJson<String>(diskonTipe),
      'diskonNilai': serializer.toJson<int>(diskonNilai),
      'subtotal': serializer.toJson<int>(subtotal),
    };
  }

  DbTransactionItem copyWith({
    String? id,
    String? transactionId,
    String? productId,
    String? namaSnapshot,
    int? hargaSnapshot,
    int? qty,
    String? diskonTipe,
    int? diskonNilai,
    int? subtotal,
  }) => DbTransactionItem(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    productId: productId ?? this.productId,
    namaSnapshot: namaSnapshot ?? this.namaSnapshot,
    hargaSnapshot: hargaSnapshot ?? this.hargaSnapshot,
    qty: qty ?? this.qty,
    diskonTipe: diskonTipe ?? this.diskonTipe,
    diskonNilai: diskonNilai ?? this.diskonNilai,
    subtotal: subtotal ?? this.subtotal,
  );
  DbTransactionItem copyWithCompanion(TransactionItemsCompanion data) {
    return DbTransactionItem(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      productId: data.productId.present ? data.productId.value : this.productId,
      namaSnapshot: data.namaSnapshot.present
          ? data.namaSnapshot.value
          : this.namaSnapshot,
      hargaSnapshot: data.hargaSnapshot.present
          ? data.hargaSnapshot.value
          : this.hargaSnapshot,
      qty: data.qty.present ? data.qty.value : this.qty,
      diskonTipe: data.diskonTipe.present
          ? data.diskonTipe.value
          : this.diskonTipe,
      diskonNilai: data.diskonNilai.present
          ? data.diskonNilai.value
          : this.diskonNilai,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbTransactionItem(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('productId: $productId, ')
          ..write('namaSnapshot: $namaSnapshot, ')
          ..write('hargaSnapshot: $hargaSnapshot, ')
          ..write('qty: $qty, ')
          ..write('diskonTipe: $diskonTipe, ')
          ..write('diskonNilai: $diskonNilai, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionId,
    productId,
    namaSnapshot,
    hargaSnapshot,
    qty,
    diskonTipe,
    diskonNilai,
    subtotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbTransactionItem &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.productId == this.productId &&
          other.namaSnapshot == this.namaSnapshot &&
          other.hargaSnapshot == this.hargaSnapshot &&
          other.qty == this.qty &&
          other.diskonTipe == this.diskonTipe &&
          other.diskonNilai == this.diskonNilai &&
          other.subtotal == this.subtotal);
}

class TransactionItemsCompanion extends UpdateCompanion<DbTransactionItem> {
  final Value<String> id;
  final Value<String> transactionId;
  final Value<String> productId;
  final Value<String> namaSnapshot;
  final Value<int> hargaSnapshot;
  final Value<int> qty;
  final Value<String> diskonTipe;
  final Value<int> diskonNilai;
  final Value<int> subtotal;
  final Value<int> rowid;
  const TransactionItemsCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.productId = const Value.absent(),
    this.namaSnapshot = const Value.absent(),
    this.hargaSnapshot = const Value.absent(),
    this.qty = const Value.absent(),
    this.diskonTipe = const Value.absent(),
    this.diskonNilai = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionItemsCompanion.insert({
    required String id,
    required String transactionId,
    required String productId,
    required String namaSnapshot,
    required int hargaSnapshot,
    required int qty,
    this.diskonTipe = const Value.absent(),
    this.diskonNilai = const Value.absent(),
    required int subtotal,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transactionId = Value(transactionId),
       productId = Value(productId),
       namaSnapshot = Value(namaSnapshot),
       hargaSnapshot = Value(hargaSnapshot),
       qty = Value(qty),
       subtotal = Value(subtotal);
  static Insertable<DbTransactionItem> custom({
    Expression<String>? id,
    Expression<String>? transactionId,
    Expression<String>? productId,
    Expression<String>? namaSnapshot,
    Expression<int>? hargaSnapshot,
    Expression<int>? qty,
    Expression<String>? diskonTipe,
    Expression<int>? diskonNilai,
    Expression<int>? subtotal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (productId != null) 'product_id': productId,
      if (namaSnapshot != null) 'nama_snapshot': namaSnapshot,
      if (hargaSnapshot != null) 'harga_snapshot': hargaSnapshot,
      if (qty != null) 'qty': qty,
      if (diskonTipe != null) 'diskon_tipe': diskonTipe,
      if (diskonNilai != null) 'diskon_nilai': diskonNilai,
      if (subtotal != null) 'subtotal': subtotal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? transactionId,
    Value<String>? productId,
    Value<String>? namaSnapshot,
    Value<int>? hargaSnapshot,
    Value<int>? qty,
    Value<String>? diskonTipe,
    Value<int>? diskonNilai,
    Value<int>? subtotal,
    Value<int>? rowid,
  }) {
    return TransactionItemsCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      productId: productId ?? this.productId,
      namaSnapshot: namaSnapshot ?? this.namaSnapshot,
      hargaSnapshot: hargaSnapshot ?? this.hargaSnapshot,
      qty: qty ?? this.qty,
      diskonTipe: diskonTipe ?? this.diskonTipe,
      diskonNilai: diskonNilai ?? this.diskonNilai,
      subtotal: subtotal ?? this.subtotal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (namaSnapshot.present) {
      map['nama_snapshot'] = Variable<String>(namaSnapshot.value);
    }
    if (hargaSnapshot.present) {
      map['harga_snapshot'] = Variable<int>(hargaSnapshot.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (diskonTipe.present) {
      map['diskon_tipe'] = Variable<String>(diskonTipe.value);
    }
    if (diskonNilai.present) {
      map['diskon_nilai'] = Variable<int>(diskonNilai.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItemsCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('productId: $productId, ')
          ..write('namaSnapshot: $namaSnapshot, ')
          ..write('hargaSnapshot: $hargaSnapshot, ')
          ..write('qty: $qty, ')
          ..write('diskonTipe: $diskonTipe, ')
          ..write('diskonNilai: $diskonNilai, ')
          ..write('subtotal: $subtotal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionItemsTable transactionItems = $TransactionItemsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    customers,
    users,
    settings,
    transactions,
    transactionItems,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String nama,
      required String kategori,
      required int harga,
      Value<int> stok,
      Value<int> trackStock,
      Value<String?> gambarPath,
      Value<int> isActive,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> nama,
      Value<String> kategori,
      Value<int> harga,
      Value<int> stok,
      Value<int> trackStock,
      Value<String?> gambarPath,
      Value<int> isActive,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kategori => $composableBuilder(
    column: $table.kategori,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get harga => $composableBuilder(
    column: $table.harga,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stok => $composableBuilder(
    column: $table.stok,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gambarPath => $composableBuilder(
    column: $table.gambarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kategori => $composableBuilder(
    column: $table.kategori,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get harga => $composableBuilder(
    column: $table.harga,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stok => $composableBuilder(
    column: $table.stok,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gambarPath => $composableBuilder(
    column: $table.gambarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get kategori =>
      $composableBuilder(column: $table.kategori, builder: (column) => column);

  GeneratedColumn<int> get harga =>
      $composableBuilder(column: $table.harga, builder: (column) => column);

  GeneratedColumn<int> get stok =>
      $composableBuilder(column: $table.stok, builder: (column) => column);

  GeneratedColumn<int> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gambarPath => $composableBuilder(
    column: $table.gambarPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          DbProduct,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (DbProduct, BaseReferences<_$AppDatabase, $ProductsTable, DbProduct>),
          DbProduct,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String> kategori = const Value.absent(),
                Value<int> harga = const Value.absent(),
                Value<int> stok = const Value.absent(),
                Value<int> trackStock = const Value.absent(),
                Value<String?> gambarPath = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                nama: nama,
                kategori: kategori,
                harga: harga,
                stok: stok,
                trackStock: trackStock,
                gambarPath: gambarPath,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nama,
                required String kategori,
                required int harga,
                Value<int> stok = const Value.absent(),
                Value<int> trackStock = const Value.absent(),
                Value<String?> gambarPath = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                nama: nama,
                kategori: kategori,
                harga: harga,
                stok: stok,
                trackStock: trackStock,
                gambarPath: gambarPath,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductsTable, DbProduct>(table),
                  BaseReferences<_$AppDatabase, $ProductsTable, DbProduct>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      DbProduct,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (DbProduct, BaseReferences<_$AppDatabase, $ProductsTable, DbProduct>),
      DbProduct,
      PrefetchHooks Function()
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      required String nama,
      Value<String?> hp,
      Value<String?> alamat,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<String> nama,
      Value<String?> hp,
      Value<String?> alamat,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hp => $composableBuilder(
    column: $table.hp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alamat => $composableBuilder(
    column: $table.alamat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hp => $composableBuilder(
    column: $table.hp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alamat => $composableBuilder(
    column: $table.alamat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get hp =>
      $composableBuilder(column: $table.hp, builder: (column) => column);

  GeneratedColumn<String> get alamat =>
      $composableBuilder(column: $table.alamat, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          DbCustomer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (
            DbCustomer,
            BaseReferences<_$AppDatabase, $CustomersTable, DbCustomer>,
          ),
          DbCustomer,
          PrefetchHooks Function()
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String?> hp = const Value.absent(),
                Value<String?> alamat = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                nama: nama,
                hp: hp,
                alamat: alamat,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nama,
                Value<String?> hp = const Value.absent(),
                Value<String?> alamat = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                nama: nama,
                hp: hp,
                alamat: alamat,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomersTable, DbCustomer>(table),
                  BaseReferences<_$AppDatabase, $CustomersTable, DbCustomer>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      DbCustomer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (DbCustomer, BaseReferences<_$AppDatabase, $CustomersTable, DbCustomer>),
      DbCustomer,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String nama,
      required String pinHash,
      required String pinSalt,
      required String role,
      Value<int> isActive,
      Value<int> mustChangePin,
      Value<int> failedAttempts,
      Value<int?> lockedUntil,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> nama,
      Value<String> pinHash,
      Value<String> pinSalt,
      Value<String> role,
      Value<int> isActive,
      Value<int> mustChangePin,
      Value<int> failedAttempts,
      Value<int?> lockedUntil,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mustChangePin => $composableBuilder(
    column: $table.mustChangePin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get failedAttempts => $composableBuilder(
    column: $table.failedAttempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lockedUntil => $composableBuilder(
    column: $table.lockedUntil,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mustChangePin => $composableBuilder(
    column: $table.mustChangePin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get failedAttempts => $composableBuilder(
    column: $table.failedAttempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lockedUntil => $composableBuilder(
    column: $table.lockedUntil,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get pinSalt =>
      $composableBuilder(column: $table.pinSalt, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get mustChangePin => $composableBuilder(
    column: $table.mustChangePin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get failedAttempts => $composableBuilder(
    column: $table.failedAttempts,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lockedUntil => $composableBuilder(
    column: $table.lockedUntil,
    builder: (column) => column,
  );
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          DbUser,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (DbUser, BaseReferences<_$AppDatabase, $UsersTable, DbUser>),
          DbUser,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String> pinHash = const Value.absent(),
                Value<String> pinSalt = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<int> mustChangePin = const Value.absent(),
                Value<int> failedAttempts = const Value.absent(),
                Value<int?> lockedUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                nama: nama,
                pinHash: pinHash,
                pinSalt: pinSalt,
                role: role,
                isActive: isActive,
                mustChangePin: mustChangePin,
                failedAttempts: failedAttempts,
                lockedUntil: lockedUntil,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nama,
                required String pinHash,
                required String pinSalt,
                required String role,
                Value<int> isActive = const Value.absent(),
                Value<int> mustChangePin = const Value.absent(),
                Value<int> failedAttempts = const Value.absent(),
                Value<int?> lockedUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                nama: nama,
                pinHash: pinHash,
                pinSalt: pinSalt,
                role: role,
                isActive: isActive,
                mustChangePin: mustChangePin,
                failedAttempts: failedAttempts,
                lockedUntil: lockedUntil,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsersTable, DbUser>(table),
                  BaseReferences<_$AppDatabase, $UsersTable, DbUser>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      DbUser,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (DbUser, BaseReferences<_$AppDatabase, $UsersTable, DbUser>),
      DbUser,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          DbSetting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (DbSetting, BaseReferences<_$AppDatabase, $SettingsTable, DbSetting>),
          DbSetting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, DbSetting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, DbSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      DbSetting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (DbSetting, BaseReferences<_$AppDatabase, $SettingsTable, DbSetting>),
      DbSetting,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      Value<String?> customerId,
      required String kasirId,
      required int subtotal,
      required int diskonItem,
      Value<String> diskonStrukTipe,
      Value<int> diskonStrukNilai,
      Value<int> pajakPersen,
      Value<int> pajakNilai,
      required int total,
      required int bayar,
      required int kembalian,
      required String metode,
      Value<String> status,
      Value<String?> voidReason,
      Value<String?> voidBy,
      Value<int?> voidAt,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String?> customerId,
      Value<String> kasirId,
      Value<int> subtotal,
      Value<int> diskonItem,
      Value<String> diskonStrukTipe,
      Value<int> diskonStrukNilai,
      Value<int> pajakPersen,
      Value<int> pajakNilai,
      Value<int> total,
      Value<int> bayar,
      Value<int> kembalian,
      Value<String> metode,
      Value<String> status,
      Value<String?> voidReason,
      Value<String?> voidBy,
      Value<int?> voidAt,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kasirId => $composableBuilder(
    column: $table.kasirId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diskonItem => $composableBuilder(
    column: $table.diskonItem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diskonStrukTipe => $composableBuilder(
    column: $table.diskonStrukTipe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diskonStrukNilai => $composableBuilder(
    column: $table.diskonStrukNilai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pajakPersen => $composableBuilder(
    column: $table.pajakPersen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pajakNilai => $composableBuilder(
    column: $table.pajakNilai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bayar => $composableBuilder(
    column: $table.bayar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kembalian => $composableBuilder(
    column: $table.kembalian,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metode => $composableBuilder(
    column: $table.metode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voidBy => $composableBuilder(
    column: $table.voidBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get voidAt => $composableBuilder(
    column: $table.voidAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kasirId => $composableBuilder(
    column: $table.kasirId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diskonItem => $composableBuilder(
    column: $table.diskonItem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diskonStrukTipe => $composableBuilder(
    column: $table.diskonStrukTipe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diskonStrukNilai => $composableBuilder(
    column: $table.diskonStrukNilai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pajakPersen => $composableBuilder(
    column: $table.pajakPersen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pajakNilai => $composableBuilder(
    column: $table.pajakNilai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bayar => $composableBuilder(
    column: $table.bayar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kembalian => $composableBuilder(
    column: $table.kembalian,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metode => $composableBuilder(
    column: $table.metode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voidBy => $composableBuilder(
    column: $table.voidBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get voidAt => $composableBuilder(
    column: $table.voidAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kasirId =>
      $composableBuilder(column: $table.kasirId, builder: (column) => column);

  GeneratedColumn<int> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<int> get diskonItem => $composableBuilder(
    column: $table.diskonItem,
    builder: (column) => column,
  );

  GeneratedColumn<String> get diskonStrukTipe => $composableBuilder(
    column: $table.diskonStrukTipe,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diskonStrukNilai => $composableBuilder(
    column: $table.diskonStrukNilai,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pajakPersen => $composableBuilder(
    column: $table.pajakPersen,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pajakNilai => $composableBuilder(
    column: $table.pajakNilai,
    builder: (column) => column,
  );

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get bayar =>
      $composableBuilder(column: $table.bayar, builder: (column) => column);

  GeneratedColumn<int> get kembalian =>
      $composableBuilder(column: $table.kembalian, builder: (column) => column);

  GeneratedColumn<String> get metode =>
      $composableBuilder(column: $table.metode, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get voidBy =>
      $composableBuilder(column: $table.voidBy, builder: (column) => column);

  GeneratedColumn<int> get voidAt =>
      $composableBuilder(column: $table.voidAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          DbTransaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            DbTransaction,
            BaseReferences<_$AppDatabase, $TransactionsTable, DbTransaction>,
          ),
          DbTransaction,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String> kasirId = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<int> diskonItem = const Value.absent(),
                Value<String> diskonStrukTipe = const Value.absent(),
                Value<int> diskonStrukNilai = const Value.absent(),
                Value<int> pajakPersen = const Value.absent(),
                Value<int> pajakNilai = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> bayar = const Value.absent(),
                Value<int> kembalian = const Value.absent(),
                Value<String> metode = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                Value<String?> voidBy = const Value.absent(),
                Value<int?> voidAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                customerId: customerId,
                kasirId: kasirId,
                subtotal: subtotal,
                diskonItem: diskonItem,
                diskonStrukTipe: diskonStrukTipe,
                diskonStrukNilai: diskonStrukNilai,
                pajakPersen: pajakPersen,
                pajakNilai: pajakNilai,
                total: total,
                bayar: bayar,
                kembalian: kembalian,
                metode: metode,
                status: status,
                voidReason: voidReason,
                voidBy: voidBy,
                voidAt: voidAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> customerId = const Value.absent(),
                required String kasirId,
                required int subtotal,
                required int diskonItem,
                Value<String> diskonStrukTipe = const Value.absent(),
                Value<int> diskonStrukNilai = const Value.absent(),
                Value<int> pajakPersen = const Value.absent(),
                Value<int> pajakNilai = const Value.absent(),
                required int total,
                required int bayar,
                required int kembalian,
                required String metode,
                Value<String> status = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                Value<String?> voidBy = const Value.absent(),
                Value<int?> voidAt = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                customerId: customerId,
                kasirId: kasirId,
                subtotal: subtotal,
                diskonItem: diskonItem,
                diskonStrukTipe: diskonStrukTipe,
                diskonStrukNilai: diskonStrukNilai,
                pajakPersen: pajakPersen,
                pajakNilai: pajakNilai,
                total: total,
                bayar: bayar,
                kembalian: kembalian,
                metode: metode,
                status: status,
                voidReason: voidReason,
                voidBy: voidBy,
                voidAt: voidAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, DbTransaction>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TransactionsTable,
                    DbTransaction
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      DbTransaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        DbTransaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, DbTransaction>,
      ),
      DbTransaction,
      PrefetchHooks Function()
    >;
typedef $$TransactionItemsTableCreateCompanionBuilder =
    TransactionItemsCompanion Function({
      required String id,
      required String transactionId,
      required String productId,
      required String namaSnapshot,
      required int hargaSnapshot,
      required int qty,
      Value<String> diskonTipe,
      Value<int> diskonNilai,
      required int subtotal,
      Value<int> rowid,
    });
typedef $$TransactionItemsTableUpdateCompanionBuilder =
    TransactionItemsCompanion Function({
      Value<String> id,
      Value<String> transactionId,
      Value<String> productId,
      Value<String> namaSnapshot,
      Value<int> hargaSnapshot,
      Value<int> qty,
      Value<String> diskonTipe,
      Value<int> diskonNilai,
      Value<int> subtotal,
      Value<int> rowid,
    });

class $$TransactionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaSnapshot => $composableBuilder(
    column: $table.namaSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hargaSnapshot => $composableBuilder(
    column: $table.hargaSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diskonTipe => $composableBuilder(
    column: $table.diskonTipe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diskonNilai => $composableBuilder(
    column: $table.diskonNilai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaSnapshot => $composableBuilder(
    column: $table.namaSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hargaSnapshot => $composableBuilder(
    column: $table.hargaSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diskonTipe => $composableBuilder(
    column: $table.diskonTipe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diskonNilai => $composableBuilder(
    column: $table.diskonNilai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get namaSnapshot => $composableBuilder(
    column: $table.namaSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hargaSnapshot => $composableBuilder(
    column: $table.hargaSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<String> get diskonTipe => $composableBuilder(
    column: $table.diskonTipe,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diskonNilai => $composableBuilder(
    column: $table.diskonNilai,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);
}

class $$TransactionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionItemsTable,
          DbTransactionItem,
          $$TransactionItemsTableFilterComposer,
          $$TransactionItemsTableOrderingComposer,
          $$TransactionItemsTableAnnotationComposer,
          $$TransactionItemsTableCreateCompanionBuilder,
          $$TransactionItemsTableUpdateCompanionBuilder,
          (
            DbTransactionItem,
            BaseReferences<
              _$AppDatabase,
              $TransactionItemsTable,
              DbTransactionItem
            >,
          ),
          DbTransactionItem,
          PrefetchHooks Function()
        > {
  $$TransactionItemsTableTableManager(
    _$AppDatabase db,
    $TransactionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> namaSnapshot = const Value.absent(),
                Value<int> hargaSnapshot = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<String> diskonTipe = const Value.absent(),
                Value<int> diskonNilai = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionItemsCompanion(
                id: id,
                transactionId: transactionId,
                productId: productId,
                namaSnapshot: namaSnapshot,
                hargaSnapshot: hargaSnapshot,
                qty: qty,
                diskonTipe: diskonTipe,
                diskonNilai: diskonNilai,
                subtotal: subtotal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transactionId,
                required String productId,
                required String namaSnapshot,
                required int hargaSnapshot,
                required int qty,
                Value<String> diskonTipe = const Value.absent(),
                Value<int> diskonNilai = const Value.absent(),
                required int subtotal,
                Value<int> rowid = const Value.absent(),
              }) => TransactionItemsCompanion.insert(
                id: id,
                transactionId: transactionId,
                productId: productId,
                namaSnapshot: namaSnapshot,
                hargaSnapshot: hargaSnapshot,
                qty: qty,
                diskonTipe: diskonTipe,
                diskonNilai: diskonNilai,
                subtotal: subtotal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionItemsTable, DbTransactionItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TransactionItemsTable,
                    DbTransactionItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionItemsTable,
      DbTransactionItem,
      $$TransactionItemsTableFilterComposer,
      $$TransactionItemsTableOrderingComposer,
      $$TransactionItemsTableAnnotationComposer,
      $$TransactionItemsTableCreateCompanionBuilder,
      $$TransactionItemsTableUpdateCompanionBuilder,
      (
        DbTransactionItem,
        BaseReferences<
          _$AppDatabase,
          $TransactionItemsTable,
          DbTransactionItem
        >,
      ),
      DbTransactionItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransactionItemsTableTableManager get transactionItems =>
      $$TransactionItemsTableTableManager(_db, _db.transactionItems);
}
