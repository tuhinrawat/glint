import 'package:flutter/material.dart';

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
    );
  }
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
  final DateTime date;
  final List<Activity> activities;
  final List<Transportation> localTransports;
  final Accommodation? accommodation;
  final Transportation? flight;
  final Accommodation? hotel;
  final Transportation? cab;
  final double totalCost;

  DayPlan({
    required this.date,
    required this.activities,
    required this.localTransports,
    this.accommodation,
    this.flight,
    this.hotel,
    this.cab,
    required this.totalCost,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'activities': activities.map((a) => a.toJson()).toList(),
    'localTransports': localTransports.map((t) => t.toJson()).toList(),
    'accommodation': accommodation?.toJson(),
    'flight': flight?.toJson(),
    'hotel': hotel?.toJson(),
    'cab': cab?.toJson(),
    'totalCost': totalCost,
  };

  factory DayPlan.fromJson(Map<String, dynamic> json) => DayPlan(
    date: DateTime.parse(json['date']),
    activities: (json['activities'] as List).map((a) => Activity.fromJson(a)).toList(),
    localTransports: (json['localTransports'] as List).map((t) => Transportation.fromJson(t)).toList(),
    accommodation: json['accommodation'] != null ? Accommodation.fromJson(json['accommodation']) : null,
    flight: json['flight'] != null ? Transportation.fromJson(json['flight']) : null,
    hotel: json['hotel'] != null ? Accommodation.fromJson(json['hotel']) : null,
    cab: json['cab'] != null ? Transportation.fromJson(json['cab']) : null,
    totalCost: (json['totalCost'] as num).toDouble(),
  );
}

class Itinerary {
  final String id;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String creatorId;
  final String creatorName;
  final String? creatorAvatar;
  final List<String> images;
  final List<DayPlan> dayPlans;
  final Transportation? arrivalTransport;
  final Transportation? departureTransport;
  final double totalCost;
  final int numberOfPeople;
  final double rating;
  final List<Map<String, dynamic>> reviews;
  final List<String> tags;
  final bool isCompleted;
  final Map<String, dynamic> weatherInfo;
  final Map<String, dynamic> additionalInfo;

  double get costPerPerson => totalCost / numberOfPeople;

  Itinerary({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.creatorId,
    required this.creatorName,
    this.creatorAvatar,
    required this.images,
    required this.dayPlans,
    this.arrivalTransport,
    this.departureTransport,
    required this.totalCost,
    required this.numberOfPeople,
    this.rating = 0.0,
    this.reviews = const [],
    this.tags = const [],
    this.isCompleted = false,
    this.weatherInfo = const {},
    this.additionalInfo = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'destination': destination,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'creatorId': creatorId,
    'creatorName': creatorName,
    'creatorAvatar': creatorAvatar,
    'images': images,
    'dayPlans': dayPlans.map((d) => d.toJson()).toList(),
    'arrivalTransport': arrivalTransport?.toJson(),
    'departureTransport': departureTransport?.toJson(),
    'totalCost': totalCost,
    'numberOfPeople': numberOfPeople,
    'rating': rating,
    'reviews': reviews,
    'tags': tags,
    'isCompleted': isCompleted,
    'weatherInfo': weatherInfo,
    'additionalInfo': additionalInfo,
  };

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
    id: json['id'] as String,
    destination: json['destination'] as String,
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    creatorId: json['creatorId'] as String,
    creatorName: json['creatorName'] as String,
    creatorAvatar: json['creatorAvatar'] as String?,
    images: List<String>.from(json['images']),
    dayPlans: (json['dayPlans'] as List).map((d) => DayPlan.fromJson(d)).toList(),
    arrivalTransport: json['arrivalTransport'] != null ? Transportation.fromJson(json['arrivalTransport']) : null,
    departureTransport: json['departureTransport'] != null ? Transportation.fromJson(json['departureTransport']) : null,
    totalCost: (json['totalCost'] as num).toDouble(),
    numberOfPeople: json['numberOfPeople'] as int,
    rating: (json['rating'] as num).toDouble(),
    reviews: List<Map<String, dynamic>>.from(json['reviews']),
    tags: List<String>.from(json['tags']),
    isCompleted: json['isCompleted'] as bool,
    weatherInfo: json['weatherInfo'] as Map<String, dynamic>,
    additionalInfo: json['additionalInfo'] as Map<String, dynamic>,
  );

  Itinerary copyWith({
    String? destination,
    List<DayPlan>? dayPlans,
    int? numberOfPeople,
    double? totalCost,
    Transportation? arrivalTransport,
    Transportation? departureTransport,
    double? rating,
    List<Map<String, dynamic>>? reviews,
    List<String>? tags,
    bool? isCompleted,
    Map<String, dynamic>? weatherInfo,
    Map<String, dynamic>? additionalInfo,
  }) {
    return Itinerary(
      id: id,
      destination: destination ?? this.destination,
      startDate: startDate,
      endDate: endDate,
      creatorId: creatorId,
      creatorName: creatorName,
      creatorAvatar: creatorAvatar,
      images: images,
      dayPlans: dayPlans ?? this.dayPlans,
      arrivalTransport: arrivalTransport ?? this.arrivalTransport,
      departureTransport: departureTransport ?? this.departureTransport,
      totalCost: totalCost ?? this.totalCost,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      tags: tags ?? this.tags,
      isCompleted: isCompleted ?? this.isCompleted,
      weatherInfo: weatherInfo ?? this.weatherInfo,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  // Helper method to get suggested flight cost
  int get suggestedFlightCost {
    return (totalCost * 0.4).round();
  }

  // Helper method to get suggested hotel cost per night
  int get suggestedHotelCostPerNight {
    return (totalCost * 0.4 / dayPlans.length).round();
  }

  // Helper method to get suggested cab cost per day
  int get suggestedCabCostPerDay {
    return (totalCost * 0.2 / dayPlans.length).round();
  }
} 