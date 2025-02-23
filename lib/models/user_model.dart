class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String contactNumber;
  final String emergencyContactNumber;
  final String dateOfBirth;
  final String gender;
  final String? profileImage;
  final String? presentAddress;
  final String? permanentAddress;
  final String? nidCardNumber;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.contactNumber,
    required this.emergencyContactNumber,
    required this.dateOfBirth,
    required this.gender,
    this.profileImage,
    this.presentAddress,
    this.permanentAddress,
    this.nidCardNumber,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      contactNumber: json['contactNumber'] ?? 'N/A',
      emergencyContactNumber: json['emergencyContactNumber'] ?? 'N/A',
      dateOfBirth: json['dateOfBirth'] ?? 'N/A',
      gender: json['gender'] ?? 'N/A',
      profileImage: json['profileImage'],
      presentAddress: json['presentAddress'],
      permanentAddress: json['permanentAddress'],
      nidCardNumber: json['nidCardNumber'],
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
