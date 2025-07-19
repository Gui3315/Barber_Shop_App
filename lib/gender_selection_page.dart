import 'package:flutter/material.dart';
import 'schedule_male_page.dart';
import 'schedule_female_page.dart';
import 'background_container.dart';

class GenderSelectionPage extends StatelessWidget {
  final String userName;
  final String userEmail;

  final double eliasTop;
  final double eliasLeft;
  final double brunaTop;
  final double brunaLeft;

  final double backgroundOpacity;

  const GenderSelectionPage({
    super.key,
    required this.userName,
    required this.userEmail,
    this.eliasTop = 150,
    this.eliasLeft = 100,
    this.brunaTop = 300,
    this.brunaLeft = 100,
    this.backgroundOpacity = 0.4,
  });

  final TextStyle eliasStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
    fontFamily: 'Roboto',
  );

  final TextStyle brunaStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.purple,
    fontFamily: 'Roboto',
  );

  final TextStyle eliasDescStyle = const TextStyle(
    fontSize: 14,
    color: Colors.black87,
    fontFamily: 'OpenSans',
  );

  final TextStyle brunaDescStyle = const TextStyle(
    fontSize: 14,
    color: Colors.black87,
    fontFamily: 'OpenSans',
  );

  Widget _buildTextBlock({
    required String name,
    required String description,
    required TextStyle nameStyle,
    required TextStyle descStyle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: nameStyle),
          const SizedBox(height: 4),
          Text(description, style: descStyle),
        ],
      ),
    );
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

            // Botão voltar no topo esquerdo - faz logout e vai para login page
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  tooltip: 'Voltar',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

            // Título estilizado dentro da tela
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Text(
                'Escolha o(a) profissional de sua preferência',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black45,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
              ),
            ),

            // Avatar Elias com clique
            Positioned(
              top: eliasTop - 10,
              left: eliasLeft - 90,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScheduleMalePage(
                        userName: userName,
                        userEmail: userEmail,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/elias.png',
                    width: 130,
                    height: 165,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Texto Elias (sem clique)
            Positioned(
              top: 205,
              left: 139,
              right: 16,
              child: _buildTextBlock(
                name: 'Elias',
                description: 'Especialista em atendimento masculino.',
                nameStyle: eliasStyle,
                descStyle: eliasDescStyle,
              ),
            ),

            // Avatar Bruna com clique
            Positioned(
              top: brunaTop - -100,
              left: brunaLeft - 90,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScheduleFemalePage(
                        userName: userName,
                        userEmail: userEmail,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/bruna.png',
                    width: 130,
                    height: 165,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Texto Bruna (sem clique)
            Positioned(
              top: 465,
              left: 145,
              right: 16,
              child: _buildTextBlock(
                name: 'Bruna',
                description: 'Especialista em atendimento feminino.',
                nameStyle: brunaStyle,
                descStyle: brunaDescStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
