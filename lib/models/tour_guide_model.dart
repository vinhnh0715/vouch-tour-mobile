class TourGuide {
  final String id;
  final String name;
  final int sex;
  final String phoneNumber;
  final String email;
  final String status;
  final String address;
  final String adminId;

  TourGuide({
    required this.id,
    required this.name,
    required this.sex,
    required this.phoneNumber,
    required this.email,
    required this.status,
    required this.address,
    required this.adminId,
  });

  factory TourGuide.fromJson(Map<String, dynamic> json) {
    return TourGuide(
      id: json['id'],
      name: json['name'],
      sex: json['sex'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      status: json['status'],
      address: json['address'],
      adminId: json['adminId'],
    );
  }
}
