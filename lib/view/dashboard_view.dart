import 'package:admin_taag/view/notification_view.dart';
import 'package:admin_taag/widgets/grid_view_builder_dashboard.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: GridViewBuilderWidget(),
        ),
      ),
    );
  }
}
