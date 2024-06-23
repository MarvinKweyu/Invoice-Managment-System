import 'package:go_router/go_router.dart';
import 'package:invoice_management/features/invoice_management/views/dashboard_container.dart';
import 'package:invoice_management/features/invoice_management/views/home.dart';
import 'package:invoice_management/features/invoice_management/views/invoice_info.dart';
import 'package:invoice_management/features/invoice_management/views/new_invoice.dart';


final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        return DashboardContainer(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
            name: 'home',
            path: '/',
            builder: (context, state) => const Home(),
            routes: <RouteBase>[
              GoRoute(
                name: 'new-invoice',
                path: 'new-invoice',
                builder: (context, state) => const NewInvoice(),
              ),
              GoRoute(
                name: 'invoice',
                path: 'invoice/:invoiceId',
                builder: (context, state) =>
                    Invoice(invoiceId: state.pathParameters['invoiceId']),
              ),
            ])
      ],
    ),
  ],
  // ToDo: change this
  errorBuilder: (context, state) => const Home(),
);
