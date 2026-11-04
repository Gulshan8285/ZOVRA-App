import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/address_model.dart';
import '../../../data/repositories/zovra_repository.dart';
import '../../home/providers/home_provider.dart';

class AddressState {
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;
  final bool isLoading;

  const AddressState({
    this.addresses = const [],
    this.selectedAddress,
    this.isLoading = false,
  });

  AddressState copyWith({
    List<AddressModel>? addresses,
    AddressModel? selectedAddress,
    bool? isLoading,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AddressNotifier extends StateNotifier<AddressState> {
  final ZovraRepository _repository;
  final _uuid = const Uuid();

  AddressNotifier(this._repository)
      : super(AddressState(
          addresses: _repository.getAddresses(),
          selectedAddress: _repository.getSelectedAddress(),
        ));

  void selectAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address);
  }

  Future<void> addAddress({
    required String tag,
    required String houseNumber,
    required String buildingName,
    required String streetLocality,
    required String city,
    required String stateName,
    required String pincode,
    String contactPhone = '',
    String specialInstructions = '',
    bool isDefault = false,
  }) async {
    state = state.copyWith(isLoading: true);
    final address = AddressModel(
      id: 'addr_${_uuid.v4().substring(0, 8)}',
      tag: tag,
      houseNumber: houseNumber,
      buildingName: buildingName,
      streetLocality: streetLocality,
      city: city,
      state: stateName,
      pincode: pincode,
      contactPhone: contactPhone,
      specialInstructions: specialInstructions,
      isDefault: isDefault || state.addresses.isEmpty,
    );

    final updated = await _repository.addAddress(address);
    final newSelected = isDefault || state.selectedAddress == null ? address : state.selectedAddress;
    state = state.copyWith(
      addresses: updated,
      selectedAddress: newSelected,
      isLoading: false,
    );
  }

  Future<void> updateAddress(AddressModel address) async {
    state = state.copyWith(isLoading: true);
    final updated = await _repository.updateAddress(address);
    final updatedSelected = state.selectedAddress?.id == address.id ? address : state.selectedAddress;
    state = state.copyWith(
      addresses: updated,
      selectedAddress: updatedSelected,
      isLoading: false,
    );
  }

  Future<void> deleteAddress(String addressId) async {
    state = state.copyWith(isLoading: true);
    final updated = await _repository.deleteAddress(addressId);
    AddressModel? newSelected = state.selectedAddress;
    if (state.selectedAddress?.id == addressId) {
      newSelected = updated.isNotEmpty ? updated.first : null;
    }
    state = state.copyWith(
      addresses: updated,
      selectedAddress: newSelected,
      isLoading: false,
    );
  }

  Future<void> setDefault(String addressId) async {
    final updated = await _repository.setDefaultAddress(addressId);
    final defaultItem = updated.firstWhere((a) => a.id == addressId);
    state = state.copyWith(addresses: updated, selectedAddress: defaultItem);
  }
}

final addressProvider = StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  final repo = ref.watch(zovraRepositoryProvider);
  return AddressNotifier(repo);
});

