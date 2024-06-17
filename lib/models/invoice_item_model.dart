// ignore_for_file: public_member_api_docs, sort_constructors_first

class InvoiceItemModel {
  String? id;
  String description;

  double price;

  int quantity;

  String invoiceId;

  @override
  String toString() {
    return 'InvoiceItemModel(id: $id, description: $description, price: $price, quantity: $quantity, invoiceId: $invoiceId)';
  }

  InvoiceItemModel({
    this.id,
    required this.description,
    required this.price,
    required this.quantity,
    required this.invoiceId,
  });

  InvoiceItemModel copyWith({
    String? id,
    String? description,
    double? price,
    int? quantity,
    String? invoiceId,
  }) {
    return InvoiceItemModel(
      id: id ?? this.id,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      invoiceId: invoiceId ?? this.invoiceId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'price': price,
      'quantity': quantity,
      'invoiceId': invoiceId,
    };
  }

  factory InvoiceItemModel.fromMap(Map<String, dynamic> map) {
    return InvoiceItemModel(
      id: map['id'] != null ? map['id'] as String : null,
      description: map['description'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      invoiceId: map['invoiceId'] as String,
    );
  }

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      description: json['description'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      invoiceId: json['invoiceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'price': price,
      'invoiceId': invoiceId,
    };
  }

  // factory InvoiceItemModel.fromJson(String source) =>
  //     InvoiceItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant InvoiceItemModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.price == price &&
        other.quantity == quantity &&
        other.invoiceId == invoiceId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        invoiceId.hashCode;
  }

  void update(InvoiceItemModel invoiceItem) {
    id = invoiceItem.id;
    description = invoiceItem.description;
    price = invoiceItem.price;
    quantity = invoiceItem.quantity;
    invoiceId = invoiceItem.invoiceId;
  }
}
