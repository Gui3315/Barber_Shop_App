import 'package:flutter/material.dart';
import 'booking_storage.dart';
import 'login_page.dart';
import 'background_container.dart';

// Preços dos serviços
const Map<String, double> servicePrices = {
  'Cabelo': 30.0,
  'Bigode': 10.0,
  'Barba': 20.0,
  'Manicure': 40.0,
  'Pedicure': 40.0,
};

class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({super.key});

  @override
  State<OwnerHomePage> createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final bookings = await BookingStorage.loadBookings();
    setState(() {
      _bookings = bookings;
      _isLoading = false;
    });
  }

  double _calculateTotal(List<String> services) {
    double total = 0.0;
    for (var service in services) {
      total += servicePrices[service] ?? 0.0;
    }
    return total;
  }

  Widget _buildBookingTile(Booking booking) {
    final services = booking.services.join(', ');
    final totalPrice = _calculateTotal(booking.services);
    return ListTile(
      title: Text(booking.name),
      subtitle: Text(
        'Data: ${booking.date} - Hora: ${booking.hour}\n'
        'Serviços: $services\n'
        'Valor total: R\$ ${totalPrice.toStringAsFixed(2)}',
      ),
      isThreeLine: true,
      leading: const Icon(Icons.event_available, color: Colors.amber),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Painel do Dono'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadBookings,
              tooltip: 'Atualizar lista',
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Sair',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _bookings.isEmpty
            ? const Center(child: Text('Nenhum agendamento encontrado.'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _bookings.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) => _buildBookingTile(_bookings[index]),
              ),
      ),
    );
  }
}
