class Odds {
  final int odds;
  final String title;

  Odds({required this.odds, required this.title});

  factory Odds.fromJson(Map<dynamic, dynamic> json) =>
      Odds(odds: json['odds'] as int, title: json['title'] as String);
}

class QuestionRoll {
  final String question;
  final String likelihood;
  final int roll;
  final int target;
  final String answer;

  QuestionRoll({
    required this.question,
    required this.likelihood,
    required this.roll,
    required this.target,
    required this.answer,
  });

  Map<String, dynamic> toJson() => {
        'question': question,
        'likelihood': likelihood,
        'roll': roll,
        'target': target,
        'answer': answer,
      };

  factory QuestionRoll.fromJson(Map<String, dynamic> json) => QuestionRoll(
        question: json['question'] as String,
        likelihood: json['likelihood'] as String,
        roll: json['roll'] as int,
        target: json['target'] as int? ?? 50,
        answer: json['answer'] as String,
      );
}
