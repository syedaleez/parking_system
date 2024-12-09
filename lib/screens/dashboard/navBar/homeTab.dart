// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../cubit/parking_cubit.dart';
// // import '../../cubit/parking_cubit.dart';
// import '../../../models/parkingSlot_model.dart';
// import 'parking_form_state.dart';
// // import '../../models/parkingSlot_model.dart';
// // import '../cubit/parking_cubit.dart';

// class HomeTab extends StatelessWidget {
//   const HomeTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Home')),
//       body: BlocConsumer<ParkingCubit, ParkingState>(
//         listener: (context, state) {
//           if (state is ParkingError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.errorMessage)),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is ParkingError) {
//             print('@@@@@@@@@@@@@${state.errorMessage}');
//           }
//           if (state is ParkingLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is ParkingLoaded) {
//             List<ParkingSlot> bikeSlots =
//                 state.parkingSlots.where((s) => s.slotSizeId == 1).toList();
//             List<ParkingSlot> carSlots =
//                 state.parkingSlots.where((s) => s.slotSizeId == 2).toList();
//             List<ParkingSlot> truckSlots =
//                 state.parkingSlots.where((s) => s.slotSizeId == 3).toList();

//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SectionHeader(title: 'Bike Slots'),
//                   ParkingSlotList(slots: bikeSlots),
//                   SectionHeader(title: 'Car Slots'),
//                   ParkingSlotList(slots: carSlots),
//                   SectionHeader(title: 'Truck Slots'),
//                   ParkingSlotList(slots: truckSlots),
//                 ],
//               ),
//             );
//           } else {
//             return Center(child: Text('No parking slots available.'));
//           }
//         },
//       ),
//     );
//   }
// }

// class SectionHeader extends StatelessWidget {
//   final String title;
//   const SectionHeader({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       child: Text(title,
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//     );
//   }
// }

// class ParkingSlotList extends StatelessWidget {
//   final List<ParkingSlot> slots;

//   ParkingSlotList({required this.slots});

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3, // Change based on your UI requirements
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//       ),
//       itemCount: slots.length,
//       itemBuilder: (context, index) {
//         final slot = slots[index];
//         return GestureDetector(
//           onTap: () => _showSlotDetails(context, slot),
//           child: Container(
//             color: slot.isReserved ? Colors.green : Colors.red,
//             child: Center(
//               child: Text('Slot ${slot.data.join(', ')}',
//                   style: TextStyle(color: Colors.white)),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showSlotDetails(BuildContext context, ParkingSlot slot) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Enter Vehicle Details'),
//           content: ParkingForm(
//             slotId: slot.id,
//             vehicleSizeId:
//                 slot.slotSizeId, // Assuming slotSizeId is the vehicleSizeId
//           ),
//         );
//       },
//     );
//   }
// }

//new for parking slotttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/parking_cubit.dart';
import '../../../models/parkingSlot_model.dart';
import 'parking_form_state.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ParkingCubit>().fetchAndMonitorSlots();
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: BlocConsumer<ParkingCubit, ParkingState>(
        listener: (context, state) {
          if (state is ParkingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          } else if (state is ParkingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ParkingLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ParkingLoaded) {
            List<ParkingSlot> bikeSlots =
                state.parkingSlots.where((s) => s.slotSizeId == 1).toList();
            List<ParkingSlot> carSlots =
                state.parkingSlots.where((s) => s.slotSizeId == 2).toList();
            List<ParkingSlot> truckSlots =
                state.parkingSlots.where((s) => s.slotSizeId == 3).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: 'Bike Slots'),
                  ParkingSlotList(slots: bikeSlots),
                  SectionHeader(title: 'Car Slots'),
                  ParkingSlotList(slots: carSlots),
                  SectionHeader(title: 'Truck Slots'),
                  ParkingSlotList(slots: truckSlots),
                ],
              ),
            );
          } else {
            return Center(child: Text('No parking slots available.'));
          }
        },
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}

class ParkingSlotList extends StatelessWidget {
  final List<ParkingSlot> slots;

  const ParkingSlotList({required this.slots, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Change based on your UI requirements
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        return GestureDetector(
          onTap: () {
            if (!slot.isReserved) {
              _showSlotDetails(context, slot);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Slot is already booked.')),
              );
            }
          },
          child: Container(
            color: slot.isReserved ? Colors.green : Colors.red,
            child: Center(
              child: Text('Slot ${slot.data.join(', ')}',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }

  void _showSlotDetails(BuildContext context, ParkingSlot slot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Vehicle Details'),
          content: ParkingForm(
            slotId: slot.id,
            vehicleSizeId:
                slot.slotSizeId, // Assuming slotSizeId is the vehicleSizeId
          ),
        );
      },
    );
  }
}
