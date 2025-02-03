class Bus {
  String id;
  String counterId;
  String busName;
  String busId;
  String busCompanyId;
  String busType;
  int seatCapacity;
  String coachType;
  int? seatAvailable;
  double ticketPrice;
  String busNumber;
  bool isDeleted;
  String createdAt;
  String updatedAt;
  List<BusSchedule> busSchedule;
  List<BusRoute> busRoute;

  Bus({
    required this.id,
    required this.counterId,
    required this.busName,
    required this.busId,
    required this.busCompanyId,
    required this.busType,
    required this.seatCapacity,
    required this.coachType,
    required this.seatAvailable,
    required this.ticketPrice,
    required this.busNumber,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.busSchedule,
    required this.busRoute,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      counterId: json['counterId'],
      busName: json['busName'],
      busId: json['busId'],
      busCompanyId: json['busCompanyId'],
      busType: json['busType'],
      seatCapacity: json['seatCapacity'],
      coachType: json['coachType'],
      seatAvailable: json['seatAvailable'],
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      busNumber: json['busNumber'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      busSchedule: (json['busSchedule'] as List<dynamic>)
          .map((schedule) => BusSchedule.fromJson(schedule))
          .toList(),
      busRoute: (json['busRoute'] as List<dynamic>)
          .map((route) => BusRoute.fromJson(route))
          .toList(),
    );
  }
}

class BusSchedule {
  String id;
  String busId;
  String startPoint;
  String endPoint;
  String departureDate;
  String direction;
  String departTime;
  String arrivalTime;
  double ticketPrice;
  String createdAt;
  String updatedAt;

  BusSchedule({
    required this.id,
    required this.busId,
    required this.startPoint,
    required this.endPoint,
    required this.departureDate,
    required this.direction,
    required this.departTime,
    required this.arrivalTime,
    required this.ticketPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      id: json['id'],
      busId: json['busId'],
      startPoint: json['startPoint'],
      endPoint: json['endPoint'],
      departureDate: json['departureDate'],
      direction: json['direction'],
      departTime: json['departTime'],
      arrivalTime: json['arrivalTime'],
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class BusRoute {
  String id;
  String busId;
  String stoppageLocation;
  String stoppageTime;
  double ticketPrice;
  String createdAt;
  String updatedAt;

  BusRoute({
    required this.id,
    required this.busId,
    required this.stoppageLocation,
    required this.stoppageTime,
    required this.ticketPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      id: json['id'],
      busId: json['busId'],
      stoppageLocation: json['stoppageLocation'],
      stoppageTime: json['stoppageTime'],
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
