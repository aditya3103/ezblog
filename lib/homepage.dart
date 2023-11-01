import 'package:flutter/material.dart';
import 'package:ezblog/blogcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextStyle _charterStyle = TextStyle(
    fontFamily: 'Charter',
  );
  List<String> genres = [
    'For you',
    'Science',
    'Technology',
    'Arts',
    'Sports',
    'Travel',
    'Food',
    'Music',
    'Fashion'
  ];

  String selectedGenre = 'For you';

  Widget buildGenreChips() {
    return Wrap(
      spacing: 8.0,
      children: genres.map((genre) {
        return FilterChip(
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(genre, style: _charterStyle),
          ),
          onSelected: (bool selected) async {
            //time for chut
            if (genre != 'For you') {
              QuerySnapshot genreBlogs = await getBlogsByGenre(genre);
            }
            //time for chut

            setState(() {
              selectedGenre = genre;
            });
          },
          selected: selectedGenre == genre,
          backgroundColor: selectedGenre == genre ? Colors.blue : null,
          selectedColor: Colors.white,
          checkmarkColor: Colors.black,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text("data"),
        SizedBox(
          height: 10,
        ),
        buildGenreChips(),
        StreamBuilder(
          stream: selectedGenre == 'For you'
              ? FirebaseFirestore.instance.collection('blogs').snapshots()
              : FirebaseFirestore.instance
                  .collection('blogs')
                  .where('category', isEqualTo: selectedGenre)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.hasError) return Text('${snapshot.error}');
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Container(
                  margin: EdgeInsets.all(50.0), // Add margin
                  child: Text(
                    "No blogs in this genre yet",
                    style: TextStyle(
                      fontFamily: 'Charter', // Set font to Charter
                      fontSize: 24, // Increase text size
                    ),
                  ),
                ),
              );
            }

            List<BlogCard> blogCards = [];
            final blogs = snapshot.data?.docs.reversed.toList();
            for (var blog in blogs!) {
              final blogCard = BlogCard(
                  title: blog['title'],
                  category: blog['category'],
                  isFree: blog['isFree'],
                  content: blog['content'],
                  userid: blog['userid'],
                  author: blog['author'],
                  postedAt: blog['postedAt']);
              blogCards.add(blogCard);
            }

            return Expanded(
              child: ListView(
                children: blogCards,
              ),
            );
          },
        )
      ],
    );
  }

  Future<QuerySnapshot> getBlogsByGenre(String genre) async {
    return FirebaseFirestore.instance
        .collection('blogs')
        .where('category', isEqualTo: genre)
        .get();
  }
}
