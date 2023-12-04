import 'package:flutter/material.dart';

class CartIcon extends StatelessWidget {
  final int? count;
  final Widget child;
  const CartIcon({super.key, this.count, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          Positioned(
              top: 3,
              right: 0,
              child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFF0E8388),
                      ),
                      color: Colors.white),
                  child: Center(
                      child: Text(
                    count.toString(),
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    textAlign: TextAlign.center,
                  ))))
        ],
      ),
    );
  }
}
