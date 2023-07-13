import 'package:flutter/material.dart';

class GuidelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hướng dẫn sử dụng'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.help_center,
                size: 40,
                color: Colors.black,
              ),
              SizedBox(height: 16),
              Text(
                'Các bước sử dụng app',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '1. Đăng nhập bằng Google Account đã đăng ký với Admin',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '2. Tạo menu: thêm các sản phẩm cần bán cho khách vào menu để tiến hành bán',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '3. Tạo nhóm: nhập đầy đủ thông tin của nhóm để tạo nhóm',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '4. Bấm nút cập nhật nhóm để chọn menu cho nhóm',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '5. Chia sẻ QR Code để khách quét và mua sản phẩm',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '6. Kiểm tra đơn hàng của nhóm và duyệt đơn hàng của khách',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '7. Khi 1 đơn hàng được hoàn thành, hoa hồng sẽ được thêm vào điểm của bạn, điểm sẽ được dùng quy đổi sang tiền mặt',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
