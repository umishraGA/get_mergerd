// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'chatgptcode1.dart';
//
// class CategoryListScreen extends StatelessWidget {
//   final List<CategoryModel>? categories;
//
//   // if categories is null → root categories from controller
//   CategoryListScreen({super.key, this.categories});
//
//   final CategoryController controller = Get.put(CategoryController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Categories")),
//       body: Obx(() {
//         final list = categories ?? controller.categories;
//
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (list.isEmpty) {
//           return const Center(child: Text("No categories found"));
//         }
//
//         return ListView.builder(
//           itemCount: list.length,
//           itemBuilder: (context, index) {
//             final item = list[index];
//             return ListTile(
//               leading: item.bannerImage != null
//                   ? Image.network(item.bannerImage!, width: 50, height: 50, fit: BoxFit.cover)
//                   : const Icon(Icons.category),
//               title: Text(item.name),
//               trailing: item.children.isNotEmpty
//                   ? const Icon(Icons.arrow_forward_ios, size: 16)
//                   : null,
//               onTap: () {
//                 if (item.children.isNotEmpty) {
//                   // navigate to next level
//                   Get.to(() => CategoryListScreen(categories: item.children));
//                 } else {
//                   // navigate to main page
//                   Get.to(() => const MainPage());
//                 }
//               },
//             );
//           },
//         );
//       }),
//     );
//   }
// }
//
// class MainPage extends StatelessWidget {
//   const MainPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Main Page")),
//       body: const Center(child: Text("This is main page")),
//     );
//   }
// }
