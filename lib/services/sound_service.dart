import '../models/sound_settings_model.dart';

class SoundService {
  SoundService._();

  static Future<void> init() async {}

  static Future<void> playTap({
    required SoundSettings settings,
  }) async {}

  static Future<void> playVegTap({
    required SoundSettings settings,
  }) async {}

  static Future<void> playCursorMove({
    required SoundSettings settings,
  }) async {}

  static Future<void> playRemove({
    required SoundSettings settings,
  }) async {}

  static Future<void> playError({
    required SoundSettings settings,
  }) async {}

  static Future<void> click(
    SoundSettings settings,
  ) async {}

  static Future<void> add(
    SoundSettings settings,
  ) async {}

  static Future<void> playCursor(
    SoundSettings settings,
  ) async {}

  static Future<void> remove(
    SoundSettings settings,
  ) async {}

  static Future<void> error(
    SoundSettings settings,
  ) async {}

  static Future<void> stop() async {}

  static Future<void> dispose() async {}
}