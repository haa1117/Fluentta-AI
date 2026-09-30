import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class MoreAppEntry {
  const MoreAppEntry({
    required this.name,
    required this.iconAsset,
    required this.androidUrl,
    required this.iosUrl,
  });

  final String name;
  final String iconAsset;
  final String androidUrl;
  final String iosUrl;

  String get storeUrl => !kIsWeb && Platform.isIOS ? iosUrl : androidUrl;
}

/// Other Futurewatch apps shown in Profile > More Apps.
class MoreAppsCatalog {
  static const List<MoreAppEntry> apps = [
    MoreAppEntry(
      name: 'Speaker Cleaner',
      iconAsset: 'assets/images/more_apps/speaker_cleaner.png',
      androidUrl:
          'https://play.google.com/store/apps/details?id=co.fwglobal.speakercleaner',
      iosUrl: 'https://apps.apple.com/app/id6803906586',
    ),
    MoreAppEntry(
      name: 'LedgerWise',
      iconAsset: 'assets/images/more_apps/ledgerwise.png',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.ledgerwise.app&hl=en',
      iosUrl: 'https://apps.apple.com/pk/app/ledger-wise/id6756644842',
    ),
    MoreAppEntry(
      name: 'Minesweeper',
      iconAsset: 'assets/images/more_apps/minesweeper.png',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.futurewatch.minesweeper&hl=en',
      iosUrl:
          'https://apps.apple.com/pk/app/minesweeper-puzzle-game/id6766427737',
    ),
    MoreAppEntry(
      name: 'Pulse',
      iconAsset: 'assets/images/more_apps/pulse.png',
      androidUrl:
          'https://play.google.com/store/apps/details?id=app.pulse.daily&hl=en',
      iosUrl:
          'https://apps.apple.com/pk/app/pulse-burnout-stress-check/id6770918012',
    ),
    MoreAppEntry(
      name: 'Tranquil',
      iconAsset: 'assets/images/more_apps/tranquil.png',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.tranquil.androidtv&hl=en',
      iosUrl: 'https://apps.apple.com/pk/app/tranquil-sleep-relax/id6772150691',
    ),
    MoreAppEntry(
      name: '2D Turbo Racing',
      iconAsset: 'assets/images/more_apps/turbo_racing.png',
      androidUrl:
          'https://play.google.com/store/apps/details?id=co.futurewatch.turborg2d.racing',
      iosUrl:
          'https://apps.apple.com/us/app/turbo-racing-arcade-car-game/id6764758733',
    ),
    MoreAppEntry(
      name: 'SlimTrack',
      iconAsset: 'assets/images/more_apps/slimtrack.png',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.futurewatch.slimtrack',
      iosUrl:
          'https://apps.apple.com/us/app/slim-track-weight-loss-bmi/id6781175781',
    ),
    MoreAppEntry(
      name: 'Volume Booster',
      iconAsset: 'assets/images/more_apps/volume_booster.png',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.volume.soundbooster',
      iosUrl:
          'https://apps.apple.com/us/app/volume-booster-sound-equalizer/id6786739677',
    ),
    MoreAppEntry(
      name: 'Animal Ringtone Sounds & Tones',
      iconAsset: 'assets/images/more_apps/animal_ringtone.png',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.animalringtones.sounds.ringtone&hl=en',
      iosUrl:
          'https://apps.apple.com/us/app/animal-ringtone-sounds-tones/id6786746363',
    ),
    MoreAppEntry(
      name: 'DocReader AI Pro',
      iconAsset: 'assets/images/more_apps/docreader_pro.png',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.docreader.pro&hl=en',
      iosUrl:
          'https://apps.apple.com/us/app/docreader-pro-pdf-doc-view/id6786748623',
    ),
    MoreAppEntry(
      name: 'Resetta',
      iconAsset: 'assets/images/more_apps/resetta.png',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.futurewatch.resetta&hl=en',
      iosUrl: 'https://apps.apple.com/us/app/resetta/id6785867348',
    ),
    MoreAppEntry(
      name: 'Kalendra',
      iconAsset: 'assets/images/more_apps/kalendra.png',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.calendai.calendai',
      iosUrl:
          'https://apps.apple.com/us/app/kalendra-ai-calendar-assistant/id6754331667',
    ),
  ];
}
