class Transaction {
  int transactionId;
  int idAccount;
  int idUser;
  String refTransId;
  String transactionType;
  double? debit;
  double? credit;
  double? balance;
  int idUserFrom;
  int idUserTo;
  int deleted;
  DateTime createdAt;
  DateTime updatedAt;
  int status;

  Transaction({
    required this.transactionId,
    required this.idAccount,
    required this.idUser,
    required this.refTransId,
    required this.transactionType,
    this.debit,
    this.credit,
    this.balance,
    required this.idUserFrom,
    required this.idUserTo,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transaction_id'] as int,
      idAccount: json['id_account'] as int,
      idUser: json['id_user'] as int,
      refTransId: json['ref_trans_id'] as String,
      transactionType: json['transaction_type'] as String,
      debit: json['debit'] != null ? (json['debit'] as num?)?.toDouble() : null,
      credit: json['credit'] != null ? (json['credit'] as num?)?.toDouble() : null,
      balance: json['balance'] != null ? (json['balance'] as num?)?.toDouble() : null,
      idUserFrom: json['id_user_from'] as int,
      idUserTo: json['id_user_to'] as int,
      deleted: json['deleted'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      status: json['status'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'id_account': idAccount,
      'id_user': idUser,
      'ref_trans_id': refTransId,
      'transaction_type': transactionType,
      'debit': debit,
      'credit': credit,
      'balance': balance,
      'id_user_from': idUserFrom,
      'id_user_to': idUserTo,
      'deleted': deleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
    };
  }
}
