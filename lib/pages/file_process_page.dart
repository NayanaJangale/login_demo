import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart' as i;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileProcessPage extends StatefulWidget {
  @override
  _FileProcessPageState createState() => _FileProcessPageState();
}

class _FileProcessPageState extends State<FileProcessPage> {
  File capturedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIV001793/2021'),
        actions: [
          _actionsPopup(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400],
                  blurRadius: 1.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Text(
              'Container No: 102345/4554/554',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Colors.black54,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              'Container Front Photo ->',
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    //   color: Theme.of(context).primaryColorLight,
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: capturedImage == null
                            ? Center(
                                child: Text(
                                  'Photo',
                                  /*AppTranslations.of(context)
                                                .text("key_load_map"),*/
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Image.file(
                                capturedImage,
                                fit: BoxFit.fill,
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _pickImage(
                                  ImageSource.camera,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                color: Colors.white70,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 20,
                                    ),
                                    Text(
                                      'Click here to add new photo',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                            color: Colors.black,
                                          ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              color: Theme.of(context).accentColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Next', //AppTranslations.of(context).text("key_submit"),
                    style: Theme.of(context).textTheme.body1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _actionsPopup() => PopupMenuButton(
        padding: EdgeInsets.only(right: 10),
        onSelected: (value) {
          //redirect to Sign and submit page
        },
        icon: Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        itemBuilder: (context) {
          var list_new = [
            PopupMenuItem(
              child: Text(
                'Sign and Submit',
                style: Theme.of(context).textTheme.body2.copyWith(
                      color: Colors.black87,
                    ),
              ),
              value: 'sas',
            ),
          ];
          return list_new;
        },
      );

  _pickImage(ImageSource iSource) async {
    var imageFile = await ImagePicker().getImage(
      source: iSource,
      imageQuality: 20,
    );

    String dir = (await getTemporaryDirectory()).path;

    DateTime now = DateTime.now();
    String timeStamp = DateFormat("dd/MM/yyyy HH:mm").format(now);
    String iName = DateFormat("dd-MM-yyyy hh:mm:ss").format(now);

    var imgName = iName;
    String newPath = path.join(dir, '$imgName.png');
    print('NewPath: $newPath');
    File f = await File(imageFile.path).copy(newPath);
    List<int> bytes = await f.readAsBytes();

    const int size = 80;
    final i.ImageEditorOption option = i.ImageEditorOption();
    final i.AddTextOption textOption = i.AddTextOption();
    textOption.addText(
      i.EditorText(
        offset: Offset(1, 1),
        text: timeStamp,
        fontSizePx: size,
        textColor: Colors.red,
      ),
    );

    option.outputFormat = const i.OutputFormat.png();

    option.addOption(textOption);

    final Uint8List result = await i.ImageEditor.editImage(
      image: bytes,
      imageEditorOption: option,
    );
    print(option.toString());
    f.writeAsBytes(result);
    setState(() {
      capturedImage = f;
    });
  }

  _recordVideo(ImageSource iSource) async {
    var imageFile = await ImagePicker().getVideo(
      source: iSource,
      maxDuration: Duration(seconds: 10),
    );

    String dir = (await getTemporaryDirectory()).path;

    DateTime now = DateTime.now();
    String timeStamp = DateFormat("dd/MM/yyyy HH:mm").format(now);
    String iName = DateFormat("dd-MM-yyyy hh:mm:ss").format(now);

    var imgName = iName;
    String newPath = path.join(dir, '$imgName.png');
    print('NewPath: $newPath');
    File f = await File(imageFile.path).copy(newPath);
    List<int> bytes = await f.readAsBytes();

    const int size = 150;
    final i.ImageEditorOption option = i.ImageEditorOption();
    final i.AddTextOption textOption = i.AddTextOption();
    textOption.addText(
      i.EditorText(
        offset: Offset(1, 1),
        text: timeStamp,
        fontSizePx: size,
        textColor: Colors.red,
      ),
    );

    option.outputFormat = const i.OutputFormat.png();

    option.addOption(textOption);

    final Uint8List result = await i.ImageEditor.editImage(
      image: bytes,
      imageEditorOption: option,
    );
    print(option.toString());
    f.writeAsBytes(result);
    setState(() {
      capturedImage = f;
    });
  }
}
