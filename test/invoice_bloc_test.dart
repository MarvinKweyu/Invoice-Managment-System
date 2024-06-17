import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_management/bloc/invoice_bloc.dart';
import 'package:invoice_management/models/customer_model.dart';
import 'package:invoice_management/models/extended_invoice_model.dart';
import 'package:invoice_management/models/invoice_item_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class MockInvoiceEvent extends Mock implements InvoiceEvent {}

class MockInvoiceState extends Mock implements InvoiceState {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockInvoiceEvent());
    registerFallbackValue(MockInvoiceState());
    setupHydratedBlocOverrides();
  });

  tearDown(() {
    HydratedBloc.storage.clear();
  });

  group('InvoiceBloc', () {
    test('initial state is InvoiceState', () {
      final bloc = InvoiceBloc();
      expect(bloc.state, const InvoiceState());
    });

    test('emits correct states on InvoiceStarted event', () {
      final bloc = InvoiceBloc();
      final invoices = [
        ExtendedInvoiceModel(
          id: '1',
          dateCreated: DateTime.now(),
          percentageTax: 0.0,
          totalBeforeTax: 100.0,
          total: 100.0,
          customer: CustomerModel(
            name: 'John Doe',
            address: '123 Lavington',
            city: 'Nairobi',
            email: 'john@example.com',
          ),
          invoiceItems: [
            InvoiceItemModel(
              description: 'Item 1',
              quantity: 1,
              price: 100.0,
              invoiceId: '1',
            ),
          ],
        ),
      ];

      // on app load, the bloc should emit the initial state
      bloc.emit(InvoiceState(
        status: InvoiceStatus.initial,
        invoices: invoices,
      ));
      expectLater(
        bloc.stream,
        emitsInOrder([
          InvoiceState(
            status: InvoiceStatus.success,
            invoices: invoices,
            message: '',
            selectedInvoice: null,
            exportedInvoice: null,
          ),
        ]),
      );

      bloc.add(InvoiceStarted());
    });

    test('emits correct states on CreateInvoice event', () {
      final bloc = InvoiceBloc();
      final invoice = ExtendedInvoiceModel(
        id: '1',
        dateCreated: DateTime.now(),
        percentageTax: 0.0,
        totalBeforeTax: 100.0,
        total: 100.0,
        customer: CustomerModel(
          name: 'John Doe',
          address: '123 Lavington',
          city: 'Nairobi',
          email: 'john@example.com',
        ),
        invoiceItems: [
          InvoiceItemModel(
              description: 'Item 1', quantity: 1, price: 100.0, invoiceId: '1'),
        ],
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          const InvoiceState(status: InvoiceStatus.loading),
          InvoiceState(
            status: InvoiceStatus.success,
            invoices: [invoice],
            message: '',
            selectedInvoice: null,
            exportedInvoice: null,
          ),
        ]),
      );

      bloc.add(CreateInvoice(invoice));
    });

    test('emits correct states on FetchInvoice', () {
      final bloc = InvoiceBloc();
      final invoice = ExtendedInvoiceModel(
        id: '1',
        dateCreated: DateTime.now(),
        percentageTax: 0.0,
        totalBeforeTax: 100.0,
        total: 100.0,
        customer: CustomerModel(
            name: 'John Doe',
            address: '123 Lavington',
            city: 'Nairobi',
            email: '  '),
        invoiceItems: [
          InvoiceItemModel(
              description: 'Item 1', quantity: 1, price: 100.0, invoiceId: '1'),
        ],
      );
      final allInvoices = [
        invoice,
        ExtendedInvoiceModel(
          id: '2',
          dateCreated: DateTime.now(),
          percentageTax: 0.0,
          totalBeforeTax: 100.0,
          total: 100.0,
          customer: CustomerModel(
              name: 'John Doe',
              address: '134 Main Street',
              city: 'Mombasa',
              email: '  '),
          invoiceItems: [
            InvoiceItemModel(
                description: 'Item 2',
                quantity: 1,
                price: 100.0,
                invoiceId: '2'),
          ],
        )
      ];

      bloc.emit(InvoiceState(
        status: InvoiceStatus.success,
        invoices: allInvoices,
      ));

      expectLater(
          bloc.stream,
          emitsInOrder([
            InvoiceState(status: InvoiceStatus.loading, invoices: allInvoices),
            InvoiceState(
                status: InvoiceStatus.success,
                invoices: allInvoices,
                selectedInvoice: invoice)
          ]));
      bloc.add(FetchInvoice(invoice.id));
    });
  });
}

class MockHydratedStorage extends Mock implements HydratedStorage {}

void setupHydratedBlocOverrides() {
  final storage = MockHydratedStorage();

  when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
  when(() => storage.read(any())).thenReturn(null);
  when(() => storage.delete(any())).thenAnswer((_) async {});
  when(() => storage.clear()).thenAnswer((_) async {});

  HydratedBloc.storage = storage;
}
