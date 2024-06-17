part of 'invoice_bloc.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object> get props => [];
}

class InvoiceStarted extends InvoiceEvent {}

class CreateInvoice extends InvoiceEvent {
  final ExtendedInvoiceModel invoice;

  const CreateInvoice(this.invoice);

  @override
  List<Object> get props => [invoice];

  @override
  String toString() => 'CreateInvoice { invoice: $invoice }';
}

class UpdateInvoice extends InvoiceEvent {
  final ExtendedInvoiceModel invoice;

  const UpdateInvoice(this.invoice);

  @override
  List<Object> get props => [invoice];

  @override
  String toString() => 'UpdateInvoice { invoice: $invoice }';
}

class DeleteInvoice extends InvoiceEvent {
  final ExtendedInvoiceModel invoice;

  const DeleteInvoice(this.invoice);

  @override
  List<Object> get props => [invoice];

  @override
  String toString() => 'DeleteInvoice { invoice: $invoice }';
}

class FetchInvoice extends InvoiceEvent {
  final String invoiceId;

  const FetchInvoice(this.invoiceId);

  @override
  List<Object> get props => [invoiceId];

  @override
  String toString() => 'FetchInvoice { invoiceId: $invoiceId }';
}

class GenerateInvoice extends InvoiceEvent {
  final ExtendedInvoiceModel invoice;

  const GenerateInvoice(this.invoice);

  @override
  List<Object> get props => [invoice];

  @override
  String toString() => 'GenerateInvoice { invoice: $invoice }';
}
