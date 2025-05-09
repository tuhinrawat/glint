import 'package:flutter/material.dart';

enum TripStatus {
  planning,
  confirmed,
  completed,
  cancelled
}

class Activity {
  final String name;
  final String description;
  final double cost;
  final String? imageUrl;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String location;
  final List<String> tags;
  final double rating;
  final List<String> reviews;
  final List<Payment>? payments;

  Activity({
    required this.name,
    required this.description,
    required this.cost,
    this.imageUrl,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.tags,
    this.rating = 0.0,
    this.reviews = const [],
    this.payments,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'cost': cost,
    'imageUrl': imageUrl,
    'startTime': '${startTime.hour}:${startTime.minute}',
    'endTime': '${endTime.hour}:${endTime.minute}',
    'location': location,
    'tags': tags,
    'rating': rating,
    'reviews': reviews,
    'payments': payments?.map((p) => p.toJson()).toList(),
  };

  factory Activity.fromJson(Map<String, dynamic> json) {
    final startTimeParts = (json['startTime'] as String).split(':');
    final endTimeParts = (json['endTime'] as String).split(':');
    return Activity(
      name: json['name'] as String,
      description: json['description'] as String,
      cost: (json['cost'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      startTime: TimeOfDay(hour: int.parse(startTimeParts[0]), minute: int.parse(startTimeParts[1])),
      endTime: TimeOfDay(hour: int.parse(endTimeParts[0]), minute: int.parse(endTimeParts[1])),
      location: json['location'] as String,
      tags: List<String>.from(json['tags']),
      rating: (json['rating'] as num).toDouble(),
      reviews: List<String>.from(json['reviews']),
      payments: json['payments'] != null
          ? List<Payment>.from(json['payments'].map((p) => Payment.fromJson(p)))
          : null,
    );
  }
}

class Payment {
  final String description;
  final double amount;
  final String paidBy;
  final DateTime date;

  Payment({
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'description': description,
    'amount': amount,
    'paidBy': paidBy,
    'date': date.toIso8601String(),
  };

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    description: json['description'] as String,
    amount: (json['amount'] as num).toDouble(),
    paidBy: json['paidBy'] as String,
    date: DateTime.parse(json['date'] as String),
  );
}

class Transportation {
  final String type; // flight, train, cab, etc.
  final String provider;
  final String from;
  final String to;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double cost;
  final String bookingReference;
  final Map<String, dynamic> details;
  final String? airline;
  final String? time;
  final String? duration;

  Transportation({
    required this.type,
    required this.provider,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.cost,
    required this.bookingReference,
    required this.details,
    this.airline,
    this.time,
    this.duration,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'provider': provider,
    'from': from,
    'to': to,
    'departureTime': departureTime.toIso8601String(),
    'arrivalTime': arrivalTime.toIso8601String(),
    'cost': cost,
    'bookingReference': bookingReference,
    'details': details,
    'airline': airline,
    'time': time,
    'duration': duration,
  };

  factory Transportation.fromJson(Map<String, dynamic> json) => Transportation(
    type: json['type'] as String,
    provider: json['provider'] as String,
    from: json['from'] as String,
    to: json['to'] as String,
    departureTime: DateTime.parse(json['departureTime']),
    arrivalTime: DateTime.parse(json['arrivalTime']),
    cost: (json['cost'] as num).toDouble(),
    bookingReference: json['bookingReference'] as String,
    details: json['details'] as Map<String, dynamic>,
    airline: json['airline'] as String?,
    time: json['time'] as String?,
    duration: json['duration'] as String?,
  );
}

class Accommodation {
  final String name;
  final String type; // hotel, hostel, apartment, etc.
  final String location;
  final DateTime checkIn;
  final DateTime checkOut;
  final double costPerNight;
  final int numberOfRooms;
  final String bookingReference;
  final List<String> amenities;
  final List<String> images;
  final double rating;
  final List<String> reviews;

  Accommodation({
    required this.name,
    required this.type,
    required this.location,
    required this.checkIn,
    required this.checkOut,
    required this.costPerNight,
    required this.numberOfRooms,
    required this.bookingReference,
    required this.amenities,
    required this.images,
    this.rating = 0.0,
    this.reviews = const [],
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'location': location,
    'checkIn': checkIn.toIso8601String(),
    'checkOut': checkOut.toIso8601String(),
    'costPerNight': costPerNight,
    'numberOfRooms': numberOfRooms,
    'bookingReference': bookingReference,
    'amenities': amenities,
    'images': images,
    'rating': rating,
    'reviews': reviews,
  };

  factory Accommodation.fromJson(Map<String, dynamic> json) => Accommodation(
    name: json['name'] as String,
    type: json['type'] as String,
    location: json['location'] as String,
    checkIn: DateTime.parse(json['checkIn']),
    checkOut: DateTime.parse(json['checkOut']),
    costPerNight: (json['costPerNight'] as num).toDouble(),
    numberOfRooms: json['numberOfRooms'] as int,
    bookingReference: json['bookingReference'] as String,
    amenities: List<String>.from(json['amenities']),
    images: List<String>.from(json['images']),
    rating: (json['rating'] as num).toDouble(),
    reviews: List<String>.from(json['reviews']),
  );
}

class DayPlan {
  final int day;
  final DateTime date;
  final Flight? flight;
  final Hotel? hotel;
  final Cab? cab;
  final List<Activity> activities;
  final double totalCost;

  DayPlan({
    required this.day,
    required this.date,
    this.flight,
    this.hotel,
    this.cab,
    required this.activities,
    required this.totalCost,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'date': date.toIso8601String(),
    'flight': flight?.toJson(),
    'hotel': hotel?.toJson(),
    'cab': cab?.toJson(),
    'activities': activities.map((a) => a.name).toList(),
    'totalCost': totalCost,
  };

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    return DayPlan(
      day: json['day'] as int,
      date: DateTime.parse(json['date'] as String),
      flight: json['flight'] != null ? Flight.fromJson(json['flight']) : null,
      hotel: json['hotel'] != null ? Hotel.fromJson(json['hotel']) : null,
      cab: json['cab'] != null ? Cab.fromJson(json['cab']) : null,
      activities: (json['activities'] as List).map((a) => Activity(
        name: a as String,
        description: 'Activity description',
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
        location: 'TBD',
        cost: 0.0,
        tags: const [],
      )).toList(),
      totalCost: (json['totalCost'] as num).toDouble(),
    );
  }
}

class Flight {
  final String from;
  final String to;
  final String time;
  final String airline;
  final double cost;

  Flight({
    required this.from,
    required this.to,
    required this.time,
    required this.airline,
    required this.cost,
  });

  Map<String, dynamic> toJson() => {
    'from': from,
    'to': to,
    'time': time,
    'airline': airline,
    'cost': cost,
  };

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      from: json['from'] as String,
      to: json['to'] as String,
      time: json['time'] as String,
      airline: json['airline'] as String,
      cost: (json['cost'] as num).toDouble(),
    );
  }
}

class Hotel {
  final String name;
  final String? checkIn;
  final String? checkOut;
  final double costPerNight;

  Hotel({
    required this.name,
    this.checkIn,
    this.checkOut,
    required this.costPerNight,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'checkIn': checkIn,
    'checkOut': checkOut,
    'cost': costPerNight,
  };

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'] as String,
      checkIn: json['checkIn'] as String?,
      checkOut: json['checkOut'] as String?,
      costPerNight: (json['cost'] as num).toDouble(),
    );
  }
}

class Cab {
  final String? from;
  final String? to;
  final String type;
  final String? duration;
  final double cost;

  Cab({
    this.from,
    this.to,
    required this.type,
    this.duration,
    required this.cost,
  });

  Map<String, dynamic> toJson() => {
    'from': from,
    'to': to,
    'type': type,
    'duration': duration,
    'cost': cost,
  };

  factory Cab.fromJson(Map<String, dynamic> json) {
    return Cab(
      from: json['from'] as String?,
      to: json['to'] as String?,
      type: json['type'] as String,
      duration: json['duration'] as String?,
      cost: (json['cost'] as num).toDouble(),
    );
  }
}

class Itinerary {
  final String id;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double totalCost;
  final int numberOfPeople;
  final String travelType;
  final List<String> images;
  final double suggestedFlightCost;
  final double suggestedHotelCostPerNight;
  final double suggestedCabCostPerDay;
  final double rating;
  final String creatorName;
  final List<String> tags;
  final TripStatus status;
  final List<DayPlan> dayPlans;
  final bool isCompleted;
  final DateTime? completedAt;

  Itinerary({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.totalCost,
    required this.numberOfPeople,
    required this.travelType,
    required this.images,
    required this.suggestedFlightCost,
    required this.suggestedHotelCostPerNight,
    required this.suggestedCabCostPerDay,
    required this.rating,
    required this.creatorName,
    required this.tags,
    required this.status,
    required this.dayPlans,
    this.isCompleted = false,
    this.completedAt,
  });

  bool get isActive => !isCompleted && 
      startDate.isBefore(DateTime.now()) && 
      endDate.isAfter(DateTime.now());

  Map<String, dynamic> toJson() => {
    'id': id,
    'destination': destination,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'totalCost': totalCost,
    'numberOfPeople': numberOfPeople,
    'travelType': travelType,
    'images': images,
    'suggestedFlightCost': suggestedFlightCost,
    'suggestedHotelCostPerNight': suggestedHotelCostPerNight,
    'suggestedCabCostPerDay': suggestedCabCostPerDay,
    'rating': rating,
    'creatorName': creatorName,
    'tags': tags,
    'status': status.toString(),
    'dayPlans': dayPlans.map((plan) => plan.toJson()).toList(),
    'isCompleted': isCompleted,
    'completedAt': completedAt?.toIso8601String(),
  };

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
    id: json['id'] as String,
    destination: json['destination'] as String,
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: DateTime.parse(json['endDate'] as String),
    totalCost: json['totalCost'] as double,
    numberOfPeople: json['numberOfPeople'] as int,
    travelType: json['travelType'] as String,
    images: (json['images'] as List).cast<String>(),
    suggestedFlightCost: json['suggestedFlightCost'] as double,
    suggestedHotelCostPerNight: json['suggestedHotelCostPerNight'] as double,
    suggestedCabCostPerDay: json['suggestedCabCostPerDay'] as double,
    rating: json['rating'] as double,
    creatorName: json['creatorName'] as String,
    tags: (json['tags'] as List).cast<String>(),
    status: TripStatus.values.firstWhere(
      (e) => e.toString() == json['status'],
      orElse: () => TripStatus.planning,
    ),
    dayPlans: (json['dayPlans'] as List)
        .map((plan) => DayPlan.fromJson(plan as Map<String, dynamic>))
        .toList(),
    isCompleted: json['isCompleted'] as bool? ?? false,
    completedAt: json['completedAt'] != null 
        ? DateTime.parse(json['completedAt'] as String)
        : null,
  );

  Itinerary copyWith({
    String? id,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    double? totalCost,
    int? numberOfPeople,
    String? travelType,
    List<String>? images,
    double? suggestedFlightCost,
    double? suggestedHotelCostPerNight,
    double? suggestedCabCostPerDay,
    double? rating,
    String? creatorName,
    List<String>? tags,
    TripStatus? status,
    List<DayPlan>? dayPlans,
    bool? isCompleted,
    DateTime? completedAt,
  }) => Itinerary(
    id: id ?? this.id,
    destination: destination ?? this.destination,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    totalCost: totalCost ?? this.totalCost,
    numberOfPeople: numberOfPeople ?? this.numberOfPeople,
    travelType: travelType ?? this.travelType,
    images: images ?? this.images,
    suggestedFlightCost: suggestedFlightCost ?? this.suggestedFlightCost,
    suggestedHotelCostPerNight: suggestedHotelCostPerNight ?? this.suggestedHotelCostPerNight,
    suggestedCabCostPerDay: suggestedCabCostPerDay ?? this.suggestedCabCostPerDay,
    rating: rating ?? this.rating,
    creatorName: creatorName ?? this.creatorName,
    tags: tags ?? this.tags,
    status: status ?? this.status,
    dayPlans: dayPlans ?? this.dayPlans,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt ?? this.completedAt,
  );
} 