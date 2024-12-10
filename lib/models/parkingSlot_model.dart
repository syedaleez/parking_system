//newww
import 'dart:convert';

class ParkingSlot {
  final int id;
  final int parkingLotId;
  final int parkingLotRank;
  final int slotSizeId;
  final List<int> data;
  final String createdAt;
  final String updatedAt;
  final bool isReserved;
  final String plateNumber;

  ParkingSlot({
    required this.id,
    required this.parkingLotId,
    required this.parkingLotRank,
    required this.slotSizeId,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
    required this.isReserved,
    required this.plateNumber, // Add the new field here
  });

//newwwwww
  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    // Decode the 'data' field if it's a string representing a list
    List<int> parsedData = [];
    if (json['data'] != null && json['data'] is String) {
      try {
        parsedData = List<int>.from(jsonDecode(json['data']));
      } catch (e) {
        // If parsing fails, keep parsedData as an empty list
        parsedData = [];
      }
    }

    return ParkingSlot(
      id: json['id'] ?? 0,
      parkingLotId: json['parking_lot_id'] ?? 0,
      parkingLotRank: json['parking_lot_rank'] ?? 0,
      slotSizeId: json['slot_size_id'] ?? 0,
      data: parsedData, // The correctly parsed list of integers
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isReserved: json['is_reserved'] ?? false,
      plateNumber: json['plateNumber'] as String? ?? 'Unknown', //JSON
    );
  }

  // Copy with method for immutability
  ParkingSlot copyWith({bool? isReserved}) {
    return ParkingSlot(
      id: this.id,
      parkingLotId: this.parkingLotId,
      parkingLotRank: this.parkingLotRank,
      slotSizeId: this.slotSizeId,
      data: this.data,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      isReserved: isReserved ?? this.isReserved,
      plateNumber: plateNumber ??
          this.plateNumber, // If no value is passed, retain the current value
    );
  }
}
