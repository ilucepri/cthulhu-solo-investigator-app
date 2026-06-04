class SceneRoll {
  final String type;
  final String response;
  final int roll;

  SceneRoll({required this.type, required this.response, required this.roll});

  Map<String, dynamic> toJson() => {'type': type, 'response': response, 'roll': roll};

  factory SceneRoll.fromJson(Map<String, dynamic> json) => SceneRoll(
        type: json['type'] as String,
        response: json['response'] as String,
        roll: json['roll'] as int,
      );
}
