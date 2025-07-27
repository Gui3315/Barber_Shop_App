import 'package:flutter/material.dart';
import 'background_container.dart';
import 'login_page.dart';
import 'gender_selection_page.dart';

// Modelo de agendamento
class Booking {
  final String date;
  final String hour;
  final List<String> services;
  final String status; // Confirmado, Cancelado, etc
  final String professional;

  Booking({
    required this.date,
    required this.hour,
    required this.services,
    required this.status,
    required this.professional,
  });
}

class WelcomePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final double backgroundOpacity;

  const WelcomePage({
    super.key,
    required this.userName,
    required this.userEmail,
    this.backgroundOpacity = 0.5,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Booking? nextBooking;
  List<Booking> bookingHistory = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // TODO: buscar próximo agendamento do usuário do banco
    nextBooking = Booking(
      date: '15/07/2025',
      hour: '15:30',
      services: ['Cabelo', 'Barba'],
      status: 'Confirmado',
      professional: 'Elias',
    );

    // TODO: buscar histórico do usuário
    bookingHistory = [
      Booking(
        date: '01/07/2025',
        hour: '10:00',
        services: ['Barba'],
        status: 'Cancelado',
        professional: 'Elias',
      ),
      Booking(
        date: '28/06/2025',
        hour: '14:00',
        services: ['Cabelo'],
        status: 'Confirmado',
        professional: 'Bruna',
      ),
    ];

    setState(() {});
  }

  void _remarcarBooking() {
    // TODO: implementar lógica de remarcação
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade de remarcar aqui')),
    );
  }

  void _goToProfile() {
    // TODO: abrir tela perfil/configurações
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Abrir perfil/configurações')));
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget _buildBookingCard(Booking booking, {bool isNext = false}) {
    return Card(
      color: isNext ? Colors.blue.shade100 : null,
      child: ListTile(
        title: Text(
          '${booking.date} - ${booking.hour}',
          style: TextStyle(
            color: isNext ? Colors.blue.shade900 : null,
            fontWeight: isNext ? FontWeight.bold : null,
          ),
        ),
        subtitle: Text(
          'Serviços: ${booking.services.join(', ')}\n'
          'Profissional: ${booking.professional}\n'
          'Status: ${booking.status}',
          style: TextStyle(color: isNext ? Colors.blue.shade800 : null),
        ),
        trailing: isNext
            ? IconButton(
                icon: const Icon(Icons.edit_calendar, color: Colors.orange),
                tooltip: 'Remarcar',
                onPressed: _remarcarBooking,
              )
            : null,
      ),
    );
  }

  TextStyle get _sectionTitleStyle => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(blurRadius: 4, color: Colors.black87, offset: Offset(1, 2)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Bem-vindo, ${widget.userName}!',
            style: const TextStyle(
              shadows: [
                Shadow(
                  blurRadius: 3,
                  color: Colors.black54,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Perfil e Configurações',
              onPressed: _goToProfile,
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            // Fundo preto com opacidade configurável
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(widget.backgroundOpacity),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Próximo agendamento centralizado
                  if (nextBooking != null) ...[
                    Center(
                      child: Text(
                        'Próximo agendamento',
                        style: _sectionTitleStyle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBookingCard(nextBooking!, isNext: true),
                    const SizedBox(height: 24),
                  ],

                  // Histórico (centralizado)
                  const Center(
                    child: Text(
                      'Histórico de agendamentos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black87,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  bookingHistory.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Nenhum agendamento realizado ainda.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : Column(
                          children: bookingHistory
                              .map((b) => _buildBookingCard(b))
                              .toList(),
                        ),

                  const SizedBox(height: 32),

                  // Botão de agendamento
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Novo Agendamento'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF4A300),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GenderSelectionPage(
                              userName: widget.userName,
                              userEmail: widget.userEmail,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
