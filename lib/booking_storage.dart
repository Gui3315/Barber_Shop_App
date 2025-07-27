import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class Booking {
  final String name;
  final String date; // formato: 'dd/MM/yyyy'
  final String hour; // formato: 'HH:mm'
  final List<String> services;
  final String gender;
  final String email;

  Booking({
    required this.name, // <-- ADICIONADO
    required this.date,
    required this.hour,
    required this.services,
    required this.gender,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'name': name, // <-- ADICIONADO
    'date': date,
    'hour': hour,
    'services': services,
    'gender': gender,
    'email': email,
  };

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      name: json['name'] ?? '', // <-- ADICIONADO
      date: json['date'],
      hour: json['hour'],
      services: List<String>.from(json['services']),
      gender: json['gender'],
      email: json['email'],
    );
  }
}

class BookingStorage {
  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/bookings.json');
  }

  static Future<List<Booking>> loadBookings() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        await file.writeAsString(jsonEncode([]));
        return [];
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => Booking.fromJson(json)).toList();
    } catch (e, stacktrace) {
      debugPrint('Erro ao carregar agendamentos: $e');
      debugPrintStack(stackTrace: stacktrace);
      return [];
    }
  }

  static Future<void> saveBooking(Booking booking) async {
    try {
      final bookings = await loadBookings();
      bookings.add(booking);
      final file = await _getFile();
      final jsonList = bookings.map((b) => b.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e, stacktrace) {
      debugPrint('Erro ao salvar agendamento: $e');
      debugPrintStack(stackTrace: stacktrace);
    }
  }

  static Future<List<Booking>> getBookingsByDate(String date) async {
    final all = await loadBookings();
    return all.where((b) => b.date == date).toList();
  }
}
