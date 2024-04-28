import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/presentation/screens/blog_detail_screen.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../domain/entities/blog.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16).copyWith(bottom: 4),
      padding: const EdgeInsets.all(16),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(context, BlogDetailScreen.route(blog)),
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: blog.topics
                      .map(
                        (topic) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Chip(
                            label: Text(topic),
                            side:
                                const BorderSide(color: AppPallete.borderColor),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Text(
                blog.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Expanded(child: SizedBox()),
              Text("${calculateReadingTime(blog.content)} min")
            ],
          ),
        ),
      ),
    );
  }
}
