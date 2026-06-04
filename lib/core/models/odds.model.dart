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
  final String answer;

  QuestionRoll({
    required this.question,
    required this.likelihood,
    required this.roll,
    required this.answer,
  });

  Map<String, dynamic> toJson() => {
        'question': question,
        'likelihood': likelihood,
        'roll': roll,
        'answer': answer,
      };

  factory QuestionRoll.fromJson(Map<String, dynamic> json) => QuestionRoll(
        question: json['question'] as String,
        likelihood: json['likelihood'] as String,
        roll: json['roll'] as int,
        answer: json['answer'] as String,
      );
}
