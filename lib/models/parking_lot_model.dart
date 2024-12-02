class ParkingLot {
  final String name;
  final int rank;
  final Map<String, int> nSlotsKey;

  ParkingLot({required this.name, required this.rank, required this.nSlotsKey});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rank': rank,
      'nSlotsKey': nSlotsKey,
    };
  }
}
