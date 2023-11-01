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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Create a New Blog',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Charter',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Select Genre:',
                style: _charterStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Wrap(
              spacing: 8.0,
              children: <Widget>[
                FilterChip(
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Science', style: _charterStyle),
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedGenre = 'Science';
                    });
                  },
                  selected: selectedGenre == 'Science',
                  backgroundColor:
                      selectedGenre == 'Science' ? Colors.blue : null,
                  selectedColor: Colors.white,
                  checkmarkColor: Colors.black,
                ),
                FilterChip(
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Technology', style: _charterStyle),
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedGenre = 'Technology';
                    });
                  },
                  selected: selectedGenre == 'Technology',
                  backgroundColor:
                      selectedGenre == 'Technology' ? Colors.blue : null,
                  selectedColor: Colors.white,
                  checkmarkColor: Colors.black,
                ),
              ],
            ),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Content:',
                style: _charterStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
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
            ),
            SizedBox(height: 100.0),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            top: 20,
            right: 0,
            child: Container(
              width: 120,
              height: 40,
              child: FloatingActionButton.extended(
                onPressed: () {
                  // Handle submit button logic
                },
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Publish', style: TextStyle(color: Colors.white, fontFamily: 'Charter')),
                ),
                backgroundColor: Colors.blue,
                icon: Icon(Icons.send),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
