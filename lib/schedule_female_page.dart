import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'booking_storage.dart';
import 'background_container.dart';

class ScheduleFemalePage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const ScheduleFemalePage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<ScheduleFemalePage> createState() => _ScheduleFemalePageState();
}

class _ScheduleFemalePageState extends State<ScheduleFemalePage> {
  final Map<String, double> _prices = {
    'Cabelo': 60.0,
    'Manicure': 50.0,
    'Pedicure': 50.0,
  };

  final Map<String, bool> _services = {
    'Cabelo': false,
    'Manicure': false,
    'Pedicure': false,
  };

  // Configurações de fonte e cor
  late double titleFontSize;
  late double serviceFontSize;
  late double totalFontSize;

  late Color titleColor;
  late Color serviceColor;
  late Color totalColor;

  // Configurações do logo
  late double logoSize;
  late double logoTopOffset;

  DateTime? _selectedDate;
  String? _selectedHour;
  List<String> _unavailableSlots = [];

  @override
  void initState() {
    super.initState();

    // Configurações de tamanho e cor
    titleFontSize = 30;
    serviceFontSize = 20;
    totalFontSize = 20;

    titleColor = Colors.white;
    serviceColor = Colors.white;
    totalColor = Colors.white;

    // Configurações do logo
    logoSize = 150;
    logoTopOffset = 16;
  }

  double get _totalPrice {
    return _services.entries
        .where((e) => e.value)
        .map((e) => _prices[e.key]!)
        .fold(0.0, (a, b) => a + b);
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    DateTime initialDate = now;

    while (!(initialDate.weekday >= 2 && initialDate.weekday <= 6)) {
      initialDate = initialDate.add(const Duration(days: 1));
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      selectableDayPredicate: (date) => date.weekday >= 2 && date.weekday <= 6,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedHour = null;
      });
      await _loadUnavailableSlots();
    }
  }

  Future<void> _loadUnavailableSlots() async {
    if (_selectedDate == null) return;

    final bookings = await BookingStorage.getBookingsByDate(
      DateFormat('dd/MM/yyyy').format(_selectedDate!),
    );

    setState(() {
      _unavailableSlots = bookings.map((b) => b.hour).toList();
    });
  }

  List<String> _generateTimeSlots() {
    final slots = <String>[];
    final increment = _services.values.where((v) => v).length > 1 ? 60 : 30;

    final now = TimeOfDay.now();
    final isToday =
        _selectedDate != null &&
        DateFormat('dd/MM/yyyy').format(_selectedDate!) ==
            DateFormat('dd/MM/yyyy').format(DateTime.now());

    for (int hour = 10; hour <= 21; hour++) {
      for (int minute = 0; minute < 60; minute += increment) {
        if (hour == 21 && minute > 30) continue;

        final time = TimeOfDay(hour: hour, minute: minute);
        if (isToday) {
          if (time.hour < now.hour ||
              (time.hour == now.hour && time.minute <= now.minute)) {
            continue;
          }
        }

        final formatted = time.format(context);
        slots.add(formatted);
      }
    }

    return slots.where((slot) => !_unavailableSlots.contains(slot)).toList();
  }

  Future<void> _confirmPreBooking() async {
    final selectedServices = _services.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    if (selectedServices.isEmpty ||
        _selectedDate == null ||
        _selectedHour == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione serviço(s), data e horário.')),
      );
      return;
    }

    final totalPrice = selectedServices
        .map((s) => _prices[s]!)
        .fold(0.0, (a, b) => a + b);

    final booking = Booking(
      name: widget.userName,
      date: DateFormat('dd/MM/yyyy').format(_selectedDate!),
      hour: _selectedHour!,
      services: selectedServices,
      gender: 'feminino',
      email: widget.userEmail,
    );

    await BookingStorage.saveBooking(booking);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agendamento Confirmado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Data: ${booking.date}\nHorário: ${booking.hour}\nServiços: ${selectedServices.join(', ')}\nTotal: R\$ ${totalPrice.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 16),
            Container(
              height: 150,
              width: 150,
              color: Colors.grey[300],
              child: const Center(child: Text('QR Code (simulado)')),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );

    setState(() {
      _services.updateAll((key, value) => false);
      _selectedDate = null;
      _selectedHour = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
        : '';

    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Fundo escuro ocupando toda a tela
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),

            // Logo centralizado no topo, por cima do fundo com brilho (sombra)
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

            // Ícone de voltar no topo esquerdo, por cima do fundo
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // Conteúdo scrollável
            Padding(
              padding: EdgeInsets.only(
                top: logoSize + logoTopOffset + 16,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: ListView(
                children: [
                  Text(
                    'Escolha os serviços:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ..._services.keys.map(
                    (s) => CheckboxListTile(
                      title: Text(
                        '$s - R\$ ${_prices[s]!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: serviceFontSize,
                          color: serviceColor,
                        ),
                      ),
                      value: _services[s],
                      onChanged: (v) =>
                          setState(() => _services[s] = v ?? false),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _selectDate,
                    child: Text(
                      _selectedDate == null
                          ? 'Selecionar Data'
                          : 'Data: $formattedDate',
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_selectedDate != null) ...[
                    const Text('Horários disponíveis:'),
                    Wrap(
                      spacing: 8,
                      children: _generateTimeSlots().map((slot) {
                        return ChoiceChip(
                          label: Text(slot),
                          selected: _selectedHour == slot,
                          onSelected: (_) =>
                              setState(() => _selectedHour = slot),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'Total: R\$ ${_totalPrice.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: totalFontSize,
                      color: totalColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _confirmPreBooking,
                    child: const Text('Confirmar Pré-agendamento'),
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
