class VerbRoll {
  int verb1Roll;
  int verb2Roll;
  int verb3Roll;
  int actionRoll;
  int subjectRoll;
  String verb1;
  String verb2;
  String verb3;
  String action;
  String subject;

  VerbRoll({
    required this.verb1Roll,
    required this.verb2Roll,
    required this.verb3Roll,
    required this.actionRoll,
    required this.subjectRoll,
    required this.verb1,
    required this.verb2,
    required this.verb3,
    required this.action,
    required this.subject,
  });

  Map<String, dynamic> toJson() => {
        'verb1': verb1,
        'verb2': verb2,
        'verb3': verb3,
        'action': action,
        'subject': subject,
        'verb1Roll': verb1Roll,
        'verb2Roll': verb2Roll,
        'verb3Roll': verb3Roll,
        'actionRoll': actionRoll,
        'subjectRoll': subjectRoll,
      };

  factory VerbRoll.fromJson(Map<String, dynamic> json) => VerbRoll(
        verb1: json['verb1'] as String,
        verb2: json['verb2'] as String,
        verb3: json['verb3'] as String,
        action: json['action'] as String,
        subject: json['subject'] as String,
        verb1Roll: json['verb1Roll'] as int,
        verb2Roll: json['verb2Roll'] as int,
        verb3Roll: json['verb3Roll'] as int,
        actionRoll: json['actionRoll'] as int,
        subjectRoll: json['subjectRoll'] as int,
      );
}
