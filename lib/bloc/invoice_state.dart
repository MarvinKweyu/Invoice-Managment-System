part of 'invoice_bloc.dart';

enum InvoiceStatus { initial, loading, success, exporting, error }

class InvoiceState extends Equatable {
  final InvoiceStatus status;
  final List<ExtendedInvoiceModel> invoices;
  final String message;
  final ExtendedInvoiceModel? selectedInvoice;
  final Uint8List? exportedInvoice;

  const InvoiceState({
    this.status = InvoiceStatus.initial,
    this.invoices = const [],
    this.message = '',
    this.selectedInvoice,
    this.exportedInvoice,
  });

  InvoiceState copyWith({
    InvoiceStatus? status,
    List<ExtendedInvoiceModel>? invoices,
    ExtendedInvoiceModel? selectedInvoice,
    Uint8List? exportedInvoice,
    String? message,
  }) {
    return InvoiceState(
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
      selectedInvoice: selectedInvoice ?? this.selectedInvoice,
      exportedInvoice: exportedInvoice ?? this.exportedInvoice,
      message: message ?? this.message,
    );
  }

  factory InvoiceState.fromJson(Map<String, dynamic> json) {
    return InvoiceState(
      status: InvoiceStatus.values[json['status']],
      invoices: (json['invoices'] as List<dynamic>)
          .map((e) => ExtendedInvoiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
      selectedInvoice: json['selectedInvoice'] != null
          ? ExtendedInvoiceModel.fromJson(
              json['selectedInvoice'] as Map<String, dynamic>)
          : null,
      exportedInvoice: json['exportedInvoice'] != null
          ? Uint8List.fromList(
              List<int>.from(json['exportedInvoice'] as List<dynamic>))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.index,
      'invoices': invoices.map((e) => e.toJson()).toList(),
      'message': message,
      'selectedInvoice': selectedInvoice?.toJson(),
      'exportedInvoice': exportedInvoice?.toList(),
    };
  }

  @override
  List<Object?> get props =>
      [status, invoices, message, selectedInvoice, exportedInvoice];
}
