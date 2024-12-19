class UserTotals {
  final double? total;
  final List<Transaction> history;

  UserTotals({required this.total, required this.history});

  factory UserTotals.fromJson(Map<String, dynamic> json) {
    return UserTotals(
      total: (json['total'] as num).toDouble(), // Conversion en double

      history: (json['history'] as List<dynamic>)
          .map((item) => Transaction.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'history': history.map((transaction) => transaction.toJson()).toList(),
    };
  }
}

class Transaction {
  final String type;
  final String category;
  final double amount;
  final DateTime acquisitionDate;

  Transaction({
    required this.type,
    required this.category,
    required this.amount,
    required this.acquisitionDate,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'],
      category: json['category'],
      amount: (json['amount'] as num).toDouble(), // Conversion en double
      acquisitionDate: DateTime.parse(json['acquisitionDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'category': category,
      'amount': amount,
      'acquisitionDate': acquisitionDate.toIso8601String(),
    };
  }
}
