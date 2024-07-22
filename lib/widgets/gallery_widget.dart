import 'package:expense_tracker/widgets/expense_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../util/functions.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget({super.key, required this.views});

  final Map<int, bool> views;

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> with Functions {
  bool loading = false;
  String? path;

  @override
  Widget build(BuildContext context) {
    getPath().then((value) {
      setState(() {
        path = value;
      });
    });
    return Visibility(
      visible: widget.views[3]!,
      child: FutureBuilder(
        future: getAllReceipts(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const ExpenseEmptyWidget(subtitle: "No data available!");
            } else {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Color.fromARGB(255, 0, 182, 218),
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          loading = true;
                          clearGallery(snapshot.data!);
                          loading = false;
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: loading,
                    child: const CircularProgressIndicator(),
                  ),
                  GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 150,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: InstaImageViewer(
                                  child: Card(
                                child: Image.asset(
                                  "$path/${snapshot.data![index].name}",
                                  width: 50,
                                ),
                              )),
                            ),
                            Text(
                              snapshot.data![index].name,
                              style: const TextStyle(
                                fontSize: 11,
                              ),
                            ),
                          ],
                        );
                      })
                ],
              );
            }
          } else {
            return const ExpenseEmptyWidget(subtitle: "No data available");
          }
        }),
      ),
    );
  }
}
