

import 'package:flutter/foundation.dart';
import 'package:invoice_management/features/invoice_management/models/customer_model.dart';
import 'package:invoice_management/features/invoice_management/models/invoice_item_model.dart';

class ExtendedInvoiceModel {
  String id;
  DateTime dateCreated;

  double percentageTax;

  double totalBeforeTax;
  double total;
  CustomerModel customer;
  List<InvoiceItemModel> invoiceItems;

  ExtendedInvoiceModel({
    required this.id,
    required this.dateCreated,
    required this.percentageTax,
    required this.totalBeforeTax,
    required this.total,
    required this.customer,
    required this.invoiceItems,
  });

  ExtendedInvoiceModel copyWith({
    String? id,
    DateTime? dateCreated,
    double? percentageTax,
    double? totalBeforeTax,
    double? total,
    CustomerModel? customer,
    List<InvoiceItemModel>? invoiceItems,
  }) {
    return ExtendedInvoiceModel(
      id: id ?? this.id,
      dateCreated: dateCreated ?? this.dateCreated,
      percentageTax: percentageTax ?? this.percentageTax,
      totalBeforeTax: totalBeforeTax ?? this.totalBeforeTax,
      total: total ?? this.total,
      customer: customer ?? this.customer,
      invoiceItems: invoiceItems ?? this.invoiceItems,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
      'percentageTax': percentageTax,
      'totalBeforeTax': totalBeforeTax,
      'total': total,
      'customer': customer.toMap(),
      'invoiceItems': invoiceItems.map((x) => x.toMap()).toList(),
    };
  }

  factory ExtendedInvoiceModel.fromMap(Map<String, dynamic> map) {
    return ExtendedInvoiceModel(
      id: map['id'] as String,
      dateCreated:
          DateTime.fromMillisecondsSinceEpoch(map['dateCreated'] as int),
      percentageTax: map['percentageTax'] as double,
      totalBeforeTax: map['totalBeforeTax'] as double,
      total: map['total'] as double,
      customer: CustomerModel.fromMap(map['customer'] as Map<String, dynamic>),
      invoiceItems: List<InvoiceItemModel>.from(
        (map['invoiceItems'] as List<int>).map<InvoiceItemModel>(
          (x) => InvoiceItemModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  // String toJson() => json.encode(toMap());

  factory ExtendedInvoiceModel.fromJson(Map<String, dynamic> json) {
    return ExtendedInvoiceModel(
      id: json['id'],
      dateCreated: DateTime.parse(json['dateCreated']),
      percentageTax: json['percentageTax'].toDouble(),
      totalBeforeTax: json['totalBeforeTax'].toDouble(),
      total: json['total'].toDouble(),
      customer: CustomerModel.fromJson(json['customer']),
      invoiceItems: (json['invoiceItems'] as List)
          .map((item) => InvoiceItemModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateCreated': dateCreated.toIso8601String(),
      'percentageTax': percentageTax,
      'totalBeforeTax': totalBeforeTax,
      'total': total,
      'customer': customer.toJson(),
      'invoiceItems': invoiceItems.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'ExtendedInvoiceModel(id: $id, dateCreated: $dateCreated, percentageTax: $percentageTax, total: $total, customer: $customer, invoiceItems: $invoiceItems)';
  }

  @override
  bool operator ==(covariant ExtendedInvoiceModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.dateCreated == dateCreated &&
        other.percentageTax == percentageTax &&
        other.totalBeforeTax == totalBeforeTax &&
        other.total == total &&
        other.customer == customer &&
        listEquals(other.invoiceItems, invoiceItems);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dateCreated.hashCode ^
        percentageTax.hashCode ^
        totalBeforeTax.hashCode ^
        total.hashCode ^
        customer.hashCode ^
        invoiceItems.hashCode;
  }
}
