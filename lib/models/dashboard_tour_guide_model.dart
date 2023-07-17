class DashboardTourGuideModel {
  final String id;
  final String name;
  final int sex;
  final String phoneNumber;
  final String email;
  final String status;
  final String address;
  final String adminId;
  final ReportInMonth reportInMonth;

  DashboardTourGuideModel({
    required this.id,
    required this.name,
    required this.sex,
    required this.phoneNumber,
    required this.email,
    required this.status,
    required this.address,
    required this.adminId,
    required this.reportInMonth,
  });

  factory DashboardTourGuideModel.fromJson(Map<String, dynamic> json) {
    return DashboardTourGuideModel(
      id: json['id'],
      name: json['name'],
      sex: json['sex'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      status: json['status'],
      address: json['address'],
      adminId: json['adminId'],
      reportInMonth: ReportInMonth.fromJson(json['reportInMonth']),
    );
  }
}

class ReportInMonth {
  final int numberOfGroup;
  final int numberOfOrderCompleted;
  final int numberOfOrderWaiting;
  final int numberOfOrderCanceled;
  final int numberOfProductSold;
  final int point;

  ReportInMonth({
    required this.numberOfGroup,
    required this.numberOfOrderCompleted,
    required this.numberOfOrderWaiting,
    required this.numberOfOrderCanceled,
    required this.numberOfProductSold,
    required this.point,
  });

  factory ReportInMonth.fromJson(Map<String, dynamic> json) {
    return ReportInMonth(
      numberOfGroup: json['numberOfGroup'],
      numberOfOrderCompleted: json['numberOfOrderCompleted'],
      numberOfOrderWaiting: json['numberOfOrderWaiting'],
      numberOfOrderCanceled: json['numberOfOrderCanceled'],
      numberOfProductSold: json['numberOfProductSold'],
      point: json['point'],
    );
  }
}
