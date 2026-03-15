import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewmodels/Customer.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Customers
  Future<List<Customer>> getAllCustomers() async {
    final p = await prefs;
    final String? customersJson = p.getString('customers');
    if (customersJson == null) return [];
    final List<dynamic> list = json.decode(customersJson);
    return list.map((e) => _fromMap(e)).toList();
  }

  Future<void> saveCustomer(Customer customer) async {
    final p = await prefs;
    final List<Customer> customers = await getAllCustomers();
    
    // Simple mock of Isar's autoIncrement
    if (customer.id == 0) {
      customer.id = customers.isEmpty ? 1 : customers.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    }

    final index = customers.indexWhere((e) => e.id == customer.id);
    if (index != -1) {
      customers[index] = customer;
    } else {
      customers.add(customer);
    }
    
    await p.setString('customers', json.encode(customers.map((e) => _toMap(e)).toList()));
  }

  Future<void> deleteCustomer(int id) async {
    final p = await prefs;
    final List<Customer> customers = await getAllCustomers();
    customers.removeWhere((e) => e.id == id);
    await p.setString('customers', json.encode(customers.map((e) => _toMap(e)).toList()));
  }

  Future<List<Customer>> searchCustomers(String query) async {
    final List<Customer> customers = await getAllCustomers();
    final lowerQuery = query.toLowerCase();
    return customers.where((e) => 
      e.name.toLowerCase().contains(lowerQuery) || 
      e.phone.contains(query)
    ).toList();
  }

  // Helpers for Web (since we can't use Isar's generated code on Web due to the ID error)
  Customer _fromMap(Map<String, dynamic> map) {
    return Customer()
      ..id = map['id']
      ..name = map['name']
      ..phone = map['phone']
      ..tag = map['tag']
      ..createdAt = DateTime.parse(map['createdAt'])
      ..rating = map['rating']
      ..note = map['note'];
  }

  Map<String, dynamic> _toMap(Customer c) {
    return {
      'id': c.id,
      'name': c.name,
      'phone': c.phone,
      'tag': c.tag,
      'createdAt': c.createdAt.toIso8601String(),
      'rating': c.rating,
      'note': c.note,
    };
  }
}
