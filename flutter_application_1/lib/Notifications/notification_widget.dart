import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final String title;
  final String text;

  NotificationWidget({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(text),
          ],
        ),
      ),
    );
  }
}