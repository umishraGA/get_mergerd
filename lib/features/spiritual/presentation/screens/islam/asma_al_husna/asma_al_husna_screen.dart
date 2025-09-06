import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Islam_controller/sifat_allah_name_controller.dart';
import 'asma_name_detail_screen.dart';

class AsmaAlHusnaScreen extends StatefulWidget {
  const AsmaAlHusnaScreen({super.key});

  @override
  State<AsmaAlHusnaScreen> createState() => _AsmaAlHusnaScreenState();
}

class _AsmaAlHusnaScreenState extends State<AsmaAlHusnaScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AllahNamesController allahNamesController = Get.put(AllahNamesController());
  bool _isSearching = false;
  List<dynamic> _filteredNames = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchController.addListener(_filterNames);
  }

  Future<void> _initializeData() async {
    try {
      await allahNamesController.fetchAllahNames();
      if (allahNamesController.allahNames.isEmpty) {
        setState(() {
          _errorMessage = 'No names found';
          _isLoading = false;
        });
      } else {
        setState(() {
          _filteredNames = allahNamesController.allahNames;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load names: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterNames() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredNames = allahNamesController.allahNames;
      } else {
        _filteredNames = allahNamesController.allahNames.where((name) {
          return name["name_english"].toString().toLowerCase().contains(query) ||
              name["meaning"].toString().toLowerCase().contains(query) ||
              name["sorting_no"].toString().contains(query);
        }).toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredNames = allahNamesController.allahNames;
      }
    });
  }

  void _shareName(dynamic name) {
    Share.share(
      '${name["name_english"]} (${name["name_arabic"]})\nMeaning: ${name["meaning"]}\n\nShared via Islamic App',
    );
  }

  void _refreshData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    await _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: !_isSearching,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search names...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.black),
        )
            : const Column(
          children: [
            Text(
              'Asma Al-Husna',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '99 Names of Allah',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.arrow_back_ios,
            color: Colors.green,
            size: 20,
          ),
          onPressed: () {
            if (_isSearching) {
              _toggleSearch();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          if (!_isLoading && _filteredNames.isNotEmpty)
            IconButton(
              icon: Icon(
                _isSearching ? Icons.search_off : Icons.search,
                color: Colors.green,
                size: 20,
              ),
              onPressed: _toggleSearch,
            ),
          if (!_isLoading && _filteredNames.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.share,
                color: Colors.green,
                size: 20,
              ),
              onPressed: () {
                if (_filteredNames.isNotEmpty) {
                  _shareName(_filteredNames.first);
                }
              },
            ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.green,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _refreshData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredNames.isEmpty) {
      return const Center(
        child: Text('No names found matching your search'),
      );
    }

    return RefreshIndicator(
      onRefresh: _initializeData,
      child: ListView.builder(
        itemCount: _filteredNames.length,
        itemBuilder: (context, index) {
          final name = _filteredNames[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AsmaNameDetailScreen(
                    id: name["_id"]?.toString() ?? "",
                  ),
                ),
              );
            },
            child: _NameCard(
              number: name["sorting_no"].toString(),
              name: name["name_english"].toString(),
              meaning: name["meaning"].toString(),
              arabicText: name["name_arabic"].toString(),
            ),
          );
        },
      ),
    );
  }
}

class _NameCard extends StatelessWidget {
  final String number;
  final String name;
  final String meaning;
  final String arabicText;

  const _NameCard({
    required this.number,
    required this.name,
    required this.meaning,
    required this.arabicText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Number section
            SizedBox(
              width: 30,
              child: Text(
                "$number.",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // Name and meaning section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meaning,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Arabic text section
            SizedBox(
              width: 70,
              child: Text(
                arabicText,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 24,
                  height: 1.2,
                ),
              ),
            ),

            // Arrow icon
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}