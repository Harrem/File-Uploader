import 'package:file_upload/Services/storage_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import '../Services/extended_methods.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlatformFile? file;
  bool colorSwitch = true;
  Color? color1 = Colors.grey[200];
  Color? color2 = Colors.grey[300];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Uploaded Files",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 3,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: color1,
                ),
                child: FutureBuilder<List<Reference>>(
                  future: CloudStorage().showFiles(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          colorSwitch = !colorSwitch;
                          if (index % 2 == 0) {
                            return Container(
                              color: color1,
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Text(
                                      snapshot.data![index].name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      var url = Uri.parse(await snapshot
                                          .data![index]
                                          .getDownloadURL());
                                      if (!await launchUrl(url,
                                          mode: LaunchMode.platformDefault)) {}
                                      debugPrint(url.toString());
                                    },
                                    icon: const Icon(
                                      Icons.download,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container(
                            color: color2,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    snapshot.data![index].name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    var url = Uri.parse(await snapshot
                                        .data![index]
                                        .getDownloadURL());
                                    if (!await launchUrl(url,
                                        mode: LaunchMode.platformDefault)) {}
                                    debugPrint(url.toString());
                                  },
                                  icon: const Icon(
                                    Icons.download,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const Center(
                      child: Text("Network Failed!"),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      file?.name ?? "fileName",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          file = result.files.first;
                          setState(() {});
                        } else {
                          debugPrint("Process canceled");
                        }
                      },
                      child: const Text(
                        "Pick a File",
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // CloudStorage().uploadFile(platformFile: file!);
                        CloudStorage().showFiles();
                      },
                      child: const Text("Upload File"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
