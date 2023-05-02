import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqllite_db/model/blog_model.dart';
import 'package:sqllite_db/services/database_helper.dart';

class BlogScreen extends StatefulWidget {
  final Blog? blog;

  const BlogScreen({
    Key? key,
    this.blog,
  }) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  File? pickedImage;
  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    if (widget.blog != null) {
      titleController.text = widget.blog!.title;
      descriptionController.text = widget.blog!.description;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.blog == null ? 'Add Blogs' : 'Edit blog'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
        child: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.only(bottom: 20),
            //   child: Center(
            //     child: Text(
            //       "What Are You Thinking about?",
            //       style: TextStyle(
            //         fontSize: 22,
            //         color: Colors.teal,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: InkWell(
                onTap: () {
                  print("Click Image Picker");
                },
                child: Container(
                  height: 200.0,
                  width: 200.0,
                  child: ClipOval(
                    child: pickedImage != null
                        ? Image.file(pickedImage!)
                        : Image.network(
                            'https://www.kindacode.com/wp-content/uploads/2020/11/my-dog.jpg',
                            width: 100,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: SizedBox(
                height: 35,
                child: ElevatedButton(
                  onPressed: imagePickerOption,
                  child: Text("Upload Image "),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              child: TextFormField(
                controller: titleController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Enter Blog Title...",
                  labelText: "Blog Title",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 0.75,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: "Enter Blog Description",
                labelText: "Blog Description",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0.75,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              keyboardType: TextInputType.multiline,
              onChanged: (str) {},
              maxLines: 3,
            ),
            SizedBox(
              height: 26.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 50,
              ),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  child:
                      Text(widget.blog == null ? "Save Blogs" : "Edit Blogs"),
                  onPressed: () async {
                    final title = titleController.value.text;
                    final description = descriptionController.value.text;
                    if (title.isEmpty || description.isEmpty) {
                      return;
                    }
                    final Blog model = Blog(
                        title: title,
                        description: description,
                        //image: image,
                        id: widget.blog?.id);
                    if (widget.blog == null) {
                      await DataBaseHelper.addBlog(model);
                    } else {
                      await DataBaseHelper.updateBlog(model);
                    }
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 0.75,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
