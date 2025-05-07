import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/booking.dart';
import 'dart:convert';

class BookingService {
  final _storage = const FlutterSecureStorage();
  
  const BookingService();

  Future<Booking> bookTrip(String destination, DateTime date) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock booking data
    final booking = Booking(
      flight: 'Flight to $destination',
      hotel: 'Hotel in $destination',
      cab: 'Airport transfer',
      totalCost: 15000.0,
    );

    // Save booking to secure storage
    await _storage.write(
      key: 'latest_booking',
      value: jsonEncode(booking.toJson()),
    );

    return booking;
  }

  Future<Booking?> getLatestBooking() async {
    final bookingJson = await _storage.read(key: 'latest_booking');
    if (bookingJson == null) return null;
    
    return Booking.fromJson(jsonDecode(bookingJson));
  }
} 