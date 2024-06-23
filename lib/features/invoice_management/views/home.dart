import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:developer' as devtools show log;

import 'package:invoice_management/core/constants.dart';
import 'package:invoice_management/core/responsive.dart';
import 'package:invoice_management/features/invoice_management/views/components/header.dart';
import 'package:invoice_management/features/invoice_management/views/components/invoice_listing.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const Header(),
              const SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: defaultPadding * 1.5,
                                  vertical: defaultPadding /
                                      (Responsive.isMobile(context) ? 2 : 1),
                                ),
                              ),
                              onPressed: () {
                                devtools.log('change route to single invoice');
                                // context.goNamed('new-invoice');
                                context.go('/new-invoice');
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Create Invoice"),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        const SizedBox(height: defaultPadding),
                        const InvoiceListing(),
                        if (Responsive.isMobile(context))
                          const SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    const SizedBox(width: defaultPadding),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
