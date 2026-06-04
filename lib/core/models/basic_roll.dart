class BasicRoll {
  final String response;
  final int roll;

  BasicRoll({required this.response, required this.roll});

  Map<String, dynamic> toJson() => {'response': response, 'roll': roll};

  factory BasicRoll.fromJson(Map<String, dynamic> json) =>
      BasicRoll(response: json['response'] as String, roll: json['roll'] as int);
}
