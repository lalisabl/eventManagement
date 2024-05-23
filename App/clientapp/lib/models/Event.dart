// event_model.dart
class Event {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String thumbnail;
  final String location;
  final bool vipTicketsIncluded;
  final int normalTickets;
  final double normalPrice;
  final int vipTickets;
  final double vipPrice;
  final int normalTicketsAvailable;
  final int vipTicketsAvailable;
  final String organiserId;

  Event({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.thumbnail,
    required this.location,
    required this.vipTicketsIncluded,
    required this.normalTickets,
    required this.normalPrice,
    required this.vipTickets,
    required this.vipPrice,
    required this.normalTicketsAvailable,
    required this.vipTicketsAvailable,
    required this.organiserId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      thumbnail: json['thumbnail'],
      location: json['location'],
      vipTicketsIncluded: json['vipTicketsIncluded'],
      normalTickets: json['normalTickets'],
      normalPrice: json['normalPrice'].toDouble(),
      vipTickets: json['vipTickets'],
      vipPrice: json['vipPrice'].toDouble(),
      normalTicketsAvailable: json['normalTicketsAvailable'],
      vipTicketsAvailable: json['vipTicketsAvailable'],
      organiserId: json['organiserId'],
    );
  }
}
