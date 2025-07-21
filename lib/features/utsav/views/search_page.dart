import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';
import '../widgets/AppHeader.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            AppHeader(
              title: 'Search',
              showMenu: false,
              showShare: false,
              showSearch: false,
              onBackPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: _SearchContent(
                  searchController: _searchController,
                  searchFocusNode: _searchFocusNode),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchContent extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;

  const _SearchContent({
    required this.searchController,
    required this.searchFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              controller: searchController,
              focusNode: searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search...',
                focusedBorder: InputBorder.none,
                hintStyle: const TextStyle(
                  color: Colors.transparent,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Color(0xFFBB9F9F)),
                  onPressed: () {
                    searchController.clear();
                    context.read<SearchProvider>().clearSearch();
                  },
                ),
              ),
              onChanged: (value) {
                context.read<SearchProvider>().search(value);
              },
            ),
          ),
        ),
        Expanded(
          child: Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              if (searchProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (searchProvider.searchResults.isEmpty) {
                return const Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(
                      color: Color(0xFF909090),
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: searchProvider.searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchProvider.searchResults[index];
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
                        result.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        result.subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF909090),
                        ),
                      ),
                      onTap: () {
                        // Handle item selection
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
