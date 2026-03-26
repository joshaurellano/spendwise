class Expense {
  final String id;
  String title;
  double amount;
  DateTime date;
  String category;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Expense copyWith({
    String? title,
    double? amount,
    DateTime? date,
    String? category,
  }) {
    return Expense(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }

  // Convert Expense to a Map for SQLite insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  // Create an Expense from a SQLite Map row
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String),
      category: map['category'] as String,
    );
  }
}