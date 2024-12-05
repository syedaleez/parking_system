// class ParkingSlot {
//   final int id;
//   final int parkingLotId;
//   final int parkingLotRank;
//   final int slotSizeId;
//   final List<int> data; // List of slot numbers
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   bool isReserved; // For marking whether the slot is reserved or not

//   ParkingSlot({
//     required this.id,
//     required this.parkingLotId,
//     required this.parkingLotRank,
//     required this.slotSizeId,
//     required this.data,
//     required this.createdAt,
//     required this.updatedAt,
//     this.isReserved = false, // Default to not reserved
//   });

//   factory ParkingSlot.fromJson(Map<String, dynamic> json) {
//     return ParkingSlot(
//       id: json['id'],
//       parkingLotId: json['parking_lot_id'],
//       parkingLotRank: json['parking_lot_rank'],
//       slotSizeId: json['slot_size_id'],
//       data: List<int>.from(json['data']),
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//     );
//   }
// }



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
  final bool isReserved;  // New field to track reservation status

  ParkingSlot({
    required this.id,
    required this.parkingLotId,
    required this.parkingLotRank,
    required this.slotSizeId,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
    required this.isReserved, // Add the new field here
  });

  // factory ParkingSlot.fromJson(Map<String, dynamic> json) {
  //   return ParkingSlot(
  //     id: json['id'] ?? 0,
  //     parkingLotId: json['parking_lot_id'] ?? 0,
  //     parkingLotRank: json['parking_lot_rank'] ?? 0,
  //     slotSizeId: json['slot_size_id'] ?? 0,
  //     data: json['data'] != null
  //         ? List<int>.from(json['data'].map((x) => x ?? 0))
  //         : [],
  //     createdAt: json['created_at'] ?? '',
  //     updatedAt: json['updated_at'] ?? '',
  //     isReserved: json['is_reserved'] ?? false,  // Assuming you have 'is_reserved' in the JSON
  //   );
  // }



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
    data: parsedData,  // The correctly parsed list of integers
    createdAt: json['created_at'] ?? '',
    updatedAt: json['updated_at'] ?? '',
    isReserved: json['is_reserved'] ?? false,  // Assuming 'is_reserved' is part of the JSON
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
      isReserved: isReserved ?? this.isReserved,  // If no value is passed, retain the current value
    );
  }
}

