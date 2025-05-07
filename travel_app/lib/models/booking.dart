class Booking {
  final String flight;
  final String hotel;
  final String cab;
  final double totalCost;

  const Booking({
    required this.flight,
    required this.hotel,
    required this.cab,
    required this.totalCost,
  });

  Map<String, dynamic> toJson() => {
        'flight': flight,
        'hotel': hotel,
        'cab': cab,
        'totalCost': totalCost,
      };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        flight: json['flight'] as String,
        hotel: json['hotel'] as String,
        cab: json['cab'] as String,
        totalCost: json['totalCost'] as double,
      );
} 