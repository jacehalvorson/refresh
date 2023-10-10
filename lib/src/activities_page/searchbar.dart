import 'package:flutter/material.dart';
import '../theme.dart';

class CustomHeaderDelegate extends SliverPersistentHeaderDelegate {

  final VoidCallback openSheet;

  CustomHeaderDelegate({required this.openSheet});

  final textController = TextEditingController();

  @override
  double get minExtent => 112; // Minimum header height. Must match content size
  @override
  double get maxExtent => 112; // Maximum header height. Must match content size

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Container(
        //color: Colors.blue, // Background color
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 10),
              child: Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  color: ThemeColor.darkElement, // Set the background color
                  borderRadius: BorderRadius.circular(3.0), // Set the border radius
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0, bottom:8.0),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: ThemeColor.background,
                      ),
                      child: Center(
                        child: TextField(
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ThemeColor.text, // text color
                          ),
                          controller: textController,
                          textAlign: TextAlign.left,
                          cursorColor: ThemeColor.primary, // cursor color
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: ThemeColor.darkElement,
                              size: 24.0,
                            ),
                            counterText: "",
                            contentPadding: EdgeInsets.only(left: 8),
                            hintText: 'What do you like to do?',
                            hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ThemeColor.darkElement, // hint text color
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6, right: 8, bottom: 10.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: 36,
                        color: ThemeColor.primary,
                      ),
                      onPressed: () {
                        openSheet();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}