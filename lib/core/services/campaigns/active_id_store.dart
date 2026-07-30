import 'package:shared_preferences/shared_preferences.dart';

/// El expediente activo es contextual al dispositivo: cada móvil recuerda
/// dónde estabas la última vez que abriste la app, sin sincronizar.
class ActiveIdStore {
  static const _key = 'campaigns.activeId.v1';

  Future<String?> load() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_key);
  }

  Future<void> set(String? id) async {
    final sp = await SharedPreferences.getInstance();
    if (id == null) {
      await sp.remove(_key);
    } else {
      await sp.setString(_key, id);
    }
  }
}
