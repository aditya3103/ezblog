import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  //properties
  String title = 'title';
  String category = 'cat';
  bool isFree = true;
  String content = 'content';
  String author = 'User';
  Timestamp postedAt = Timestamp.fromMicrosecondsSinceEpoch(100);

  BlogCard({
    super.key,
    required this.title,
    required this.category,
    required this.isFree,
    required this.content,
    required this.author,
    required this.postedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          debugPrint('Card tapped.');
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${title}',
                  style:
                  const TextStyle(fontSize: 22, fontStyle: FontStyle.italic)),
              SizedBox(
                height: 8,
              ),
              Chip(
                label: Text(
                  '${category}',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                backgroundColor: Colors.black,
                labelPadding: EdgeInsets.symmetric(vertical: 0),

              ),
              SizedBox(
                height: 8,
              ),
              Text('${content}', style: TextStyle()),
              SizedBox(
                height: 8,
              ),
              Text('${author}', style: TextStyle()),
              Text('1st Nov 2023', style: TextStyle())
            ],
          ),
        ),
      ),
      elevation: 8,
      shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
