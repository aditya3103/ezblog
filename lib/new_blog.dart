import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class NewBlog extends StatefulWidget {
  @override
  _NewBlogState createState() => _NewBlogState();
}

class _NewBlogState extends State<NewBlog> {
  bool isPaid = false; // Track the blog type selection
  String selectedGenre = ''; // Track the selected genre
  String heading = '';
  String content = '';
  TextEditingController headingController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final TextStyle _charterStyle = TextStyle(
    fontFamily: 'Charter',
  );

  List<String> genres = [
    'Science',
    'Technology',
    'Arts',
    'Sports',
    'Travel',
    'Food',
    'Music',
    'Fashion'
  ];

  final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(
            50.0, // Add padding around the entire component
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: TextFormField(
                  controller: headingController, // Use the heading controller
                  decoration: InputDecoration(
                    hintText: 'Type out a heading...',
                    contentPadding: const EdgeInsets.all(8.0),
                  ),
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Charter',
                  ),
                  maxLines: 1, // Single line
                  onChanged: (value) {
                    // Update the heading when the user types
                    setState(() {
                      heading = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Select Genre:',
                  style: _charterStyle.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              buildGenreChips(),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Select Blog Type:',
                  style: _charterStyle.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: <Widget>[
                  FilterChip(
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Paid', style: _charterStyle),
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        isPaid = true;
                      });
                    },
                    selected: isPaid,
                    backgroundColor: isPaid ? Colors.blue : null,
                    selectedColor: Colors.white,
                    checkmarkColor: Colors.black,
                  ),
                  FilterChip(
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Free', style: _charterStyle),
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        isPaid = false;
                      });
                    },
                    selected: !isPaid,
                    backgroundColor: !isPaid ? Colors.blue : null,
                    selectedColor: Colors.white,
                    checkmarkColor: Colors.black,
                  ),
                ],
              ),
              SizedBox(height: 32.0),
              TextFormField(
                controller: contentController, // Use the content controllerr
                maxLines: 12,
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Charter',
                ),
                decoration: InputDecoration(
                  hintText: 'Start typing...',
                  contentPadding: const EdgeInsets.all(8.0),
                ),
                onChanged: (value) {
                  // Update the content when the user types
                  setState(() {
                    content = value;
                  });
                },
              ),
              SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            top: 30,
            right: 30,
            child: Container(
              width: 100,
              height: 30,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  // Handle submit button logic
                  //print debug msg
                  // print('Blog type: ${isPaid ? 'Paid' : 'Free'}');
                  // print('Genre: $selectedGenre');

                  await firebaseInitialization;
                  saveBlogPost();
                },
                label: Text('Publish',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Charter')),
                backgroundColor: Colors.blue,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGenreChips() {
    return Wrap(
      spacing: 8.0,
      children: genres.map((genre) {
        return FilterChip(
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(genre, style: _charterStyle),
          ),
          onSelected: (bool selected) {
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

  // Function to save blog post data to Firestore
  Future<void> saveBlogPost() async {
    // Get the current user (assuming they are already logged in)
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user != null) {
      // Get the user's UID (user ID)
      String userId = user.uid;

      // Get the current date and time
      DateTime currentDate = DateTime.now();

      // Check if heading and content are not empty
      if (heading.isNotEmpty &&
          content.isNotEmpty &&
          selectedGenre.isNotEmpty) {
        try {
          // await FirebaseFirestore.instance.collection('newBlogs').add({
          //   'userId': userId, // Include the user ID
          //   'date': currentDate, // Include the current date
          //   'genre': selectedGenre,
          //   'isPaid': isPaid,
          //   'title': heading,
          //   'content': content,
          // });

          DocumentReference blogRef =
              FirebaseFirestore.instance.collection('blogs').doc();

          // Add the blog post data to the document
          await blogRef.set({
            'author': userId,
            'category': selectedGenre,
            'content': content,
            'isFree': !isPaid,
            'postedAt': currentDate,
            'title': heading,
          });

          //debug msgs to print all the data
          print('Title: $heading');
          print('Content: $content');
          print('Genre: $selectedGenre');
          print('isPaid: $isPaid');
          print('userId: $userId');
          print('date: $currentDate');

          // Clear the form fields after data is saved
          setState(() {
            headingController.clear();
            contentController.clear();
            heading = '';
            content = '';
            selectedGenre = '';
          });

          // You can also show a success message to the user
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Blog post saved successfully.'),
          ));
        } catch (e) {
          // Handle any errors that occur during data saving
          print('Error saving blog post: $e');
        }
      } else {
        // Display an error message if heading or content is empty
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please fill in the heading, content and genre.'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      // The user is not logged in, handle this case accordingly
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You must be logged in to post a blog.'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
