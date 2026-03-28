class TransactionsHistory {
  List<String> periods;
  Transactions transactions;

  TransactionsHistory({
    List<String>? periods,
    Transactions? transactions,
  })  : periods = periods ?? <String>[],
        transactions = transactions ?? Transactions(count: 0, rows: const []);

  TransactionsHistory.fromJson(Map<String, dynamic> json)
      : periods = (json['periods'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            <String>[],
        // Handle BOTH shapes:
        transactions = (() {
          final tx = json['transactions'];
          final topCount = json['count'];

          if (tx is Map<String, dynamic>) {
            // { count: X, rows: [...] }
            return Transactions.fromJson(tx);
          } else if (tx is List) {
            // [ ... ] with a separate 'count' on the same level
            return Transactions(count: (topCount is int) ? topCount : tx.length, rows: tx);
          } else {
            // nothing / unknown
            return Transactions(count: topCount is int ? topCount : 0, rows: const []);
          }
        })();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'periods': periods,                 // just return the list
      'transactions': transactions.toJson(),
    };
  }
}

class Transactions {
  int count;
  List<dynamic> rows;

  Transactions({required this.count, required this.rows});

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      count: (json['count'] is int)
          ? json['count'] as int
          : (json['count'] is num)
              ? (json['count'] as num).toInt()
              : (json['rows'] is List ? (json['rows'] as List).length : 0),
      rows: (json['rows'] as List?) ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'count': count,
      'rows': rows, // rows are already maps/objects; no .toJson() here
    };
  }
}