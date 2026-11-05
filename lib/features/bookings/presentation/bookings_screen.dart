import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../providers/bookings_provider.dart';
import 'widgets/booking_card.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsState = ref.watch(bookingsProvider);
    final upcoming = bookingsState.upcomingBookings;
    final completed = bookingsState.completedBookings;
    final cancelled = bookingsState.cancelledBookings;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: context.canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                  onPressed: () => context.pop(),
                )
              : null,
          title: Text(
            'My Bookings',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: 'Upcoming (${upcoming.length})'),
              Tab(text: 'Completed (${completed.length})'),
              Tab(text: 'Cancelled (${cancelled.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Upcoming Bookings
            upcoming.isEmpty
                ? EmptyView(
                    icon: Icons.calendar_today_outlined,
                    title: 'No Upcoming Appointments',
                    subtitle: 'Schedule a relaxing massage, facial or cleaning today.',
                    actionText: 'Book a Service',
                    onAction: () => context.go('/explore'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
                    itemCount: upcoming.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return BookingCard(booking: upcoming[index]);
                    },
                  ),

            // Tab 2: Completed Bookings
            completed.isEmpty
                ? EmptyView(
                    icon: Icons.task_alt_rounded,
                    title: 'No Completed Bookings',
                    subtitle: 'Your completed service history will appear here.',
                    actionText: 'Explore Services',
                    onAction: () => context.go('/explore'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
                    itemCount: completed.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return BookingCard(booking: completed[index]);
                    },
                  ),

            // Tab 3: Cancelled Bookings
            cancelled.isEmpty
                ? const EmptyView(
                    icon: Icons.event_busy_rounded,
                    title: 'No Cancelled Bookings',
                    subtitle: 'You have not cancelled any bookings.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
                    itemCount: cancelled.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return BookingCard(booking: cancelled[index]);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

