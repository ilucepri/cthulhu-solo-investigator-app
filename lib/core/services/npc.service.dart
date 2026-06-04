import 'package:cthulhu_solo_investigator_app/core/models/npc.model.dart';
import 'package:cthulhu_solo_investigator_app/core/services/json.service.dart';
import 'package:cthulhu_solo_investigator_app/core/services/utils.service.dart';

class NPCService {
  final JSONService _jsonService = JSONService();
  final UtilsService _utilsService = UtilsService();

  Future<NPC> getNPCRoll(String genderSelected) async {
    final String gender = genderSelected != "Random" ? genderSelected : _rollGender();
    final String name = gender == "Mujer" ? await getNameFemale() : await getNameMale();
    final String surname = await getSurname();
    return NPC(
      job: await getJob(),
      gender: gender,
      fullName: '$name $surname',
      adjective: await getAdjective(),
    );
  }

  String _rollGender() => _utilsService.getRandomInt(2) == 0 ? "Mujer" : "Hombre";

  Future<String> _pickFrom(String path) async {
    final list = await _jsonService.getStringList(path);
    return list[_utilsService.getRandomInt(list.length)];
  }

  Future<String> getJob() => _pickFrom('assets/data_base/npc_jobs.json');
  Future<String> getAdjective() => _pickFrom('assets/data_base/npc_adjectives.json');
  Future<String> getNameMale() => _pickFrom('assets/data_base/npc_names_male.json');
  Future<String> getNameFemale() => _pickFrom('assets/data_base/npc_names_female.json');
  Future<String> getSurname() => _pickFrom('assets/data_base/npc_surnames.json');
}
