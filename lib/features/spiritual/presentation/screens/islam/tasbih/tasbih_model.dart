class TasbihDhikr {
  final String id;
  final String arabicText;
  final String transliteration;
  final String meaning;
  final int goalCount;
  final bool isFavorite;

  const TasbihDhikr({
    required this.id,
    required this.arabicText,
    required this.transliteration,
    required this.meaning,
    this.goalCount = 33,
    this.isFavorite = false,
  });
}

class TasbihData {
  static const List<TasbihDhikr> dhikrs = [
    TasbihDhikr(
      id: '1',
      arabicText: 'لَا إِلٰهَ إِلَّا الله',
      transliteration: 'La ilaha illa Allah',
      meaning: 'There is no god except Allah',
      goalCount: 33,
    ),
    TasbihDhikr(
      id: '2',
      arabicText: 'سُبْحَانَ اللهِ',
      transliteration: 'Subhan Allah',
      meaning: 'Glory be to Allah',
      goalCount: 33,
    ),
    TasbihDhikr(
      id: '3',
      arabicText: 'اَلْحَمْدُ لِلّٰهِ',
      transliteration: 'Alhamdulillah',
      meaning: 'All praise is due to Allah',
      goalCount: 33,
    ),
    TasbihDhikr(
      id: '4',
      arabicText: 'اللهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      meaning: 'Allah is the Greatest',
      goalCount: 33,
    ),
    TasbihDhikr(
      id: '5',
      arabicText: 'أَسْتَغْفِرُ اللّٰهَ',
      transliteration: 'Astaghfirullah',
      meaning: 'I seek forgiveness from Allah',
      goalCount: 33,
    ),
    TasbihDhikr(
      id: '6',
      arabicText: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ',
      transliteration: 'La hawla wa la quwwata illa billah',
      meaning: 'There is no might nor power except with Allah',
      goalCount: 33,
    ),
    TasbihDhikr(
      id: '7',
      arabicText: 'حَسْبُنَا اللهُ وَنِعْمَ الْوَكِيلُ',
      transliteration: 'Hasbunallahu wa ni\'mal wakeel',
      meaning: 'Allah is sufficient for us, and He is the Best Guardian',
      goalCount: 33,
    ),
    TasbihDhikr(
      id: '8',
      arabicText: 'سُبْحَانَ اللهِ وَ بِحَمْدِهِ، سُبْحَانَ اللهِ الْعَظِيمْ',
      transliteration: 'Subhan Allahi wa bi Hamdihi, Subhan Allahil Adhim',
      meaning:
          'Allah is free from imperfections and all praise is due to Him, Allah is The Greatest',
      goalCount: 33,
    ),
  ];
}
