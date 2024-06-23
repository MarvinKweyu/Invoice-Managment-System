import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_management/core/constants.dart';
import 'package:invoice_management/core/responsive.dart';

import 'package:invoice_management/features/invoice_management/bloc/invoice_bloc.dart';
import 'package:invoice_management/features/invoice_management/models/customer_model.dart';
import 'package:invoice_management/features/invoice_management/models/extended_invoice_model.dart';
import 'package:invoice_management/features/invoice_management/models/invoice_item_model.dart';
import 'package:invoice_management/features/invoice_management/models/invoice_model.dart';


import 'dart:developer' as devtools show log;

import 'package:uuid/uuid.dart';

class NewInvoice extends StatefulWidget {
  const NewInvoice({super.key});

  @override
  State<NewInvoice> createState() => _NewInvoiceState();
}

class _NewInvoiceState extends State<NewInvoice> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _percentageTaxController = TextEditingController();
  List<Widget> _invoiceRows = [];
  int _invoiceItemsCount = 1;
  final List<Map<String, dynamic>> _invoiceItems = [];
  String? _data = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _percentageTaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create an Invoice',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.symmetric(
              vertical: defaultPadding,
              horizontal: Responsive.isMobile(context) ? defaultPadding : 100),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // client information
                Text('Client Information',
                    style: Theme.of(context).textTheme.bodyLarge),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the client's name";
                          } else if (!RegExp(r'^[a-zA-Z\s]{3,20}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid name';
                          }

                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]'))
                        ],
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.account_box_outlined),
                          hintText: 'John Doe',
                          labelText: 'Client Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: 'johndoe@mail.com',
                          border: OutlineInputBorder(),
                          labelText: 'Email Address',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill this field';
                          }
                          // ensure it is a valid email
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _streetAddressController,
                        keyboardType: TextInputType.streetAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.streetview_outlined),
                          border: OutlineInputBorder(),
                          hintText: '123 Jacaranda Street, Nairobi',
                          labelText: 'Address',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill this field';
                          } else if (!RegExp(r'^[a-zA-Z0-9\s]{3,20}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid address';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_city_outlined),
                          border: OutlineInputBorder(),
                          hintText: 'Nairobi',
                          labelText: 'City',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill this field';
                          } else if (!RegExp(r'^[a-zA-Z\s]{3,20}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid city name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
                // invoice items
                Text('Items for this invoice',
                    style: Theme.of(context).textTheme.bodyLarge),
                ...List.generate(_invoiceItemsCount, (index) => form(index)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: _invoiceItemsCount > 1,
                      child: IconButton(
                        onPressed: () {
                          if (_invoiceItems.isNotEmpty) {
                            _invoiceItems.removeAt(_invoiceItems.length - 1);
                          }
                          setState(() {
                            _data = _invoiceItems.toString();
                            _invoiceItemsCount--;
                          });
                        },
                        icon: const CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.remove,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() => _invoiceItemsCount++);
                        },
                        icon: const CircleAvatar(
                          backgroundColor: primaryColor,
                          child: Icon(
                            Icons.add,
                          ),
                        )),
                  ],
                ),

                const SizedBox(height: defaultPadding),

                Text('Percentage tax applied for these items',
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  controller: _percentageTaxController,
                  // initialValue: '16',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the percentage tax. Example: 16 for 16%";
                    }

                    if (double.parse(value) > 100) {
                      return 'Please enter a valid value for the percentage tax';
                    }

                    return null;
                  },

                  decoration: const InputDecoration(
                    labelText: 'Tax Percentage',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    //
                    if (_formKey.currentState!.validate()) {
                      // retrieve customer information
                      final name = _nameController.text;
                      final email = _emailController.text;
                      // final phone = _phoneController.text;
                      final streetAddress = _streetAddressController.text;
                      final city = _cityController.text;

                      final tax = double.parse(_percentageTaxController.text);

                      // create a customer

                      CustomerModel customer = CustomerModel(
                        id: const Uuid().v4(),
                        name: name,
                        address: streetAddress,
                        email: email,
                        city: city,
                      );

                      // create invoice
                      InvoiceModel newInvoice = InvoiceModel(
                        id: const Uuid().v4(),
                        dateCreated: DateTime.now(),
                        totalBeforeTax: 0.0,
                        percentageTax: tax,
                        total: 0.0,
                        customerId: customer.id!,
                      );
                      List<InvoiceItemModel> allItems = [];

                      // get all invoice items from _invoiceItems

                      for (final item in _invoiceItems) {
                        final invoiceItem = InvoiceItemModel(
                          id: const Uuid().v4(),
                          description: item['desc'],
                          quantity: int.parse(item['quant']),
                          price: double.parse(item['price']),
                          invoiceId: newInvoice.id!,
                        );
                        allItems.add(invoiceItem);
                      }

                      double totalCost = allItems
                          .map((item) => item.price * item.quantity)
                          .reduce((value, element) => value + element);
                      // include tax on the total
                      newInvoice.totalBeforeTax = totalCost;
                      newInvoice.total = totalCost + (totalCost * tax / 100);
                      // update the invoice

                      ExtendedInvoiceModel invoice = ExtendedInvoiceModel(
                        id: newInvoice.id!,
                        dateCreated: newInvoice.dateCreated,
                        percentageTax: newInvoice.percentageTax,
                        totalBeforeTax: newInvoice.totalBeforeTax,
                        total: newInvoice.total,
                        customer: customer,
                        invoiceItems: allItems,
                      );
                      context.read<InvoiceBloc>().add(CreateInvoice(invoice));

                      // clear the form fields
                      _nameController.clear();
                      _emailController.clear();
                      _streetAddressController.clear();
                      _cityController.clear();
                      _percentageTaxController.clear();
                      _invoiceItems.clear();
                      _invoiceItemsCount = 1;
                      _data = '';

                      context.go('/');
                    }
                  },
                  child: const Text('Create Invoice'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget form(int key) => Column(
        children: [
          const SizedBox(
            height: defaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the item's description";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => _onUpdate(key, 'desc', val),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the quantity";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => _onUpdate(key, 'quant', val),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the item's price";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => _onUpdate(key, 'price', val),
                ),
              ),
            ],
          ),
        ],
      );

  void _onUpdate(int key, String field, String val) {
    void addData() {
      Map<String, dynamic> item = {'id': key, field: val};
      _invoiceItems.add(item);
      setState(() {
        _data = _invoiceItems.toString();
      });
    }

    if (_invoiceItems.isEmpty) {
      addData();
    } else {
      for (var map in _invoiceItems) {
        if (map["id"] == key) {
          _invoiceItems[key][field] = val;
          setState(() {
            _data = _invoiceItems.toString();
          });
          break;
        }
      }

      // ignore: unused_local_variable
      for (var map in _invoiceItems) {
        for (var map in _invoiceItems) {
          if (map["id"] == key) {
            return;
          }
        }
        addData();
      }
    }
  }
}
