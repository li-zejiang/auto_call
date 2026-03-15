import 'package:auto_call/viewmodels/CustomerNative.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  Isar? _isar;

  Future<Isar> get isar async {
    if (_isar != null) return _isar!;
    _isar = await _initIsar();
    return _isar!;
  }

  Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [CustomerSchema],
      directory: dir.path,
    );
  }

  // Customers
  Future<List<Customer>> getAllCustomers() async {
    final db = await isar;
    return await db.customers.where().findAll();
  }

  Future<void> saveCustomer(Customer customer) async {
    final db = await isar;
    await db.writeTxn(() async {
      await db.customers.put(customer);
    });
  }

  Future<void> deleteCustomer(int id) async {
    final db = await isar;
    await db.writeTxn(() async {
      await db.customers.delete(id);
    });
  }

  Future<List<Customer>> searchCustomers(String query) async {
    final db = await isar;
    return await db.customers
        .filter()
        .nameContains(query, caseSensitive: false)
        .or()
        .phoneContains(query)
        .findAll();
  }
}
