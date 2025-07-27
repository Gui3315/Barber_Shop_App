import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'background_container.dart';
import 'user_database.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _emailVerified = false;

  // Opacidade do fundo (pode ser ajustada)
  final double backgroundOpacity = 0.4;

  // Logo config
  final double logoSize = 150;
  final double logoTopOffset = 16;

  Future<void> _verifyEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite seu email')),
      );
      return;
    }
    final user = await UserDatabase.instance.getUserByEmail(email);
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email não encontrado')));
      return;
    }
    setState(() {
      _emailVerified = true;
    });
  }

  Future<void> _resetPassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final email = _emailController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha a nova senha e confirmação')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('As senhas não coincidem')));
      return;
    }

    final passwordHash = sha256.convert(utf8.encode(password)).toString();

    final updatedCount = await UserDatabase.instance.updatePassword(
      email,
      passwordHash,
    );

    if (updatedCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha atualizada com sucesso!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao atualizar senha')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Fundo escuro com opacidade
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(backgroundOpacity),
              ),
            ),

            // Ícone de voltar no topo esquerdo
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // Logo centralizado no topo com brilho
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: logoTopOffset),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.7),
                          blurRadius: 25,
                          spreadRadius: -15,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/elias_logo1.png',
                      width: logoSize,
                      height: logoSize,
                    ),
                  ),
                ),
              ),
            ),

            // Conteúdo scrollável
            Padding(
              padding: EdgeInsets.only(
                top: logoSize + logoTopOffset + 24,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_emailVerified,
                    ),
                    const SizedBox(height: 20),
                    if (!_emailVerified)
                      ElevatedButton(
                        onPressed: _verifyEmail,
                        child: const Text('Verificar Email'),
                      ),
                    if (_emailVerified) ...[
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Nova senha',
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Confirmar nova senha',
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _resetPassword,
                        child: const Text('Redefinir senha'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
