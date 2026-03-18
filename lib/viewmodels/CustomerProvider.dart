import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../stores/StorageService.dart';
import 'Customer.dart';

// Storage Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

abstract class CustomerBackend {
  Future<void> upsertCustomer(Customer customer);
}

class NoopCustomerBackend implements CustomerBackend {
  @override
  Future<void> upsertCustomer(Customer customer) async {}
}

final customerBackendProvider = Provider<CustomerBackend>((ref) {
  return NoopCustomerBackend();
});

// Customer List Provider
class CustomerListController extends StateNotifier<AsyncValue<List<Customer>>> {
  final StorageService _storage;
  final CustomerBackend _backend;
  CustomerListController(this._storage, this._backend)
      : super(const AsyncValue.loading()) {
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

  Future<void> saveCustomer(Customer customer) async {
    await _storage.saveCustomer(customer);
    try {
      await _backend.upsertCustomer(customer);
    } catch (_) {}
    await loadCustomers();
  }

  Future<void> addCustomer(Customer customer) async {
    await saveCustomer(customer);
  }

  Future<void> deleteCustomer(int id) async {
    await _storage.deleteCustomer(id);
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
  final backend = ref.watch(customerBackendProvider);
  return CustomerListController(storage, backend);
});
