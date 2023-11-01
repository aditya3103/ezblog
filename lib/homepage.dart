import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ezblog/blogcard.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('blogs').snapshots(),
      builder: (context, snapshot){
        List<BlogCard> blogCards = [];
        if(!snapshot.hasData)
          return CircularProgressIndicator();
        if(snapshot.hasError)
          return Text('${snapshot.error}');
        if(snapshot.hasData){
          final blogs = snapshot.data?.docs.reversed.toList();
          for(var blog in blogs!){
            final blogCard = BlogCard(
              title: blog['title'],
              category: blog['category'],
              isFree: blog['isFree'],
              content: blog['content'],
              author: blog['author'],
              postedAt: blog['postedAt']
            );
            blogCards.add(blogCard);
          }
        }

        return Expanded(
          child: ListView(
            children: blogCards,
          ),
        );
      },
    );
  }
}
