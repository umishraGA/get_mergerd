import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/address_controller.dart';

class AddressListView extends StatefulWidget {
  AddressListView({Key? key}) : super(key: key);

  @override
  State<AddressListView> createState() => _AddressListViewState();
}

class _AddressListViewState extends State<AddressListView> {
  final AddressController controller = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody()),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      title: const Text('My Addresses', style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return _buildLoadingState();
    }

    return Column(
      children: [
        _buildAddAddressOption(),
        Expanded(
          child: controller.addresses.isEmpty
              ? _buildEmptyState()
              : _buildAddressList(),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 3),
          SizedBox(height: 16),
          Text('Loading addresses...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAddAddressOption() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showAddAddressDialog(),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Add Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SAVED ADDRESSES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            Icon(Icons.location_off_rounded, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No addresses saved yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first address to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressList() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'SAVED ADDRESSES',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.refreshAddresses,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.addresses.length,
              itemBuilder: (context, index) => _buildAddressCard(controller.addresses[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(AddressModel address) {
    final bool isDefault = address.isDefault;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isDefault ? Border.all(color: Colors.blue, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTypeChip(address.types),
                const Spacer(),
                if (isDefault) _buildDefaultBadge(),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  itemBuilder: (_) => [
                    if (!isDefault)
                      PopupMenuItem(
                        onTap: () => controller.setDefaultAddress(address.id),
                        child: const Row(
                          children: [
                            Icon(Icons.star, size: 18),
                            SizedBox(width: 8),
                            Text('Set as Default')
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit')
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete')
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              address.firstName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              controller.formatAddressForDisplay(address),
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Phone : ${address.mobile}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                if (address.deliveryTime.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        address.deliveryTime,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],

              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    final colors = {
      'home': Colors.green,
      'office': Colors.blue,
      'other': Colors.orange,
    };
    final color = colors[type.toLowerCase()] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getTypeIcon(type), size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            type.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 12, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'DEFAULT',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'office':
        return Icons.business;
      default:
        return Icons.location_on;
    }
  }

  void _showAddAddressDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Add New Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.green),
              title: const Text('Home Address'),
              onTap: () => _navigateToAddAddress('home'),
            ),
            ListTile(
              leading: const Icon(Icons.business, color: Colors.blue),
              title: const Text('Office Address'),
              onTap: () => _navigateToAddAddress('office'),
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.orange),
              title: const Text('Other Address'),
              onTap: () => _navigateToAddAddress('other'),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _navigateToAddAddress(String type) {
    Get.back();
    Get.snackbar(
      'Add Address',
      'Navigate to add $type address form',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}