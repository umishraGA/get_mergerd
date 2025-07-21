class AsmaAlHusnaName {
  final int number;
  final String name;
  final String meaning;
  final String arabicText;
  final String englishMeaning;
  final String description;
  final String benefits;

  const AsmaAlHusnaName({
    required this.number,
    required this.name,
    required this.meaning,
    required this.arabicText,
    this.englishMeaning = '',
    this.description = '',
    this.benefits = '',
  });
}

class AsmaAlHusnaData {
  static const List<AsmaAlHusnaName> names = [
    AsmaAlHusnaName(
      number: 1,
      name: 'Ar-Rahmān',
      meaning:
          'The Exceedingly Compassionate, The Exceedingly Beneficent, The Exceedingly Gracious',
      arabicText: 'الرَّحْمَنُ',
      englishMeaning: 'THE COMPASSIONATE',
      description:
          'He is the One who wills Mercy and good for all creation, at all times, He pours upon all creation infinite bounties.',
      benefits:
          'If this ism is recited 100 times daily after every salaat, if Allah wills, hard-heartedness, and negligence will be removed from the reader\'s heart.',
    ),
    AsmaAlHusnaName(
      number: 2,
      name: 'Ar-Rahīm',
      meaning: 'The Exceedingly Merciful',
      arabicText: 'الرَّحِيمُ',
      englishMeaning: 'THE MERCIFUL',
      description:
          'The One who acts with extreme kindness, who is continuously merciful. The One whose mercy is perfect, complete, and all-inclusive.',
      benefits:
          'If recited 100 times after Fajr prayer, it is narrated that one will find people responding to them with affection and kindness.',
    ),
    AsmaAlHusnaName(
      number: 3,
      name: 'Al-Malik',
      meaning: 'The King',
      arabicText: 'الْمَلِكُ',
      englishMeaning: 'THE KING',
      description:
          'The Sovereign Lord, The One with complete dominion, the One whose dominion is clear from imperfection.',
      benefits:
          'Reciting this name 1000 times is said to bring independence and dignity.',
    ),
    AsmaAlHusnaName(
      number: 4,
      name: 'Al-Quddūs',
      meaning: 'The Holy, The Pure, The Perfect',
      arabicText: 'الْقُدُّوسُ',
      englishMeaning: 'THE HOLY ONE',
      description:
          'The Pure One, The One who is free from all imperfections and who is perfect in every way.',
      benefits:
          'Reciting this name regularly purifies the heart and soul from worldly attachments.',
    ),
    AsmaAlHusnaName(
      number: 5,
      name: 'As-Salām',
      meaning: 'The Peace, The Source of Peace and Safety, The Savior',
      arabicText: 'السَّلاَمُ',
      englishMeaning: 'THE SOURCE OF PEACE',
      description:
          'The One who is perfect in every way. The One who is free from every imperfection. The Source of Peace and Safety.',
      benefits:
          'For those suffering from fear or anxiety, reciting this name 115 times is said to bring inner peace.',
    ),
    AsmaAlHusnaName(
      number: 6,
      name: 'Al-Mu\'min',
      meaning: 'The Guarantor, The Affirming',
      arabicText: 'الْمُؤْمِنُ',
    ),
    AsmaAlHusnaName(
      number: 7,
      name: 'Al-Muhaymin',
      meaning: 'The Guardian',
      arabicText: 'الْمُهَيْمِنُ',
    ),
    AsmaAlHusnaName(
      number: 8,
      name: 'Al-\'Azīz',
      meaning: 'The Almighty, The Invulnerable',
      arabicText: 'الْعَزِيزُ',
    ),
    AsmaAlHusnaName(
      number: 9,
      name: 'Al-Jabbār',
      meaning: 'The Compeller, The Repairer',
      arabicText: 'الْجَبَّارُ',
    ),
    AsmaAlHusnaName(
      number: 10,
      name: 'Al-Mutakabbir',
      meaning: 'The Greatest',
      arabicText: 'الْمُتَكَبِّرُ',
    ),
    // Add more names as needed
  ];
}
