import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'background_container.dart';
import 'register_page.dart';
import 'user_database.dart';
import 'forgot_password_page.dart';
import 'owner_home_page.dart';
import 'welcome_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  double fontSize = 15; // variável

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha email e senha')));
      return;
    }

    final passwordHash = sha256.convert(utf8.encode(password)).toString();
    final user = await UserDatabase.instance.getUserByEmail(email);

    if (user == null || user.passwordHash != passwordHash) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário ou senha inválidos')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login realizado com sucesso!')),
    );

    if (user.userType == 'cliente') {
      // Alteração: vai para WelcomePage ao invés de GenderSelectionPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              WelcomePage(userName: user.name, userEmail: user.email),
        ),
      );
    } else if (user.userType == 'dono') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OwnerHomePage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tipo de usuário inválido')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(0, 240, 17, 17),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset('assets/elias_logo1.png', height: 165),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4A300), // Amarelo queimado
                  foregroundColor: Colors.black, // Texto escuro para contraste
                ),
                child: const Text('Entrar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: Text(
                  'Não tem conta? Cadastre-se',
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordPage(),
                    ),
                  );
                },
                child: Text(
                  'Esqueceu sua senha?',
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
