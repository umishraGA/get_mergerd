import 'package:flutter/material.dart';

import '../screens/BuddhismScreen.dart';
import '../screens/ChristianityScreen.dart';
import '../screens/JainismScreen.dart';
import '../screens/SikhismScreen.dart';
import '../screens/festival_screen.dart';
import '../screens/hinduism_screen.dart';
import '../screens/islam/asma_al_husna/asma_al_husna_screen.dart';
import '../screens/islam/donation/donation_screen.dart';
import '../screens/islam/duas/duas_screen.dart';
import '../screens/islam/islam_screen.dart';
import '../screens/islam/makkah_live/makkah_live_screen.dart';
import '../screens/islam/mosques/mosques_screen.dart';
import '../screens/islam/qibla/qibla_screen.dart';
import '../screens/islam/tasbih/dhikr_list_screen.dart';
import '../screens/islam/tasbih/tasbih_screen.dart';
import '../screens/spiritual_screen.dart';
import '../screens/temples_screen.dart';

class SpiritualRoutes {
  static const String main = '/spiritual';
  static const String hinduism = '/spiritual/hinduism';
  static const String islam = '/spiritual/islam';
  static const String christianity = '/spiritual/christianity';
  static const String buddhism = '/spiritual/buddhism';
  static const String jainism = '/spiritual/jainism';
  static const String sikhism = '/spiritual/sikhism';
  static const String asmaAlHusna = '/spiritual/islam/asma-al-husna';
  static const String asmaNameDetail = '/spiritual/islam/asma-al-husna/detail';
  static const String tasbih = '/spiritual/islam/tasbih';
  static const String dhikrList = '/spiritual/islam/tasbih/dhikr-list';
  static const String qibla = '/spiritual/islam/qibla';
  static const String duas = '/spiritual/islam/duas';
  static const String duaCategory = '/spiritual/islam/duas/category';
  static const String duaDetail = '/spiritual/islam/duas/detail';
  static const String mosques = '/spiritual/islam/mosques';
  static const String donation = '/spiritual/islam/donation';
  static const String makkahLive = '/spiritual/islam/makkah-live';
  static const String temples = '/spiritual/temples';
  static const String templeDetail = '/spiritual/temple/detail';
  static const String festivals = '/spiritual/festivals';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(builder: (_) => const SpiritualScreen());
      case hinduism:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final bannerImage = args['bannerImage'] as String?;
          return MaterialPageRoute(
              builder: (_) => HinduismScreen(bannerImage: bannerImage));
        }
        return MaterialPageRoute(builder: (_) => const HinduismScreen());
      case islam:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final bannerImage = args['bannerImage'] as String?;
          return MaterialPageRoute(
              builder: (_) => IslamScreen(bannerImage: bannerImage));
        }
        return MaterialPageRoute(builder: (_) => const IslamScreen());
      case christianity:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final bannerImage = args['bannerImage'] as String?;
          return MaterialPageRoute(
              builder: (_) => ChristianityScreen(bannerImage: bannerImage));
        }
        return MaterialPageRoute(builder: (_) => const ChristianityScreen());
      case buddhism:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final bannerImage = args['bannerImage'] as String?;
          return MaterialPageRoute(
              builder: (_) => BuddhismScreen(bannerImage: bannerImage));
        }
        return MaterialPageRoute(builder: (_) => const BuddhismScreen());
      case jainism:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final bannerImage = args['bannerImage'] as String?;
          return MaterialPageRoute(
              builder: (_) => JainismScreen(bannerImage: bannerImage));
        }
        return MaterialPageRoute(builder: (_) => const JainismScreen());
      case sikhism:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          final bannerImage = args['bannerImage'] as String?;
          return MaterialPageRoute(
              builder: (_) => SikhismScreen(bannerImage: bannerImage));
        }
        return MaterialPageRoute(builder: (_) => const SikhismScreen());
      case asmaAlHusna:
        return MaterialPageRoute(builder: (_) => const AsmaAlHusnaScreen());
      // case asmaNameDetail:
      //   if (settings.arguments is AsmaAlHusnaName) {
      //     final name = settings.arguments as AsmaAlHusnaName;
      //     return MaterialPageRoute(
      //       builder: (_) => AsmaNameDetailScreen(name: name),
      //     );
      //   }
        return _errorRoute(settings);
      case tasbih:
        return MaterialPageRoute(builder: (_) => const TasbihScreen());
      case dhikrList:
        return MaterialPageRoute(builder: (_) =>  DhikrListScreen());
      case qibla:
        return MaterialPageRoute(builder: (_) => const QiblaScreen());
      case duas:
        return MaterialPageRoute(builder: (_) => const DuasScreen());
      case duaCategory:

        return _errorRoute(settings);
      case duaDetail:
        return _errorRoute(settings);
      case mosques:
        return MaterialPageRoute(builder: (_) =>  MosquesScreen(latitude: 26.838167, longitude: 80.934501,));
      case donation:
        return MaterialPageRoute(builder: (_) => const DonationScreen());
      case makkahLive:
        return MaterialPageRoute(builder: (_) =>  MakkahLiveScreen());
      case temples:
        return MaterialPageRoute(builder: (_) => const TemplesScreen());
      case festivals:
        return MaterialPageRoute(builder: (_) => const FestivalScreen());
      case templeDetail:

        return _errorRoute(settings);
      default:
        return _errorRoute(settings);
    }
  }

  static MaterialPageRoute<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('Error: ${settings.name} route not found or invalid arguments'),
        ),
      ),
    );
  }
}