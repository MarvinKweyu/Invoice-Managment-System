import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:invoice_management/models/extended_invoice_model.dart';
import 'dart:developer' as devtools show log;

import 'package:invoice_management/services/pdf_generator.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends HydratedBloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(const InvoiceState()) {
    on<InvoiceStarted>(_onStarted);
    on<CreateInvoice>(_onCreated);
    on<UpdateInvoice>(_onUpdated);
    on<FetchInvoice>(_onFetchInvoice);
    on<GenerateInvoice>(_onGenerateInvoice);
  }

  void _onStarted(InvoiceStarted event, Emitter<InvoiceState> emit) {
    if (state.status == InvoiceStatus.success) return;

    emit(state.copyWith(
        invoices: state.invoices,
        status: InvoiceStatus.success,
        message: '',
        selectedInvoice: null,
        exportedInvoice: null));
  }

  void _onCreated(CreateInvoice event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(status: InvoiceStatus.loading));
    try {
      List<ExtendedInvoiceModel> temp = [];
      temp.addAll(state.invoices);
      temp.insert(0, event.invoice);
      // final List<ExtendedInvoiceModel> invoices = List.from(state.invoices);
      // invoices.add(event.invoice);
      emit(state.copyWith(status: InvoiceStatus.success, invoices: temp));
    } catch (e) {
      emit(state.copyWith(status: InvoiceStatus.error, message: e.toString()));
    }
  }

  void _onUpdated(UpdateInvoice event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(status: InvoiceStatus.loading));
    try {
      final List<ExtendedInvoiceModel> invoices = List.from(state.invoices);
      final index =
          invoices.indexWhere((element) => element.id == event.invoice.id);
      invoices[index] = event.invoice;
      emit(state.copyWith(status: InvoiceStatus.success, invoices: invoices));
    } catch (e) {
      emit(state.copyWith(status: InvoiceStatus.error, message: e.toString()));
    }
  }

  void _onFetchInvoice(FetchInvoice event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(status: InvoiceStatus.loading));
    try {
      final List<ExtendedInvoiceModel> invoices = List.from(state.invoices);
      final invoiceInfo =
          invoices.firstWhere((element) => element.id == event.invoiceId);
      emit(state.copyWith(
        status: InvoiceStatus.success,
        invoices: invoices,
        selectedInvoice: invoiceInfo,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: InvoiceStatus.error,
          message: 'No Invoice matching this ID found'));
    }
  }

  void _onGenerateInvoice(
      GenerateInvoice event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(status: InvoiceStatus.loading));
    try {
      final pdfFile = await PdfInvoiceApi().generate(state.selectedInvoice!);

      final List<ExtendedInvoiceModel> invoices = List.from(state.invoices);

      emit(state.copyWith(
        status: InvoiceStatus.exporting,
        invoices: invoices,
        selectedInvoice: event.invoice,
        exportedInvoice: pdfFile,
      ));
    } catch (e) {
      emit(state.copyWith(status: InvoiceStatus.error, message: e.toString()));
    }
  }

  @override
  InvoiceState? fromJson(Map<String, dynamic> json) {
    return InvoiceState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(InvoiceState state) {
    return state.toJson();
  }
}
