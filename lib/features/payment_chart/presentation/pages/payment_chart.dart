import 'package:admin_taag/features/payment_chart/presentation/cubit/payment_chart_state.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/payment_chart_cubit.dart';

class PaymentChartScreen extends StatefulWidget {
  const PaymentChartScreen({super.key});

  @override
  State<PaymentChartScreen> createState() => _PaymentChartScreenState();
}

class _PaymentChartScreenState extends State<PaymentChartScreen> {
  @override
  initState() {
    super.initState();
    context.read<PaymentCubit>().fetchPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("بيانات الدفع"),
      ),
      body: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          final cubit = context.read<PaymentCubit>();
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cubit.paymentsList.isEmpty) {
            return const Center(child: Text("لا توجد بيانات حتى الآن"));
          }

          // معالجة البيانات لتجميع العمليات حسب اسم العيادة
          final Map<String, int> clinicData = {};
          for (var payment in cubit.paymentsList) {
            final pricee = payment['price'];
            clinicData[pricee] = (clinicData[pricee] ?? 0) + 1;
          }

          final chartData = clinicData.entries.toList();

          return SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ...cubit.paymentsList.map((e) {
                      return Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "customerName: ${e['customerName']}",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "price: ${e['price']}\$",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              e['clinicName'] != null
                                  ? Text(
                                      "clinicName: ${e['clinicName']}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Container(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "orderId: ${e['orderId']}",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "date: ${e['date']}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                )),
          );
        },
      ),
    );
  }
}
