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
    //_tourGuideFuture = ApiService.fetchTourGuide('21c17a71-fc44-472e-8855-ebb251bdee05');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information Profile'),
      ),
      body: FutureBuilder<TourGuide>(
        future: _tourGuideFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
                  Text('Name: ${tourGuide.name}'),
                  Text('Sex: ${tourGuide.sex}'),
                  Text('Phone Number: ${tourGuide.phoneNumber}'),
                  Text('Email: ${tourGuide.email}'),
                  Text('Status: ${tourGuide.status}'),
                  Text('Address: ${tourGuide.address}'),
                  Text('Admin ID: ${tourGuide.adminId}'),
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
