class Event {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final bool vipTicketsIncluded;
  final int normalTickets;
  final double normalPrice;
  final int vipTickets;
  final double vipPrice;

  Event({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.vipTicketsIncluded,
    required this.normalTickets,
    required this.normalPrice,
    required this.vipTickets,
    required this.vipPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'vipTicketsIncluded': vipTicketsIncluded,
      'normalTickets': normalTickets,
      'normalPrice': normalPrice,
      'vipTickets': vipTickets,
      'vipPrice': vipPrice,
    };
  }
}
