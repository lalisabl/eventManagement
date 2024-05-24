// event_model.dart
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

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      location: json['location'],
      vipTicketsIncluded: json['vipTicketsIncluded'],
      normalTickets: json['normalTickets'],
      normalPrice: json['normalPrice'].toDouble(),
      vipTickets: json['vipTickets'],
      vipPrice: json['vipPrice'].toDouble(),
    );
  }
}
