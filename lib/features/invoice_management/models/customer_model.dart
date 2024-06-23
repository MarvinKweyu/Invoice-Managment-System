// ignore_for_file: public_member_api_docs, sort_constructors_first

class CustomerModel {
  String? id;
  String name;
  String address;

  String email;
  String city;

  @override
  String toString() {
    return 'CustomerModel(id: $id, name: $name, address: $address, email: $email, city: $city)';
  }

  CustomerModel({
    this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.city,
  });

  CustomerModel copyWith({
    String? id,
    String? name,
    String? address,
    String? email,
    String? city,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      email: email ?? this.email,
      city: city ?? this.city,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'email': email,
      'city': city,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      address: map['address'] as String,
      email: map['email'] as String,
      city: map['city'] as String,
    );
  }

  // String toJson() => json.encode(toMap());

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'email': email,
    };
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      name: json['name'],
      address: json['address'],
      city: json['city'],
      email: json['email'],
    );
  }

  @override
  bool operator ==(covariant CustomerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.address == address &&
        other.email == email &&
        other.city == city;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        address.hashCode ^
        email.hashCode ^
        city.hashCode;
  }

  void update(CustomerModel customer) {
    id = customer.id;
    name = customer.name;
    address = customer.address;

    email = customer.email;
    city = customer.city;
  }
}
