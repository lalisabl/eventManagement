class Transaction {
  final String id;
  final String userId;
  final double amount;
  final String paymentMethod;
  final String status;
  final String tranxRef;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.tranxRef,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? '',
      status: json['status'] ?? '',
      tranxRef: json['tranxRef'] ?? '',
      createdAt: json.containsKey('createdAt') ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json.containsKey('updatedAt') ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }
}

class Ticket {
  final String id;
  final String eventId;
  final String userId;
  final Transaction transactionId;
  final String email;
  final String firstName;
  final String lastName;
  final String type;
  final double price;
  final String status;
  final String ticketCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  Ticket({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.transactionId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.type,
    required this.price,
    required this.status,
    required this.ticketCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['_id'] ?? '',
      eventId: json['eventId'] ?? '',
      userId: json['userId'] ?? '',
      transactionId: Transaction.fromJson(json['transactionId']),
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      type: json['type'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      ticketCode: json['ticketCode'] ?? '',
      createdAt: json.containsKey('createdAt') ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json.containsKey('updatedAt') ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }
}
