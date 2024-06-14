class Event {
  final String id;
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
  final bool favorite;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.thumbnail,
    required this.location,
    required this.vipTicketsIncluded,
    required this.normalTickets,
    required this.normalPrice,
    required this.favorite,
    required this.vipTickets,
    required this.vipPrice,
    required this.normalTicketsAvailable,
    required this.vipTicketsAvailable,
    required this.organiserId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      favorite: json['favorite'] ?? false,
      description: json['description'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      thumbnail: json['thumbnail'] ?? '',
      location: json['location'] ?? '',
      vipTicketsIncluded: json['vipTicketsIncluded'] ?? false,
      normalTickets: json['normalTickets'] ?? 0,
      normalPrice: (json['normalPrice'] ?? 0).toDouble(),
      vipTickets: json['vipTickets'] ?? 0,
      vipPrice: (json['vipPrice'] ?? 0).toDouble(),
      normalTicketsAvailable: json['normalTicketsAvailable'] ?? 0,
      vipTicketsAvailable: json['vipTicketsAvailable'] ?? 0,
      organiserId: json['organiserId'] ?? '',
    );
  }
}
