import 'package:flutter/material.dart';
import 'package:vouch_tour_mobile/models/tour_guide_model.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';

class InformationProfilePage extends StatefulWidget {
  final String tourGuideId;

  InformationProfilePage({required this.tourGuideId});

  @override
  _InformationProfilePageState createState() => _InformationProfilePageState();
}

class _InformationProfilePageState extends State<InformationProfilePage> {
  Future<TourGuide>? _tourGuideFuture;

  @override
  void initState() {
    super.initState();
    _tourGuideFuture = ApiService.fetchTourGuide(widget.tourGuideId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
      ),
      body: FutureBuilder<TourGuide>(
        future: _tourGuideFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final tourGuide = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tên: ${tourGuide.name}'),
                  Text('Giới tính: ${tourGuide.sex == 0 ? 'Male' : 'Female'}'),
                  Text('Số điện thoại: ${tourGuide.phoneNumber}'),
                  Text('Email: ${tourGuide.email}'),
                  Text('Địa chỉ: ${tourGuide.address}'),
                  Text('Trạng thái: ${tourGuide.status}'),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}
