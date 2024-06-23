import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_management/core/constants.dart';
import 'package:invoice_management/core/responsive.dart';
import 'package:invoice_management/core/utils.dart';
import 'package:invoice_management/features/invoice_management/bloc/invoice_bloc.dart';
import 'package:invoice_management/features/invoice_management/models/extended_invoice_model.dart';
import 'package:invoice_management/features/invoice_management/models/invoice_item_model.dart';

import 'dart:developer' as devtools show log;


import 'package:printing/printing.dart';

class Invoice extends StatefulWidget {
  final invoiceId;

  const Invoice({
    super.key,
    required this.invoiceId,
  });

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<InvoiceBloc, InvoiceState>(builder: (context, state) {
        if (state.status == InvoiceStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == InvoiceStatus.error ||
            state.selectedInvoice == null) {
          return const Center(child: Text('No invoice found matching this ID'));
        } else if (state.status == InvoiceStatus.exporting) {
          return PdfPreview(
            build: (context) => state.exportedInvoice!,
          );
        } else if (state.status == InvoiceStatus.success) {
          ExtendedInvoiceModel invoice = state.selectedInvoice!;

          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Invoice No: ${invoice.id}",
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 16 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                        devtools.log('Export as PDF');
                        context
                            .read<InvoiceBloc>()
                            .add(GenerateInvoice(invoice));
                      },
                      icon: const Icon(Icons.share_outlined),
                      label: const Text("Export as PDF"),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: defaultPadding),
                    Text(
                      "Customer: ${invoice.customer.name}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: defaultPadding),
                    Text(
                      "Address: ${invoice.customer.address}, ${invoice.customer.city}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: defaultPadding),
                    Text(
                      "Email: ${invoice.customer.email}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: defaultPadding),
                    Text(
                      "Date: ${Utils.formatDate(invoice.dateCreated)}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: defaultPadding),
                SizedBox(
                  width: double.infinity,
                  child: PaginatedDataTable(
                    showCheckboxColumn: false,
                    rowsPerPage: invoice.invoiceItems.length > 10
                        ? 10
                        : invoice.invoiceItems.length,
                    columnSpacing: defaultPadding,
                    headingRowColor:
                        WidgetStateProperty.resolveWith((states) => bgColor),
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          "Description",
                          style: tableHeader,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Quantity",
                          style: tableHeader,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Price",
                          style: tableHeader,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Total",
                          style: tableHeader,
                        ),
                      ),
                    ],
                    source: InvoiceItemsSource(invoice.invoiceItems),
                  ),
                ),
                const SizedBox(height: defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: defaultPadding),
                        Text(
                          "Sub total: (KES): ${invoice.totalBeforeTax.toString()}",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: defaultPadding),
                        Text(
                          "${invoice.percentageTax} % tax: (KES): ${(invoice.totalBeforeTax * (invoice.percentageTax / 100)).toString()}",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: defaultPadding),
                        Text("Total: (KES): ${invoice.total.toString()}",
                            style: TextStyle(
                              fontSize: Responsive.isMobile(context) ? 16 : 24,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        }

        return const Center(child: Text('No invoices found.'));
      }),
    );
  }
}

class InvoiceItemsSource extends DataTableSource {
  final List<InvoiceItemModel> _invoiceItems;

  InvoiceItemsSource(this._invoiceItems);

  @override
  DataRow? getRow(int index) {
    if (index >= _invoiceItems.length) return null;
    final item = _invoiceItems[index];
    return DataRow(
      cells: [
        DataCell(Text(item.description)),
        DataCell(Text(item.quantity.toString())),
        DataCell(Text(item.price.toString())),
        DataCell(Text((item.price * item.quantity).toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _invoiceItems.length;

  @override
  int get selectedRowCount => 0;
}
