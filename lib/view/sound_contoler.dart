// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';
//
// class SoundController {
//   SoundController._internal();
//   static final SoundController instance = SoundController._internal();
//
//   final AudioPlayer _sfxPlayer = AudioPlayer();
//   final AudioPlayer _gallopPlayer = AudioPlayer();
//
//   bool _isInitialized = false;
//
//   Future<void> ensureInitialized() async {
//     if (_isInitialized) return;
//     try {
//       // 🎯 Dono players ko allow karo ki ek sath coexist kar sakein (Audio Focus steal na ho)
//       await AudioPlayer.global.setAudioContext(AudioContext(
//         android: const AudioContextAndroid(
//           isSpeakerphoneOn: true,
//           stayAwake: true,
//           contentType: AndroidContentType.sonification,
//           usageType: AndroidUsageType.game,
//           audioFocus: AndroidAudioFocus.none, // 👈 Critical: Ek dusre ko cut nahi karenge!
//         ),
//         iOS: AudioContextIOS(
//           category: AVAudioSessionCategory.ambient, // 👈 Background sound ke sath mix hoga
//         ),
//       ));
//
//       await _sfxPlayer.setPlayerMode(PlayerMode.mediaPlayer); // Full buffer mode
//       await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
//
//       await _gallopPlayer.setPlayerMode(PlayerMode.mediaPlayer);
//       await _gallopPlayer.setReleaseMode(ReleaseMode.loop);
//
//       _isInitialized = true;
//     } catch (e) {
//       if (kDebugMode) print("Sound Init Error: $e");
//     }
//   }
//
//   // 1. Race Start: Pura bajega, beech me band nahi hoga
//   Future<void> playRaceStart({VoidCallback? onComplete}) async {
//     try {
//       await _sfxPlayer.stop();
//
//       // Listener: Jaise hi neigh sound POORA khatam hoga, tab callback trigger hoga
//       _sfxPlayer.onPlayerComplete.first.then((_) {
//         if (onComplete != null) {
//           onComplete();
//         }
//       });
//
//       await _sfxPlayer.play(AssetSource('SOUND/dragon-studio-horse-neigh-390297.mp3'));
//     } catch (e) {
//       if (kDebugMode) print("Start Neigh Sound Error: $e");
//       onComplete?.call(); // Fail-safe
//     }
//   }
//
//   // 2. Galloping Loop
//   Future<void> startGallopLoop() async {
//     try {
//       await _gallopPlayer.setVolume(1.0);
//       await _gallopPlayer.setReleaseMode(ReleaseMode.loop);
//       await _gallopPlayer.play(AssetSource('SOUND/pwlpl-horses-galloping-sound-effect-359257.mp3'));
//     } catch (e) {
//       debugPrint("Gallop Loop Error: $e");
//     }
//   }
//
//   void stopGallopLoop() {
//     try {
//       _gallopPlayer.stop();
//     } catch (e) {
//       if (kDebugMode) print("Stop Gallop Error: $e");
//     }
//   }
//
//   // 3. Race Finish / Photo Click
//   Future<void> playWinSound() async {
//     try {
//       await _gallopPlayer.stop(); // Ghoda daudna band
//       await _sfxPlayer.stop();
//       await _sfxPlayer.play(AssetSource('SOUND/SCREESHOTCAPTURE.mp3'));
//     } catch (e) {
//       if (kDebugMode) print("Win Sound Error: $e");
//     }
//   }
//
//   void stopAll() {
//     try {
//       _sfxPlayer.stop();
//       _gallopPlayer.stop();
//     } catch (e) {
//       if (kDebugMode) print("Stop All Error: $e");
//     }
//   }
// }


import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundController {
  SoundController._internal();
  static final SoundController instance = SoundController._internal();

  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _gallopPlayer = AudioPlayer();

  bool _isInitialized = false;

  // Live Volume States
  bool isMasterMuted = false;
  double masterVolume = 1.0;
  double alertsVolume = 1.0;
  double chipsVolume = 0.8;
  double horsesVolume = 0.9;

  Future<void> ensureInitialized() async {
    if (_isInitialized) return;
    try {
      // 🎯 AudioContext: Android media stream + iOS playback mixing fix
      await AudioPlayer.global.setAudioContext(AudioContext(
        android: const AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: false,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.none,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback, // 👈 'ambient' crash kar raha tha, 'playback' se mixWithOthers perfectly work karega
          options: const {AVAudioSessionOptions.mixWithOthers},
        ),
      ));

      await _sfxPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);

      await _gallopPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _gallopPlayer.setReleaseMode(ReleaseMode.loop);

      // Initial Volumes sync
      await _sfxPlayer.setVolume(_getEffectiveVolume(alertsVolume));
      await _gallopPlayer.setVolume(_getEffectiveVolume(horsesVolume));

      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) print("Sound Init Error: $e");
    }
  }

  // Helper to compute effective volume
  double _getEffectiveVolume(double channelVolume) {
    if (isMasterMuted) return 0.0;
    return (channelVolume * masterVolume).clamp(0.0, 1.0);
  }

  // Async Live Volume Setters
  Future<void> setMasterMute(bool mute) async {
    isMasterMuted = mute;
    final alertVol = mute ? 0.0 : _getEffectiveVolume(alertsVolume);
    final horseVol = mute ? 0.0 : _getEffectiveVolume(horsesVolume);

    await Future.wait([
      _sfxPlayer.setVolume(alertVol),
      _gallopPlayer.setVolume(horseVol),
    ]);
  }

  Future<void> setAlertsVolume(double vol) async {
    alertsVolume = vol;
    final effectiveVol = _getEffectiveVolume(alertsVolume);
    await _sfxPlayer.setVolume(effectiveVol);
  }

  void setChipsVolume(double vol) {
    chipsVolume = vol;
  }

  Future<void> setHorsesVolume(double vol) async {
    horsesVolume = vol;
    final effectiveVol = _getEffectiveVolume(horsesVolume);
    await _gallopPlayer.setVolume(effectiveVol); // Live gallop sound adjustment
  }

  // 1. Race Start: Horse Neigh
  Future<void> playRaceStart({VoidCallback? onComplete}) async {
    if (isMasterMuted) {
      onComplete?.call();
      return;
    }
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(_getEffectiveVolume(horsesVolume));

      _sfxPlayer.onPlayerComplete.first.then((_) {
        onComplete?.call();
      });

      await _sfxPlayer.play(AssetSource('SOUND/dragon-studio-horse-neigh-390297.mp3'));
    } catch (e) {
      if (kDebugMode) print("Start Neigh Error: $e");
      onComplete?.call();
    }
  }

  // 2. Galloping Loop
  Future<void> startGallopLoop() async {
    if (isMasterMuted) return;
    try {
      await _gallopPlayer.setVolume(_getEffectiveVolume(horsesVolume));
      await _gallopPlayer.setReleaseMode(ReleaseMode.loop);
      await _gallopPlayer.play(AssetSource('SOUND/pwlpl-horses-galloping-sound-effect-359257.mp3'));
    } catch (e) {
      debugPrint("Gallop Loop Error: $e");
    }
  }

  void stopGallopLoop() {
    try {
      _gallopPlayer.stop();
    } catch (e) {
      if (kDebugMode) print("Stop Gallop Error: $e");
    }
  }

  // 3. Race Finish / Photo Click
  Future<void> playWinSound() async {
    try {
      await _gallopPlayer.stop();
      if (isMasterMuted) return;
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(_getEffectiveVolume(alertsVolume));
      await _sfxPlayer.play(AssetSource('SOUND/SCREESHOTCAPTURE.mp3'));
    } catch (e) {
      if (kDebugMode) print("Win Sound Error: $e");
    }
  }

  void stopAll() {
    try {
      _sfxPlayer.stop();
      _gallopPlayer.stop();
    } catch (e) {
      if (kDebugMode) print("Stop All Error: $e");
    }
  }
}