import 'package:flutter/material.dart';
import 'package:siyatech_assig_app/Model/Comment.dart';
import 'package:siyatech_assig_app/screens/Comments_screen.dart';
import 'package:siyatech_assig_app/utils/Extantion.dart';
import 'package:siyatech_assig_app/widgets/Comment_buttom_sheet_tile.dart';
import '../utils/Constants.dart';

class NewsItem extends StatelessWidget {
  final String category;
  final String title;
  final String author;
  final String urllaunch;
  final List<int> commentlistID;
  final int time;
  NewsItem({
    required this.urllaunch,
    required this.commentlistID,
    required this.time,
    required this.category,
    required this.title,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Utility.launchURL(urllaunch);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(width: 0.3)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Text(
                    Utility.formatDate(time),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_bubble_outline,
                          size: 16, color: Colors.black54),
                      4.toSpace,
                      InkWell(
                        onTap: () {
                          _showCommentsBottomSheet(context, commentlistID);
                        },
                        child: Text(
                          "Comments(${commentlistID.length.toString()})",
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                  Text("by-$author")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, List<int> comments) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CommentScreen(
        ids: comments,
      ),
    );
  }
}
