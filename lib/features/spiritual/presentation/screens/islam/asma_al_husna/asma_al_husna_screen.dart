import 'package:flutter/material.dart';

import 'asma_al_husna_model.dart';

class AsmaAlHusnaScreen extends StatefulWidget {
  const AsmaAlHusnaScreen({super.key});

  @override
  State<AsmaAlHusnaScreen> createState() => _AsmaAlHusnaScreenState();
}

class _AsmaAlHusnaScreenState extends State<AsmaAlHusnaScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AsmaAlHusnaName> _filteredNames = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredNames = AsmaAlHusnaData.names;
    _searchController.addListener(_filterNames);
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
        _filteredNames = AsmaAlHusnaData.names;
      } else {
        _filteredNames = AsmaAlHusnaData.names.where((name) {
          return name.name.toLowerCase().contains(query) ||
              name.meaning.toLowerCase().contains(query) ||
              name.number.toString().contains(query);
        }).toList();
      }
    });
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
                ),
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
              setState(() {
                _isSearching = false;
                _searchController.clear();
                _filteredNames = AsmaAlHusnaData.names;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.search_off : Icons.search,
              color: Colors.green,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filteredNames = AsmaAlHusnaData.names;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.green,
              size: 20,
            ),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: _filteredNames.isEmpty
          ? const Center(
              child: Text(
                'No results found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _filteredNames.length,
              itemBuilder: (context, index) {
                final name = _filteredNames[index];
                return _NameCard(
                  number: name.number,
                  name: name.name,
                  meaning: name.meaning,
                  arabicText: name.arabicText,
                  onTap: () {
                    _showNameDetails(context, name);
                  },
                );
              },
            ),
    );
  }

  void _showNameDetails(BuildContext context, AsmaAlHusnaName name) {
    Navigator.pushNamed(
      context,
      '/spiritual/islam/asma-al-husna/detail',
      arguments: name,
    );
  }
}

class _NameCard extends StatelessWidget {
  final int number;
  final String name;
  final String meaning;
  final String arabicText;
  final VoidCallback onTap;

  const _NameCard({
    super.key,
    required this.number,
    required this.name,
    required this.meaning,
    required this.arabicText,
    required this.onTap,
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
      child: InkWell(
        onTap: onTap,
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
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CircleButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.green.shade700,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
