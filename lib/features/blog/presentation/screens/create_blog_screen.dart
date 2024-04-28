import 'dart:io';
import 'package:blog_app/core/common/cubits/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/image_picker.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/screens/blog_screen.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/constant.dart';

class CreateBlogScreen extends StatefulWidget {
  const CreateBlogScreen({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const CreateBlogScreen());

  @override
  State<CreateBlogScreen> createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> selectedTopics = [];
  File? selectedImage;

  void selectBlogImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  void submitBlogCreateForm() {
    if (_formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        selectedImage != null) {
      final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;

      context.read<BlogBloc>().add(BlogUploadEvent(
          userId: user.id,
          title: blogTitleController.text.trim(),
          content: blogEditorController.text.trim(),
          image: selectedImage!,
          topics: selectedTopics));
    }
  }

  TextEditingController blogTitleController = TextEditingController();
  TextEditingController blogEditorController = TextEditingController();

  @override
  void dispose() {
    blogTitleController.dispose();
    blogEditorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create new blog"),
        actions: [
          IconButton(
              onPressed: submitBlogCreateForm,
              icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error, Colors.red);
          } else if (state is BlogSuccess) {
            Navigator.pushAndRemoveUntil(
                context, BlogScreen.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  selectedImage != null
                      ? GestureDetector(
                          onTap: selectBlogImage,
                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: selectBlogImage,
                          child: DottedBorder(
                            color: AppPallete.borderColor,
                            dashPattern: const [20, 4],
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            strokeCap: StrokeCap.round,
                            child: const SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.folder_open,
                                    size: 50,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Select your image',
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: Constant.blogTopics
                          .map(
                            (topic) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  selectedTopics.contains(topic)
                                      ? selectedTopics.remove(topic)
                                      : selectedTopics.add(topic);
                                  setState(() {});
                                },
                                child: Chip(
                                  label: Text(topic),
                                  color: selectedTopics.contains(topic)
                                      ? const MaterialStatePropertyAll(
                                          AppPallete.gradient1)
                                      : null,
                                  side: selectedTopics.contains(topic)
                                      ? null
                                      : const BorderSide(
                                          color: AppPallete.borderColor),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BlogEditorWidget(
                      textEditingController: blogTitleController,
                      hintText: "Blog Title"),
                  const SizedBox(
                    height: 15,
                  ),
                  BlogEditorWidget(
                      textEditingController: blogEditorController,
                      hintText: "Blog Content"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
