import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'file_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FileManager(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final fileManager = Provider.of<FileManager>(context);

    return Scaffold(
      appBar: AppBar(title: Text('YourSave')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(labelText: 'Enter Video URL'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final qualities = await fileManager.getVideoQualities(urlController.text);
                showModalBottomSheet(
                  context: context,
                  builder: (_) => ListView.builder(
                    itemCount: qualities.length,
                    itemBuilder: (_, index) {
                      final quality = qualities[index];
                      return ListTile(
                        title: Text('${quality.height}p'),
                        onTap: () => fileManager.downloadVideo(
                          urlController.text,
                          quality,
                        ),
                      );
                    },
                  ),
                );
              },
              child: Text('Fetch and Download Video'),
            ),
            Expanded(
              child: FutureBuilder(
                future: fileManager.loadFiles(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: fileManager.files.length,
                    itemBuilder: (_, index) {
                      final file = fileManager.files[index];
                      return ListTile(
                        title: Text(file.uri.pathSegments.last),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

