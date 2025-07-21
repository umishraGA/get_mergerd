class UtsavVoucher {
  final String id;
  final String shopName;
  final String shopAddress;
  final String voucherTitle;
  final double voucherValue;
  final String? voucherCode;
  final String? voucherPin;
  final DateTime? claimedDate;
  final DateTime? expiryDate;
  final String status; // "available", "claimed", "redeemed", "expired"
  final int quantity;

  UtsavVoucher({
    required this.id,
    required this.shopName,
    required this.shopAddress,
    required this.voucherTitle,
    required this.voucherValue,
    this.voucherCode,
    this.voucherPin,
    this.claimedDate,
    this.expiryDate,
    required this.status,
    required this.quantity,
  });

  // Create a voucher with claimed status - generates voucher code and pin
  UtsavVoucher claimVoucher() {
    // In a real app, this would come from a backend API
    final String generatedCode =
        "60001700${id.hashCode.toString().padLeft(8, '0')}";
    final String generatedPin =
        '${DateTime.now().millisecondsSinceEpoch % 1000000}';

    return UtsavVoucher(
      id: id,
      shopName: shopName,
      shopAddress: shopAddress,
      voucherTitle: voucherTitle,
      voucherValue: voucherValue,
      voucherCode: generatedCode,
      voucherPin: generatedPin,
      claimedDate: DateTime.now(),
      expiryDate: expiryDate,
      status: "claimed",
      quantity: quantity,
    );
  }

  // Factory constructor from map (for database or API)
  factory UtsavVoucher.fromMap(Map<String, dynamic> map) {
    return UtsavVoucher(
      id: map['id'].toString(),
      shopName: map['shopName'].toString(),
      shopAddress: map['shopAddress'].toString(),
      voucherTitle: map['voucherTitle'].toString(),
      voucherValue: double.parse(map['voucherValue'].toString()),
      voucherCode: map['voucherCode']?.toString(),
      voucherPin: map['voucherPin']?.toString(),
      claimedDate: map['claimedDate'] != null
          ? DateTime.parse(map['claimedDate'].toString())
          : null,
      expiryDate: map['expiryDate'] != null
          ? DateTime.parse(map['expiryDate'].toString())
          : null,
      status: map['status'].toString(),
      quantity: int.parse(map['quantity'].toString()),
    );
  }

  // Convert to map (for database or API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shopName': shopName,
      'shopAddress': shopAddress,
      'voucherTitle': voucherTitle,
      'voucherValue': voucherValue,
      'voucherCode': voucherCode,
      'voucherPin': voucherPin,
      'claimedDate': claimedDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'status': status,
      'quantity': quantity,
    };
  }
}
