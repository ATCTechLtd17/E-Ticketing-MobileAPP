class PassengerInfo {
  final String? id;
  final String busId;
  final String name;
  final String email;
  final String contactNumber;
  final String emergencyContactNumber;
  final String gender;
  final List<String> seatNumber;
  final double ticketPrice;
  final String coachType;
  final String busType;
  final String from;
  final String to;
  final String depertureDate;
  final String arrivalDate;
  final String depertureTime;
  final String arrivalTime;
  final String boardingPoint;
  final String droppingPoint;
  final String transactionId;
  final String? createdAt;
  final String? updatedAt;

  PassengerInfo({
    this.id,
    required this.busId,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.emergencyContactNumber,
    required this.gender,
    required this.seatNumber,
    required this.ticketPrice,
    required this.coachType,
    required this.busType,
    required this.from,
    required this.to,
    required this.depertureDate,
    required this.arrivalDate,
    required this.depertureTime,
    required this.arrivalTime,
    required this.boardingPoint,
    required this.droppingPoint,
    required this.transactionId,
    this.createdAt,
    this.updatedAt,
  });

  factory PassengerInfo.fromJson(Map<String, dynamic> json) {
    return PassengerInfo(
      id: json['id'],
      busId: json['busId'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      emergencyContactNumber: json['emergencyContactNumber'] ?? '',
      gender: json['gender'] ?? '',
      seatNumber: List<String>.from(json['seatNumber'] ?? []),
      ticketPrice: json['ticketPrice']?.toDouble() ?? 0.0,
      coachType: json['coachType'] ?? '',
      busType: json['busType'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      depertureDate: json['depertureDate'] ?? '',
      arrivalDate: json['arrivalDate'] ?? '',
      depertureTime: json['depertureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      boardingPoint: json['boardingPoint'] ?? '',
      droppingPoint: json['droppingPoint'] ?? '',
      transactionId: json['transactionId'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'busId': busId,
      'name': name,
      'email': email,
      'contactNumber': contactNumber,
      'emergencyContactNumber': emergencyContactNumber,
      'gender': gender,
      'seatNumber': seatNumber,
      'ticketPrice': ticketPrice,
      'coachType': coachType,
      'busType': busType,
      'from': from,
      'to': to,
      'depertureDate': depertureDate,
      'arrivalDate': arrivalDate,
      'depertureTime': depertureTime,
      'arrivalTime': arrivalTime,
      'boardingPoint': boardingPoint,
      'droppingPoint': droppingPoint,
      'transactionId': transactionId,
    };
  }

  // Convert ticket data to PassengerInfo
  static PassengerInfo fromTicketData(Map<String, dynamic> ticketData) {
    final List<String> seats = (ticketData['seatNumbers'] is List)
        ? List<String>.from(ticketData['seatNumbers'])
        : [ticketData['seatNumbers'].toString()];

    return PassengerInfo(
      busId: ticketData['busId'] ?? '',
      name: ticketData['passengerName'] ?? '',
      email: ticketData['email'] ?? '',
      contactNumber: ticketData['phone'] ?? '',
      emergencyContactNumber: ticketData['phone'] ?? '',
      gender: ticketData['gender'] ?? '',
      seatNumber: seats,
      ticketPrice: double.tryParse(ticketData['originalPrice'] ?? '0') ?? 0.0,
      coachType: ticketData['coachType'] ?? '',
      busType: ticketData['busType'] ?? '',
      from: ticketData['fromCity'] ?? '',
      to: ticketData['toCity'] ?? '',
      depertureDate: ticketData['journeyDate'] ?? '',
      arrivalDate: ticketData['journeyDate'] ?? '',
      depertureTime: ticketData['departureTime'] ?? '',
      arrivalTime: ticketData['arrivalTime'] ?? '',
      boardingPoint: ticketData['boardingPoint'] ?? '',
      droppingPoint: ticketData['droppingPoint'] ?? '',
      transactionId: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}',
    );
  }
}
