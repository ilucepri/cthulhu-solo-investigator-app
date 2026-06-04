class NPC {
  String job;
  String fullName;
  String gender;
  String adjective;

  NPC({
    required this.job,
    required this.fullName,
    required this.gender,
    required this.adjective,
  });

  Map<String, dynamic> toJson() => {
        'job': job,
        'fullName': fullName,
        'gender': gender,
        'adjective': adjective,
      };

  factory NPC.fromJson(Map<String, dynamic> json) => NPC(
        job: json['job'] as String,
        fullName: json['fullName'] as String,
        gender: json['gender'] as String,
        adjective: json['adjective'] as String,
      );
}
