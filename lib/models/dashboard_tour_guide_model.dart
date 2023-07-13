class DashboardTourGuide {
  final String id;
  final String name;
  final int sex;
  final String phoneNumber;
  final String email;
  final String status;
  final String address;
  final String adminId;
  final int numberOfGroup;
  final int numberOfOrderCompleted;
  final int numberOfProductSold;
  final int point;

  DashboardTourGuide({
    required this.id,
    required this.name,
    required this.sex,
    required this.phoneNumber,
    required this.email,
    required this.status,
    required this.address,
    required this.adminId,
    required this.numberOfGroup,
    required this.numberOfOrderCompleted,
    required this.numberOfProductSold,
    required this.point,
  });

  factory DashboardTourGuide.fromJson(Map<String, dynamic> json) {
    return DashboardTourGuide(
      id: json['id'],
      name: json['name'],
      sex: json['sex'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      status: json['status'],
      address: json['address'],
      adminId: json['adminId'],
      numberOfGroup: json['numberOfGroup'],
      numberOfOrderCompleted: json['numberOfOrderCompleted'],
      numberOfProductSold: json['numberOfProductSold'],
      point: json['point'],
    );
  }
}
