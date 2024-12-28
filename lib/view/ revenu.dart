import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RevenueChartScreen extends StatelessWidget {
  const RevenueChartScreen({super.key});

  Future<Map<String, dynamic>> fetchRevenueData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('payments').get();
      final List<Map<String, dynamic>> payments =
          snapshot.docs.map((doc) => doc.data()).toList();

      double totalRevenue = 0;
      final Map<String, double> dailyRevenue = {};
      final Map<String, double> monthlyRevenue = {};

      for (var payment in payments) {
        final date = DateTime.parse(
            payment['date']); // Assuming 'date' is in ISO8601 format
        final amount = double.tryParse(payment['price'].toString()) ?? 0.0;

        totalRevenue += amount;

        // Daily revenue calculation
        final day = "${date.year}-${date.month}-${date.day}";
        dailyRevenue[day] = (dailyRevenue[day] ?? 0) + amount;

        // Monthly revenue calculation
        final month = "${date.year}-${date.month}";
        monthlyRevenue[month] = (monthlyRevenue[month] ?? 0) + amount;
      }

      return {
        'total': totalRevenue,
        'daily': dailyRevenue,
        'monthly': monthlyRevenue,
      };
    } catch (e) {
      throw Exception("Error fetching revenue data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إحصائيات الأرباح"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchRevenueData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("لا توجد بيانات لعرضها"));
          }

          final data = snapshot.data!;
          final dailyRevenue = data['daily'] as Map<String, double>;
          final monthlyRevenue = data['monthly'] as Map<String, double>;
          final totalRevenue = data['total'] as double;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("إجمالي الأرباح: \$${totalRevenue.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text("الأرباح اليومية",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      barGroups: dailyRevenue.entries
                          .map(
                            (entry) => BarChartGroupData(
                              x: int.parse(entry.key.split('-').last),
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("الأرباح الشهرية",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      barGroups: monthlyRevenue.entries
                          .map(
                            (entry) => BarChartGroupData(
                              x: int.parse(entry.key.split('-').last),
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
