import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_management/core/constants.dart';
import 'package:invoice_management/core/utils.dart';
import 'package:invoice_management/features/invoice_management/bloc/invoice_bloc.dart';
import 'package:invoice_management/features/invoice_management/models/extended_invoice_model.dart';

class InvoiceListing extends StatefulWidget {
  const InvoiceListing({
    super.key,
  });

  @override
  State<InvoiceListing> createState() => _InvoiceListingState();
}

class _InvoiceListingState extends State<InvoiceListing> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(builder: (context, state) {
      if (state.status == InvoiceStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.status == InvoiceStatus.error) {
        return Center(child: Text('Error: ${state.message}'));
      } else if (state.status == InvoiceStatus.success) {
        return Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your recent Invoices",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: double.infinity,
                  child: PaginatedDataTable(
                    showCheckboxColumn: false,
                    rowsPerPage: Utils.rowCountPerPage(state.invoices),
                    headingRowColor:
                        WidgetStateProperty.resolveWith((states) => bgColor),
                    columnSpacing: defaultPadding,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          "Client Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Invoice Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Total",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                    source: InvoiceTableData(state.invoices, context),
                  )),
            ],
          ),
        );
      }

      return const Center(child: Text('No invoices found.'));
    });
  }
}

class InvoiceTableData extends DataTableSource {
  final List<ExtendedInvoiceModel> _invoices;
  final BuildContext _context;

  InvoiceTableData(this._invoices, this._context);

  @override
  DataRow? getRow(int index) {
    if (index >= _invoices.length) return null;
    final invoice = _invoices[index];
    return DataRow(
      cells: [
        DataCell(Text(invoice.customer.name)),
        DataCell(Text(Utils.formatDate(invoice.dateCreated))),
        DataCell(Text(invoice.total.toString())),
      ],
      onSelectChanged: (bool? selected) {
        if (selected != null && selected) {
          _context.read<InvoiceBloc>().add(FetchInvoice(invoice.id));

          _context.go('/invoice/${invoice.id}');
        }
      },
    );
  }

  @override
  int get rowCount => _invoices.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
