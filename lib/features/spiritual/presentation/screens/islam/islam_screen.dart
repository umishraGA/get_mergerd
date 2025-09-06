import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/spiritual/presentation/Islam_controller/islam_home_controller.dart';
import 'package:myapp/features/spiritual/presentation/screens/islam/quran_chapter/chapter_list.dart';
import 'asma_al_husna/asma_al_husna_screen.dart';
import 'mosques/mosques_screen.dart';

class IslamScreen extends StatefulWidget {
  final String? bannerImage;

  const IslamScreen({super.key, this.bannerImage});

  @override
  State<IslamScreen> createState() => _IslamScreenState();
}

class _IslamScreenState extends State<IslamScreen> {
  final IslamController islamController = Get.put(IslamController());
  late String _bannerImage;
  String _selectedPrayer = 'Asr';
  final String _location = 'Lucknow, India';

  final Map<String, Map<String, dynamic>> _prayerTimes = {
    'Fajr': {'time': '03:56', 'isSelected': false},
    'Dhuhr': {'time': '12:08', 'isSelected': false},
    'Asr': {'time': '15:42', 'isSelected': true},
    'Maghrib': {'time': '18:44', 'isSelected': false},
    'Isha': {'time': '20:09', 'isSelected': false},
  };

  @override
  void initState() {
    super.initState();
    _bannerImage = widget.bannerImage ??
        'assets/images/spiritual/backgrounds/islam_bg.png';
    islamController.fetchIslamData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D5240),
      body: Obx(() {
        if (islamController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // App Bar with background
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: const Color(0xFF2D5240),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  _bannerImage,
                  fit: BoxFit.cover,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ),
              title: const Text(
                'Islam',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                child: Column(
                  children: [
                    // Prayer Times Card
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A5F2A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            _location,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _prayerTimes.entries.map((entry) {
                              final name = entry.key;
                              final time = entry.value['time'] as String;
                              final isSelected = name == _selectedPrayer;

                              return _PrayerTimeWidget(
                                name: name,
                                time: time,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    _selectedPrayer = name;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tuesday, 8 Dhu\'Q 1446H',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              Text(
                                '6 May 2025',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    // Featured Grid
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Featured',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GridView.builder(
                            itemCount: islamController.featuredList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final item = islamController.featuredList[index];

                              return GestureDetector(
                                onTap: () {
                                  final name = item["name"];
                                  switch (name) {
                                    case "sifat":
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AsmaAlHusnaScreen()));
                                      break;
                                    case "tasbih":
                                      Navigator.pushNamed(
                                          context, "/spiritual/islam/tasbih");
                                      break;
                                    case "qibla":
                                      Navigator.pushNamed(
                                          context, "/spiritual/islam/qibla");
                                      break;
                                    case "dua":
                                      Navigator.pushNamed(
                                          context, "/spiritual/islam/duas");
                                      break;
                                    case "mosque":
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MosquesScreen(
                                                    latitude: 26.838167,
                                                    longitude: 80.934501,
                                                  )));
                                      break;
                                    case "maqaah_live":
                                      Navigator.pushNamed(context,
                                          "/spiritual/islam/makkah-live");
                                      break;
                                    case "allah_name":
                                      Navigator.pushNamed(context,
                                          "/spiritual/islam/allahNames");
                                      break;
                                    case "quran_chapter":
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  QuranChaptersPage()));

                                      break;
                                    default:
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "No route found for this feature")),
                                      );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.green.shade100),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        item["mobile_image"].toString(),
                                        width: 80,
                                        height: 80,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item["name"].toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Donation Banner
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => Navigator.pushNamed(
                              context, '/spiritual/islam/donation'),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.volunteer_activism,
                                    color: Colors.green.shade600, size: 32),
                                const SizedBox(height: 8),
                                const Text(
                                  'Support Our Mosques',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Donate to help Islamic community initiatives',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _PrayerTimeWidget extends StatelessWidget {
  final String name;
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  const _PrayerTimeWidget({
    required this.name,
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconForPrayer(name),
              color: isSelected ? const Color(0xFF1A5F2A) : Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF1A5F2A) : Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? const Color(0xFF1A5F2A) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForPrayer(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Icons.wb_twilight_outlined;
      case 'Dhuhr':
        return Icons.wb_sunny_outlined;
      case 'Asr':
        return Icons.cloud_outlined;
      case 'Maghrib':
        return Icons.wb_twilight_outlined;
      case 'Isha':
        return Icons.nightlight_outlined;
      default:
        return Icons.access_time;
    }
  }
}