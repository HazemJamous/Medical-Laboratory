import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/my_bookings_cubit/cubit/my_bookings_cubit.dart';
import 'package:midical_laboratory/cubit/results_cubit/cubit/results_cubit.dart';
import 'package:midical_laboratory/features/pages/all_bookings/results_of_bookings_page.dart';
import 'package:midical_laboratory/shared/widgets/my_bookings_card.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyBookingsCubit()..getMyBookingsNavBar(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("مواعيدي القادمة"),
          backgroundColor: AppColors.accent,
        ),
        body: BlocBuilder<MyBookingsCubit, MyBookingsState>(
          builder: (context, state) {
            if (state is MyBookingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MyBookingsLoaded) {
              final now = DateTime.now();
              final upcoming = state.bookings
                  .where((b) => b.dateTime.isAfter(now))
                  .toList();

              if (upcoming.isEmpty) {
                return const Center(child: Text("لا يوجد مواعيد قادمة"));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: upcoming.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return MyBookingsCard(
                    booking: upcoming[index],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (_) =>
                                ResultsCubit()
                                  ..getResults(upcoming[index].appointmentId),
                            child: ResultsOfBookingsPage(
                              booking: upcoming[index],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is MyBookingsFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Center(child: Text("حدث خطأ غير متوقع"));
            }
          },
        ),
      ),
    );
  }
}
