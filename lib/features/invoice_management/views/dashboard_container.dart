import 'package:flutter/material.dart';
import 'package:invoice_management/core/menu_app_controller.dart';
import 'package:invoice_management/core/responsive.dart';
import 'package:invoice_management/features/invoice_management/views/components/side_menu.dart';
import 'package:provider/provider.dart';

class DashboardContainer extends StatelessWidget {
  final Widget child;
  const DashboardContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                // default 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              //  5/6
              flex: 5,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
