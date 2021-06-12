import 'dart:typed_data';

import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends HookWidget {
  final picker = ImagePicker();
  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    final imageData = useState(Uint8List(0));
    final slideValue = useState(1.0);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InteractiveViewer(
              child: DoughRecipe(
                  data: DoughRecipeData(
                    viscosity: 1500,
                    adhesion: 12,
                    expansion: slideValue.value,
                    usePerspectiveWarp: true,
                    perspectiveWarpDepth: 0.02,
                    entryDuration: Duration(milliseconds: 450),
                    entryCurve: Curves.easeOutQuad,
                    exitDuration: Duration(milliseconds: 1200),
                    exitCurve: Curves.elasticIn,
                  ),
                  child: PressableDough(
                    child: isInit == true
                        ? Image.asset('assets/pick.png', fit: BoxFit.contain)
                        : Image.memory(imageData.value),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Slider(
                value: slideValue.value,
                min: 1,
                max: 3,
                onChanged: (value) {
                  print(value);
                  slideValue.value = value;
                }),
          ),
          ElevatedButton(
            onPressed: () async {
              final file = await picker.getImage(source: ImageSource.gallery);
              final image = await file!.readAsBytes();
              imageData.value = image;
              isInit = false;
            },
            child: Text('選ぶ'),
          ),
        ],
      ),
    );
  }
}
