import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../models/parking_lot_model.dart';

class AdminRepository {
  final String _baseUrl = 'http://192.168.10.23:5005';

  Future<void> createParkingLot(ParkingLot parkingLot) async {
    final url = Uri.parse('$_baseUrl/parking_lot');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parkingLot.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create parking lot: ${response.body}');
    }
  }
}
