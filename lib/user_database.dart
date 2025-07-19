import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String passwordHash;
  final String userType;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.passwordHash,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'passwordHash': passwordHash,
      'userType': userType,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      passwordHash: map['passwordHash'],
      userType: map['userType'],
    );
  }
}

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();

  static Database? _database;

  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            phone TEXT,
            passwordHash TEXT,
            userType TEXT
          )
        ''');
      },
    );

    return _database!;
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<bool> userExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  // Método para atualizar a senha do usuário pelo email
  Future<int> updatePassword(String email, String newPasswordHash) async {
    final db = await database;
    return await db.update(
      'users',
      {'passwordHash': newPasswordHash},
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
