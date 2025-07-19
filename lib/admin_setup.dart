import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'user_database.dart';

Future<void> createAdminUser() async {
  const adminEmail = 'elias@salao.com';
  const adminPassword = 'senha123';
  const adminName = 'Elias Barbeiro';
  const adminPhone = '1234567890';
  final passwordHash = sha256.convert(utf8.encode(adminPassword)).toString();

  final alreadyExists = await UserDatabase.instance.userExists(adminEmail);

  if (!alreadyExists) {
    final adminUser = User(
      name: adminName,
      email: adminEmail,
      phone: adminPhone,
      passwordHash: passwordHash,
      userType: 'dono',
    );

    await UserDatabase.instance.insertUser(adminUser);
    print('Usuário administrador criado com sucesso.');
  } else {
    print('Usuário administrador já existe. Nenhuma ação feita.');
  }
}
