import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/blog.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;
  const BlogDetailScreen({super.key, required this.blog});

  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogDetailScreen(blog: blog));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(blog.title),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "By ${blog.userName}",
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "${formatDateBydMMYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min",
                style: const TextStyle(
                  color: AppPallete.greyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(blog.imgUrl),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                blog.content,
                style: const TextStyle(fontSize: 16, height: 2),
              )
            ],
          ),
        ),
      ),
    );
  }
}
