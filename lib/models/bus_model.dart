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
  String busNumber;
  bool isDeleted;
  String createdAt;
  String updatedAt;
  List<BusSchedule> busSchedule;
  List<BusRoute> busRoute;
  List<BusBoardingPoint> busBoardingPoint;
  List<BusDroppingPoint> busDroppingPoint;
  BusCompany busCompany;

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
    required this.busNumber,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.busSchedule,
    required this.busRoute,
    required this.busBoardingPoint,
    required this.busDroppingPoint,
    required this.busCompany,
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
      busBoardingPoint: (json['busBoardingPoint'] as List<dynamic>)
          .map((boarding) => BusBoardingPoint.fromJson(boarding))
          .toList(),
      busDroppingPoint: (json['busDroppingPoint'] as List<dynamic>)
          .map((dropping) => BusDroppingPoint.fromJson(dropping))
          .toList(),
      busCompany: BusCompany.fromJson(json['busCompany']),
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

class BusBoardingPoint {
  String id;
  String busId;
  String counterName;
  String boardingLocation;
  String boardingTime;
  String createdAt;
  String updatedAt;

  BusBoardingPoint({
    required this.id,
    required this.busId,
    required this.counterName,
    required this.boardingLocation,
    required this.boardingTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusBoardingPoint.fromJson(Map<String, dynamic> json) {
    return BusBoardingPoint(
      id: json['id'],
      busId: json['busId'],
      counterName: json['counterName'],
      boardingLocation: json['boardingLocation'],
      boardingTime: json['boardingTime'],
      createdAt: json['createdAt'],
      updatedAt: json['updateAt'],
    );
  }
}

class BusDroppingPoint {
  String id;
  String busId;
  String counterName;
  String droppingLocation;
  String droppingTime;
  String createdAt;
  String updatedAt;

  BusDroppingPoint({
    required this.id,
    required this.busId,
    required this.counterName,
    required this.droppingLocation,
    required this.droppingTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusDroppingPoint.fromJson(Map<String, dynamic> json) {
    return BusDroppingPoint(
      id: json['id'],
      busId: json['busId'],
      counterName: json['counterName'],
      droppingLocation: json['droppingLocation'],
      droppingTime: json['droppingTime'],
      createdAt: json['createdAt'],
      updatedAt: json['updateAt'],
    );
  }
}

class BusCompany {
  String id;
  String companyName;
  String busOwnerName;
  String email;
  String contactNumber;
  String emergencyContactNumber;
  String logo;
  String address;
  dynamic transportType;
  dynamic busCounters;
  dynamic busQuantity;
  bool isDeleted;
  String createdAt;
  String updatedAt;

  BusCompany({
    required this.id,
    required this.companyName,
    required this.busOwnerName,
    required this.email,
    required this.contactNumber,
    required this.emergencyContactNumber,
    required this.logo,
    required this.address,
    this.transportType,
    this.busCounters,
    this.busQuantity,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusCompany.fromJson(Map<String, dynamic> json) {
    return BusCompany(
      id: json['id'],
      companyName: json['companyName'],
      busOwnerName: json['busOwnerName'],
      email: json['email'],
      contactNumber: json['contactNumber'],
      emergencyContactNumber: json['emergencyContactNumber'],
      logo: json['logo'],
      address: json['address'],
      transportType: json['transportType'],
      busCounters: json['busCounters'],
      busQuantity: json['busQuantity'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
