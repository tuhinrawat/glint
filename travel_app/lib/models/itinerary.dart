class Itinerary {
  final String destination;
  final List<Map<String, dynamic>> days;
  final double totalCost;
  final String travelType;
  final int groupSize;
  final DateTime startDate;
  final Map<String, dynamic>? flightDetails;
  final Map<String, dynamic>? hotelDetails;
  final Map<String, dynamic>? cabDetails;

  const Itinerary({
    required this.destination,
    required this.days,
    required this.totalCost,
    required this.travelType,
    required this.groupSize,
    required this.startDate,
    this.flightDetails,
    this.hotelDetails,
    this.cabDetails,
  });

  Map<String, dynamic> toJson() => {
        'destination': destination,
        'days': days,
        'totalCost': totalCost,
        'travelType': travelType,
        'groupSize': groupSize,
        'startDate': startDate.toIso8601String(),
        'flightDetails': flightDetails,
        'hotelDetails': hotelDetails,
        'cabDetails': cabDetails,
      };

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
        destination: json['destination'] as String,
        days: List<Map<String, dynamic>>.from(json['days'] as List),
        totalCost: json['totalCost'] as double,
        travelType: json['travelType'] as String,
        groupSize: json['groupSize'] as int,
        startDate: DateTime.parse(json['startDate'] as String),
        flightDetails: json['flightDetails'] as Map<String, dynamic>?,
        hotelDetails: json['hotelDetails'] as Map<String, dynamic>?,
        cabDetails: json['cabDetails'] as Map<String, dynamic>?,
      );

  Itinerary copyWith({
    String? destination,
    List<Map<String, dynamic>>? days,
    double? totalCost,
    String? travelType,
    int? groupSize,
    DateTime? startDate,
    Map<String, dynamic>? flightDetails,
    Map<String, dynamic>? hotelDetails,
    Map<String, dynamic>? cabDetails,
  }) {
    return Itinerary(
      destination: destination ?? this.destination,
      days: days ?? this.days,
      totalCost: totalCost ?? this.totalCost,
      travelType: travelType ?? this.travelType,
      groupSize: groupSize ?? this.groupSize,
      startDate: startDate ?? this.startDate,
      flightDetails: flightDetails ?? this.flightDetails,
      hotelDetails: hotelDetails ?? this.hotelDetails,
      cabDetails: cabDetails ?? this.cabDetails,
    );
  }
} 