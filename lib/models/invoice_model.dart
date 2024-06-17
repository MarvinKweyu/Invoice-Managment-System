// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InvoiceModel {
  String? id;
  DateTime dateCreated;
  double totalBeforeTax;
  double percentageTax;
  double total;

  String customerId; // since we are using uuid

  @override
  String toString() {
    return 'InvoiceModel(id: $id, dateCreated: $dateCreated, percentageTax: $percentageTax, total: $total, customerId: $customerId)';
  }

  InvoiceModel({
    this.id,
    required this.dateCreated,
    required this.totalBeforeTax,
    required this.percentageTax,
    required this.total,
    required this.customerId,
  });

  InvoiceModel copyWith({
    String? id,
    DateTime? dateCreated,
    double? percentageTax,
    double? totalBeforeTax,
    double? total,
    String? customerId,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      dateCreated: dateCreated ?? this.dateCreated,
      percentageTax: percentageTax ?? this.percentageTax,
      totalBeforeTax: totalBeforeTax ?? this.totalBeforeTax,
      total: total ?? this.total,
      customerId: customerId ?? this.customerId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
      'percentageTax': percentageTax,
      'totalBeforeTax': totalBeforeTax,
      'total': total,
      'customerId': customerId,
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      id: map['id'] != null ? map['id'] as String : null,
      dateCreated:
          DateTime.fromMillisecondsSinceEpoch(map['dateCreated'] as int),
      percentageTax: map['percentageTax'] as double,
      totalBeforeTax: map['totalBeforeTax'] as double,
      total: map['total'] as double,
      customerId: map['customerId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvoiceModel.fromJson(String source) =>
      InvoiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant InvoiceModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.dateCreated == dateCreated &&
        other.percentageTax == percentageTax &&
        other.total == total &&
        other.customerId == customerId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dateCreated.hashCode ^
        percentageTax.hashCode ^
        total.hashCode ^
        customerId.hashCode;
  }

  void update(InvoiceModel invoice) {
    if (invoice.id != null) {
      id = invoice.id;
    }

    dateCreated = invoice.dateCreated;

    percentageTax = invoice.percentageTax;

    total = invoice.total;

    customerId = invoice.customerId;
  }
}



  // : total = invoiceItems
  //               .map((item) => item.price * item.quantity)
  //               .reduce((value, element) => value + element) *
  //           (1 + percentageTax / 100);