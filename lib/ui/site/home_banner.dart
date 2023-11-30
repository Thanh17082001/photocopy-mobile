import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 140.0,
      width: double.infinity,
      child: Image.network(
        'https://namtruongkhang.com/wp-content/uploads/2023/08/banner-su-dung-may-photocopy-mien-phi.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}