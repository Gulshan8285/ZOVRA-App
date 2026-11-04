import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/account/presentation/account_screen.dart';
import '../../features/account/presentation/edit_profile_screen.dart';
import '../../features/account/presentation/payment_history_screen.dart';
import '../../features/account/presentation/static_page_screen.dart';
import '../../features/addresses/presentation/add_edit_address_screen.dart';
import '../../features/addresses/presentation/address_list_screen.dart';
import '../../features/admin/presentation/admin_control_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/bookings/presentation/booking_detail_screen.dart';
import '../../features/bookings/presentation/bookings_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/checkout/presentation/payment_failure_screen.dart';
import '../../features/checkout/presentation/payment_screen.dart';
import '../../features/checkout/presentation/payment_success_screen.dart';
import '../../features/checkout/presentation/scheduling_address_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/offers/presentation/offers_screen.dart';
import '../../features/reviews/presentation/service_reviews_screen.dart';
import '../../features/reviews/presentation/write_review_sheet.dart';
import '../../features/services/presentation/category_services_screen.dart';
import '../../features/services/presentation/explore_screen.dart';
import '../../features/services/presentation/service_detail_screen.dart';
import '../../features/shell/presentation/main_shell_screen.dart';
import '../../features/support/presentation/create_ticket_screen.dart';
import '../../features/support/presentation/help_support_screen.dart';
import '../../features/support/presentation/my_tickets_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorExploreKey = GlobalKey<NavigatorState>(debugLabel: 'shellExplore');
final _shellNavigatorBookingsKey = GlobalKey<NavigatorState>(debugLabel: 'shellBookings');
final _shellNavigatorOffersKey = GlobalKey<NavigatorState>(debugLabel: 'shellOffers');
final _shellNavigatorAccountKey = GlobalKey<NavigatorState>(debugLabel: 'shellAccount');

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: authState.isAuthenticated ? '/' : '/welcome',
    redirect: (context, state) {
      final isAuth = authState.isAuthenticated;
      final isWelcome = state.matchedLocation == '/welcome';

      if (!isAuth && !isWelcome) {
        return '/welcome';
      }
      if (isAuth && isWelcome) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Stateful Shell Route for Bottom Navigation Bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Branch 1: Explore
          StatefulShellBranch(
            navigatorKey: _shellNavigatorExploreKey,
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),

          // Branch 2: Bookings
          StatefulShellBranch(
            navigatorKey: _shellNavigatorBookingsKey,
            routes: [
              GoRoute(
                path: '/bookings',
                builder: (context, state) => const BookingsScreen(),
              ),
            ],
          ),

          // Branch 3: Offers
          StatefulShellBranch(
            navigatorKey: _shellNavigatorOffersKey,
            routes: [
              GoRoute(
                path: '/offers',
                builder: (context, state) => const OffersScreen(),
              ),
            ],
          ),

          // Branch 4: Account
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAccountKey,
            routes: [
              GoRoute(
                path: '/account',
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),

      // Standalone Detail and Modal Screens
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/category/:id',
        builder: (context, state) =>
            CategoryServicesScreen(categoryId: state.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/:id',
        builder: (context, state) =>
            ServiceDetailScreen(serviceId: state.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/checkout',
        builder: (context, state) => const SchedulingAddressScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/checkout/payment',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return PaymentScreen(schedulingData: data);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/checkout/success/:bookingId',
        builder: (context, state) =>
            PaymentSuccessScreen(bookingId: state.pathParameters['bookingId']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/checkout/failure',
        builder: (context, state) => const PaymentFailureScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/booking/:id',
        builder: (context, state) =>
            BookingDetailScreen(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/addresses',
        builder: (context, state) => const AddressListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/addresses/add',
        builder: (context, state) => const AddEditAddressScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/addresses/edit/:id',
        builder: (context, state) =>
            AddEditAddressScreen(addressId: state.pathParameters['id']),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/reviews/:serviceId',
        builder: (context, state) =>
            ServiceReviewsScreen(serviceId: state.pathParameters['serviceId']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/write-review/:bookingId',
        builder: (context, state) =>
            WriteReviewScreen(bookingId: state.pathParameters['bookingId']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/account/payments',
        builder: (context, state) => const PaymentHistoryScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/support',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/support/create',
        builder: (context, state) => const CreateTicketScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/support/tickets',
        builder: (context, state) => const MyTicketsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/legal/:slug',
        builder: (context, state) =>
            StaticPageScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/admin',
        builder: (context, state) => const AdminControlScreen(),
      ),
    ],
  );
});
