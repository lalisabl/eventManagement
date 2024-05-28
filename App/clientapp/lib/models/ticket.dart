// lib/models/ticket.dart
class Ticket {
  final String id;
  final String eventId;
  final String userId;
  final String transactionId;
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
      id: json['_id'],
      eventId: json['eventId'],
      userId: json['userId'],
      transactionId: json['transactionId'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      type: json['type'],
      price: json['price'].toDouble(),
      status: json['status'],
      ticketCode: json['ticketCode'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
