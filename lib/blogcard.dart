import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:intl/intl.dart';

String formatDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  String day = date.day.toString();
  String month = DateFormat.MMM().format(date);
  String year = date.year.toString();
  String formattedDate =
      '$day${getOrdinalSuffix(int.parse(day))} $month, $year';
  return formattedDate;
}

String getOrdinalSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

class BlogCard extends StatefulWidget {
  final String title;
  final String category;
  final bool isFree;
  final String content;
  final String userid;
  final String author;
  final Timestamp postedAt;

  BlogCard({
    required this.title,
    required this.category,
    required this.isFree,
    required this.content,
    required this.userid,
    required this.author,
    required this.postedAt,
  });
  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  bool isBookmarked = false;

  Future<void> checkBookmarkStatus(String blogId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('saved')
          .doc(blogId)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          isBookmarked = true;
        });
      }
    } catch (e) {
      print('Error checking bookmark status: $e');
    }
  }

  void toggleBookmark(String blogId) async {
    try {
      if (!isBookmarked) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('saved')
            .doc(blogId)
            .set({});
        setState(() {
          isBookmarked = true;
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('saved')
            .doc(blogId)
            .delete();
        setState(() {
          isBookmarked = false;
        });
      }
    } catch (e) {
      print('Error toggling bookmark: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    checkBookmarkStatus(widget.userid);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.black12.withAlpha(30),
        onTap: () {
          if (widget.isFree) {
            // If it's a free article, navigate tog a new page to show the entire article.
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FullArticlePage(
                  blogCard: widget,
                ),
              ),
            );
          } else {
            // If it's a paid article, navigate to the payment page.
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PaymentPage(blogCard: widget),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.title}',
                  style: const TextStyle(
                      fontSize: 32,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Chip(
                    label: Text(
                      '${widget.category}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black,
                    labelPadding: EdgeInsets.symmetric(vertical: -2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // Adjust the value to your preference
                    ),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      '${widget.isFree ? 'Free' : 'Paid'}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black,
                    labelPadding: EdgeInsets.symmetric(vertical: -2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // Adjust the value to your preference
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text('${widget.content.split(' ').take(50).join(' ')} ..',
                  style: TextStyle(fontSize: 15)),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('${FirebaseAuth.instance.currentUser!.displayName}',
                      // style: TextStyle()),
                      Text('${widget.author}', style: TextStyle()),
                      //formatted date
                      Text(formatDate(widget.postedAt.toDate().toString()),
                          style: TextStyle()),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => toggleBookmark(widget.userid),
                        child: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          // Customize color as needed
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          // Add your code for the share action here
                        },
                        child: Icon(Icons.share),
                      ),
                    ],
                  )
                ],
              ),
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

class FullArticlePage extends StatelessWidget {
  final BlogCard blogCard;

  FullArticlePage({required this.blogCard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blogCard.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author and Published Date
              Container(
                margin: EdgeInsets.fromLTRB(50, 50, 20, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          'By ${blogCard.author}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          formatDate(blogCard.postedAt.toDate().toString()),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Blog Content
              Container(
                margin: EdgeInsets.fromLTRB(50, 20, 100, 20),
                child: Text(
                  blogCard.content,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 22,
                    height: 1.4,
                    fontFamily: 'Charter(serif)',
                  ),
                ),
              ),
            ],
            // children: [
            //   Row(
            //     children: [
            //       Icon(Icons.person, color: Colors.grey),
            //       SizedBox(width: 8),
            //       Text(
            //         'By ${blogCard.author}',
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ],
            //   ),
            //   SizedBox(height: 10),
            //   Row(
            //     children: [
            //       Icon(Icons.calendar_today, color: Colors.grey),
            //       SizedBox(width: 8),
            //       Text(
            //         formatDate(blogCard.postedAt.toDate().toString()),
            //         style: TextStyle(
            //           fontSize: 14,
            //           color: Colors.grey,
            //         ),
            //       ),
            //     ],
            //   ),
            //   SizedBox(height: 20),
            //   Container(
            //     margin: EdgeInsets.fromLTRB(50, 50, 20, 20),
            //     child: Text(
            //       blogCard.content,
            //       style: TextStyle(
            //         fontSize: 22,
            //         fontFamily: 'Charter',
            //       ),
            //     ),
            //   ),
            //   SizedBox(height: 20),
            // ],
          ),
        ),
      ),
    );
  }
}

class PaymentPage extends StatelessWidget {
  final BlogCard blogCard;

  PaymentPage({required this.blogCard});

  void handlePaymentSuccess(
      PaymentSuccessResponse response, BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullArticlePage(blogCard: blogCard),
      ),
    );
    log('Success Response: $response');
    Fluttertoast.showToast(
        msg: "SUCCESS: ${response.paymentId!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    log('Error Response: $response');
    Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    log('External SDK Response: $response');
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay for ${blogCard.title}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You are about to pay for ${blogCard.title}'),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () {
                Razorpay razorpay = Razorpay();
                var options = {
                  'key': 'rzp_test_CCSk77uvc7V0l9',
                  'amount': 10000,
                  'name': 'EzBlog',
                  'description': 'EzBlog ${blogCard.title}',
                  'prefill': {
                    'contact': '8888888888',
                    'email': 'test@razorpay.com'
                  }
                };
                razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
                razorpay.on(
                    Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
                razorpay.on(
                    Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
                razorpay.open(options);
                debugPrint(razorpay.toString());
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
 
 
// class BlogCard extends StatelessWidget {
//   // Properties
  

  

  
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(8),
//       clipBehavior: Clip.hardEdge,
//       child: InkWell(
//         splashColor: Colors.blue.withAlpha(30),
//         onTap: () {
//           if (isFree) {
//             // If it's a free article, navigate tog a new page to show the entire article.
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => FullArticlePage(
//                   title: title,
//                   content: content,
//                 ),
//               ),
//             );
//           } else {
//             // If it's a paid article, navigate to the payment page.
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => PaymentPage(title: title),
//               ),
//             );
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '$title',
//                 style:
//                     const TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
//               ),
//               SizedBox(
//                 height: 8,
//               ),
//               Chip(
//                 label: Text(
//                   '$category',
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//                 backgroundColor: Colors.black,
//                 labelPadding: EdgeInsets.symmetric(vertical: 0),
//               ),
//               SizedBox(
//                 height: 8,
//               ),
//               Text(
//                 '${content.split(' ').take(50).join(' ')}...', // Display the first 50 words
//                 style: TextStyle(),
//               ),
//               SizedBox(
//                 height: 8,
//               ),
//               Text('$author', style: TextStyle()),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     'Read More',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       elevation: 8,
//       shape: const RoundedRectangleBorder(
//         side: BorderSide(
//           color: Colors.black,
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(12)),
//       ),
//     );
//   }
// }

// class FullArticlePage extends StatelessWidget {
//   final String title;
//   final String content;

//   FullArticlePage({required this.title, required this.content});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 3, // Add a shadow to the card
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0), // Rounded corners
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Container(
//                   margin: EdgeInsets.fromLTRB(50, 50, 20, 20),
//                   child: Text(
//                     content,
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontFamily: 'Charter',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PaymentPage extends StatelessWidget {
//   final String title;

//   PaymentPage({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pay for $title'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('You are about to pay for $title'),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle payment process here
//                 // You can integrate Stripe or any other payment gateway.
//               },
//               child: Text('Pay Now'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
