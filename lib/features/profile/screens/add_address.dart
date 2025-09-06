import 'package:flutter/material.dart';

class AddDeliveryAddressScreen extends StatefulWidget {
  @override
  _AddDeliveryAddressScreenState createState() => _AddDeliveryAddressScreenState();
}

class _AddDeliveryAddressScreenState extends State<AddDeliveryAddressScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(text: 'My Name Is Upansh Mishra');
  final TextEditingController _phoneController = TextEditingController(text: '7460837725');
  final TextEditingController _addressController = TextEditingController();

  String selectedAddressType = 'Home';
  String currentAddress = 'Chinhat Bazar, Ganga Vihar, Chinhat, Lucknow';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header with search
          Container(
            padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for area, street name...',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Map Container
                  Container(
                    height: 250,
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Stack(
                      children: [
                        // Map placeholder
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.blue[100],
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.map, size: 40, color: Colors.blue[300]),
                                  SizedBox(height: 8),
                                  Text('Map View', style: TextStyle(color: Colors.blue[300])),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Pin and tooltip
                        Positioned(
                          top: 60,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Move pin to your exact delivery location',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                              SizedBox(height: 8),
                              Icon(Icons.location_on, color: Colors.red, size: 40),
                            ],
                          ),
                        ),

                        // Location indicators
                        Positioned(
                          left: 20,
                          top: 140,
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.blue),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.home, size: 12, color: Colors.blue),
                                    SizedBox(width: 4),
                                    Text('32', style: TextStyle(fontSize: 12, color: Colors.blue)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Positioned(
                          left: 20,
                          bottom: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.grey, size: 16),
                                  SizedBox(width: 4),
                                  Text('Harish Watch Repair', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              Text('हरीश वॉच रिपेयर', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ),

                        Positioned(
                          right: 20,
                          bottom: 40,
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.grey, size: 16),
                              SizedBox(width: 4),
                              Text('A.N.S. Enterprises', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Use current location button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.my_location, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Use current location', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Delivery details section
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Delivery details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[600])),
                        SizedBox(height: 16),

                        // Current address
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.red, size: 20),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(currentAddress, style: TextStyle(fontSize: 16)),
                            ),
                            Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),

                        SizedBox(height: 24),

                        // Additional address details
                        Text('Additional address details*', style: TextStyle(color: Colors.grey[600])),
                        SizedBox(height: 8),
                        TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            hintText: 'E.g. Floor, House no.',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),

                        SizedBox(height: 24),

                        // Receiver details
                        Text('Receiver details for this address', style: TextStyle(color: Colors.grey[600])),
                        SizedBox(height: 16),

                        Row(
                          children: [
                            Icon(Icons.phone, color: Colors.grey[600], size: 20),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_nameController.text, style: TextStyle(fontSize: 16)),
                                  Text(_phoneController.text, style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),

                        SizedBox(height: 24),

                        // Save address as
                        Text('Save address as', style: TextStyle(color: Colors.grey[600])),
                        SizedBox(height: 12),

                        Row(
                          children: [
                            _buildAddressTypeChip('Home', Icons.home),
                            SizedBox(width: 12),
                            _buildAddressTypeChip('Work', Icons.work),
                            SizedBox(width: 12),
                            _buildAddressTypeChip('Other', Icons.location_on),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Save button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: ElevatedButton(
              onPressed: () {
                // Save address logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Address saved successfully!')),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Save address', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTypeChip(String type, IconData icon) {
    bool isSelected = selectedAddressType == type;
    return GestureDetector(
      onTap: () => setState(() => selectedAddressType = type),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red[50] : Colors.transparent,
          border: Border.all(color: isSelected ? Colors.red : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.red : Colors.grey[600]),
            SizedBox(width: 4),
            Text(type, style: TextStyle(color: isSelected ? Colors.red : Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}