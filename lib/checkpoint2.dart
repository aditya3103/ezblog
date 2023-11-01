import 'package:flutter/material.dart';

class NewBlog extends StatefulWidget {
  @override
  _NewBlogState createState() => _NewBlogState();
}

class _NewBlogState extends State<NewBlog> {
  bool isPaid = false; // Track the blog type selection
  String selectedGenre = ''; // Track the selected genre
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
                  decoration: InputDecoration(
                    hintText: 'Type out a heading...',
                    contentPadding: const EdgeInsets.all(8.0),
                  ),
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Charter',
                  ),
                  maxLines: 1, // Single line
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
                controller: contentController,
                maxLines: 12,
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Charter',
                ),
                decoration: InputDecoration(
                  hintText: 'Start typing...',
                  contentPadding: const EdgeInsets.all(8.0),
                ),
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
                onPressed: () {
                  // Handle submit button logic
                  //print debug msg
                  print('Blog type: ${isPaid ? 'Paid' : 'Free'}');
                  print('Genre: $selectedGenre');
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
}
