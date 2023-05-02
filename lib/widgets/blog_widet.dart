import 'package:flutter/material.dart';

import '../model/blog_model.dart';

class BlogWideg extends StatelessWidget {
  final Blog blog;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const BlogWideg({
    Key? key,
    required this.blog,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 100.0,
                  child: ClipOval(
                    child: Image.asset("assets/addimg.png"),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    blog.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                Text(
                  blog.description,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
