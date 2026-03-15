import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../stores/StorageService.dart';
import 'Customer.dart';

// Storage Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Customer List Provider
class CustomerListController extends StateNotifier<AsyncValue<List<Customer>>> {
  final StorageService _storage;
  CustomerListController(this._storage) : super(const AsyncValue.loading()) {
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    state = const AsyncValue.loading();
    try {
      final customers = await _storage.getAllCustomers();
      state = AsyncValue.data(customers);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addCustomer(Customer customer) async {
    await _storage.saveCustomer(customer);
    await loadCustomers();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      await loadCustomers();
      return;
    }
    state = const AsyncValue.loading();
    try {
      final results = await _storage.searchCustomers(query);
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final customerListProvider =
    StateNotifierProvider<CustomerListController, AsyncValue<List<Customer>>>(
        (ref) {
  final storage = ref.watch(storageServiceProvider);
  return CustomerListController(storage);
});
