import 'package:flutter/foundation.dart';

import '../models/UtsavVoucher.dart';

class UtsavVoucherProvider extends ChangeNotifier {
  // Sample vouchers - in a real app, these would be loaded from API or local storage
  final List<UtsavVoucher> _availableVouchers = [];
  final List<UtsavVoucher> _claimedVouchers = [];
  final List<UtsavVoucher> _redeemedVouchers = [];

  // Getters
  List<UtsavVoucher> get availableVouchers => _availableVouchers;
  List<UtsavVoucher> get claimedVouchers => _claimedVouchers;
  List<UtsavVoucher> get redeemedVouchers => _redeemedVouchers;

  // Add a new voucher to available list (from API/backend)
  void addAvailableVoucher(UtsavVoucher voucher) {
    _availableVouchers.add(voucher);
    notifyListeners();
  }

  // Claim a voucher - move from available to claimed
  UtsavVoucher claimVoucher(String voucherId) {
    final index = _availableVouchers.indexWhere((v) => v.id == voucherId);
    if (index >= 0) {
      final voucher = _availableVouchers[index];
      final claimedVoucher = voucher.claimVoucher();
      _availableVouchers.removeAt(index);
      _claimedVouchers.add(claimedVoucher);
      notifyListeners();
      return claimedVoucher;
    }
    throw Exception('Voucher not found');
  }

  // Redeem a voucher - move from claimed to redeemed
  void redeemVoucher(String voucherId) {
    final index = _claimedVouchers.indexWhere((v) => v.id == voucherId);
    if (index >= 0) {
      final voucher = _claimedVouchers[index];
      // Create a redeemed version of the voucher
      final redeemedVoucher = UtsavVoucher(
        id: voucher.id,
        shopName: voucher.shopName,
        shopAddress: voucher.shopAddress,
        voucherTitle: voucher.voucherTitle,
        voucherValue: voucher.voucherValue,
        voucherCode: voucher.voucherCode,
        voucherPin: voucher.voucherPin,
        claimedDate: voucher.claimedDate,
        expiryDate: voucher.expiryDate,
        status: 'redeemed',
        quantity: voucher.quantity,
      );
      _claimedVouchers.removeAt(index);
      _redeemedVouchers.add(redeemedVoucher);
      notifyListeners();
    }
  }

  // Initialize with sample data for testing
  void initSampleData() {
    // Clear existing data
    _availableVouchers.clear();
    _claimedVouchers.clear();
    _redeemedVouchers.clear();

    // Add sample available vouchers
    _availableVouchers.add(
      UtsavVoucher(
        id: '1',
        shopName: 'SSR Ayurvedic and Panchkarma Clinic',
        shopAddress:
            'Shop No. 51, Shalimar Building, Near Hospital, Sector 18, Noida, Uttar Pradesh',
        voucherTitle: 'Gift Voucher worth Rs. 500',
        voucherValue: 500,
        status: 'available',
        quantity: 1,
        expiryDate: DateTime.now().add(const Duration(days: 365)),
      ),
    );

    _availableVouchers.add(
      UtsavVoucher(
        id: '2',
        shopName: 'SSR Ayurvedic and Panchkarma Clinic',
        shopAddress:
            'Shop No. 51, Shalimar Building, Near Hospital, Sector 18, Noida, Uttar Pradesh',
        voucherTitle: 'Gift Voucher worth Rs. 500',
        voucherValue: 500,
        status: 'available',
        quantity: 1,
        expiryDate: DateTime.now().add(const Duration(days: 365)),
      ),
    );

    notifyListeners();
  }
}
