import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../spiritual/presentation/controller/all_temple_comtroller.dart';
import '../../spiritual/presentation/screens/temple_detail_screen.dart';
import '../widgets/AppHeader.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late final AllTempleController templeController;
  List<dynamic> filteredTemples = [];
  bool hasSearched = false;

  @override
  void initState() {
    super.initState();
    // Try to find existing controller, if not found, create a new one
    try {
      templeController = Get.find<AllTempleController>();
    } catch (e) {
      templeController = Get.put(AllTempleController());
    }
    _searchFocusNode.requestFocus();
    filteredTemples = []; // Start with empty list
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterTemples(String query) {
    setState(() {
      hasSearched = query.isNotEmpty;
      if (query.isEmpty) {
        filteredTemples = []; // Clear results when search is empty
      } else {
        filteredTemples = templeController.temples.where((temple) {
          final name = temple['name']?.toString().toLowerCase() ?? '';
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppHeader(
            title: 'Search Temples',
            showMenu: false,
            showShare: false,
            showSearch: false,
            onBackPressed: () => Navigator.pop(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: const Color(0xFFBB9F9F)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search temples...',
                  focusedBorder: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Color(0xFF909090),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFFBB9F9F)),
                    onPressed: () {
                      _searchController.clear();
                      _filterTemples('');
                    },
                  ),
                ),
                onChanged: _filterTemples,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (templeController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!hasSearched) {
                return const Center(
                  child: Text(
                    'Search for temples by name',
                    style: TextStyle(
                      color: Color(0xFF909090),
                      fontSize: 16,
                    ),
                  ),
                );
              }

              if (filteredTemples.isEmpty) {
                return const Center(
                  child: Text(
                    'No temples found',
                    style: TextStyle(
                      color: Color(0xFF909090),
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredTemples.length,
                itemBuilder: (context, index) {
                  final temple = filteredTemples[index];
                  return _buildTempleItem(temple);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTempleItem(dynamic temple) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          temple['name']?.toString() ?? 'Temple',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          "${temple['location']?['city']?['name']?.toString() ?? 'Unknown location'}, ${temple['location']?['state']?['name']?.toString() ?? 'Unknown location'}",
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF909090),
          ),
        ),
        leading: temple['image'] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  temple['image'].toString(),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.temple_hindu_outlined, size: 50),
                ),
              )
            : const Icon(Icons.temple_hindu_outlined, size: 50),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TempleDetailScreen(
                templeId: temple['_id']?.toString() ?? 'Temple',
                // location: temple['location']['state']['name']?.toString() ?? 'Location',
                // imagePath: temple['image']?.toString() ?? '',
                // description: temple['about']?.toString() ?? '',
                // followers: 10000,
              ),
            ),
          );
        },
      ),
    );
  }
}
