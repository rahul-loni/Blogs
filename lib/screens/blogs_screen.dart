import 'package:flutter/material.dart';
import 'package:sqllite_db/model/blog_model.dart';
import 'package:sqllite_db/screens/blog_screen.dart';
import 'package:sqllite_db/services/database_helper.dart';
import 'package:sqllite_db/widgets/blog_widet.dart';

class Blogs extends StatelessWidget {
  const Blogs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: Text("Blogs"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlogScreen(),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        body: FutureBuilder<List<Blog>?>(
          future: DataBaseHelper.getAllBlog(),
          builder: (context, AsyncSnapshot<List<Blog>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                return ListView.builder(
                  itemBuilder: (context, index) => BlogWideg(
                    blog: snapshot.data![index],
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlogScreen(
                                    blog: snapshot.data![index],
                                  )));
                    },
                    onLongPress: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                                "Are you Sure you want to delete thi blog"),
                            actions: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                ),
                                onPressed: () async {
                                  await DataBaseHelper.deleteBlog(
                                      snapshot.data![index]);
                                  Navigator.pop(context);
                                },
                                child: Text("yes"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("No"),
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                  itemCount: snapshot.data!.length,
                );
              }
              return const Center(
                child: Text("No Blogs yet"),
              );
            }
            return const SizedBox.shrink();
          },
        ));
  }
}
