import 'dart:developer';

import 'package:admin_taag/view/annuncement_view.dart';
import 'package:admin_taag/view/customer_view.dart';
import 'package:admin_taag/view/notification_view.dart';
import 'package:flutter/material.dart';

import '../features/create_clinics/presentation/pages/add_doctor_to_clinics.dart';
import '../features/create_clinics/presentation/pages/create_clinics.dart';

class GridViewBuilderWidget extends StatelessWidget {
  const GridViewBuilderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Number of columns
        crossAxisSpacing: 20.0, // Spacing between columns
        mainAxisSpacing: 20.0, // Spacing between rows
        childAspectRatio: 1.0, // Aspect ratio of each item
      ),
      itemCount: cardsDashboard.length, // Number of items
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (index == 0) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const NotificationView();
                  },
                ),
              );
            }
            if (index == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const UsersDashboard();
                  },
                ),
              );
            }
            if (index == 4) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const AnnuncementView();
                  },
                ),
              );
            }
            if (index == 5) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return CreateClinics();
                  },
                ),
              );
            }
            if (index == 6) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const AddDoctorToClinics();
                  },
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange[300],
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Center(
              child: Text(
                cardsDashboard[index],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

List<String> cardsDashboard = [
  "notification",
  "Custemer",
  "Orders",
  "Revenu",
  "Annuncement",
  'clinics',
  'Doctors',
];
