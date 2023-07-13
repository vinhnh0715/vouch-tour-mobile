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
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text(
                        'Tên',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(tourGuide.name),
                    ),
                    ListTile(
                      title: const Text(
                        'Giới tính',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(tourGuide.sex == 0 ? 'Nam' : 'Nữ'),
                    ),
                    ListTile(
                      title: const Text(
                        'Số điện thoại',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(tourGuide.phoneNumber),
                    ),
                    ListTile(
                      title: const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(tourGuide.email),
                    ),
                    ListTile(
                      title: const Text(
                        'Địa chỉ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(tourGuide.address),
                    ),
                    ListTile(
                      title: const Text(
                        'Trạng thái',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(tourGuide.status),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('Thông tin của bạn chưa được cập nhật'),
            );
          }
        },
      ),
    );
  }
}
