import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
//
//import 'package:image_picker_type/image_picker_type.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poframer/widgets/widgettoimage.dart';
import 'package:share_plus/share_plus.dart';

import '../services/utils.dart';
import 'custom_button.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  late double height;
  late double width;
  GlobalKey? key1;
  Uint8List? bytes1;
  int imageIndex = 1;
  int stepperIndex = 0;
  final _picker = ImagePicker();
  CroppedFile? croppedFile;
  late BannerAd bannerAd;
  bool isAdLoaded = false;

  List<int> imgList = [1, 2, 3, 4];

  @override
  void initState() {
    super.initState();
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-7174205323795454/3711301995",
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        }),
        request: AdRequest());

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomSheet: isAdLoaded
          ? SizedBox(
              height: bannerAd.size.height.toDouble(),
              // width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd))
          : const SizedBox.shrink(),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child:
                Hero(tag: "DemoTag", child: Image.asset("images/lp_icon.png")),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Stepper(
                    type: StepperType.horizontal,
                    currentStep: stepperIndex,
                    onStepCancel: () {
                      if (stepperIndex > 0) {
                        setState(() {
                          stepperIndex -= 1;
                        });
                      }
                    },
                    onStepContinue: () {
                      if (stepperIndex == 0 && _image == null) {
                        Fluttertoast.showToast(
                            msg: "Upload your Image",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.blue[800],
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                      if (stepperIndex <= 1) {
                        setState(() {
                          stepperIndex += 1;
                        });
                      }
                    },
                    onStepTapped: (int index) {
                      if (_image == null) {
                        Fluttertoast.showToast(
                            msg: "Upload your Image",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                      setState(() {
                        stepperIndex = index;
                      });
                    },
                    steps: <Step>[
                      Step(
                        title: const Text('Upload'),
                        content: Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    openImagePicker(context);
                                  },
                                  child: _image == null
                                      ? CircleAvatar(
                                          radius: 100,
                                          backgroundColor: Colors.grey[700],
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(
                                                Icons.photo,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Upload your photo",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 100,
                                          backgroundImage: FileImage(_image!),
                                        ),
                                ),
                              ],
                            )),
                      ),
                      Step(
                        title: const Text('Select'),
                        content: Column(
                          children: [
                            CarouselSlider(
                                items: imgList
                                    .map((e) => Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            _image == null
                                                ? Container()
                                                : getImagePosition(e),
                                            e == 4
                                                ? Image.asset(
                                                    "images/frame$e.png",
                                                    height: height * 0.40,
                                                    fit: BoxFit.fitHeight,
                                                  )
                                                : Image.asset(
                                                    "images/frame$e.png",
                                                  ),
                                          ],
                                        ))
                                    .toList(),
                                options: CarouselOptions(
                                  height: 400,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 0.9,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, _) {
                                    setState(() {
                                      imageIndex = index + 1;
                                    });
                                  },
                                  scrollDirection: Axis.horizontal,
                                )),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                width: double.infinity,
                                color: Colors.grey,
                                child: const Center(
                                  child: Text("SWIPE >>>>",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ))
                          ],
                        ),
                      ),
                      Step(
                          title: const Text('Download!'),
                          content: Column(
                            children: [
                              _image == null
                                  ? Container()
                                  : WidgetToImage(builder:
                                      (GlobalKey<State<StatefulWidget>> key) {
                                      key1 = key;
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          _image == null
                                              ? Container()
                                              : getSingleImagePosition(
                                                  imageIndex),
                                          imageIndex == 4
                                              ? Image.asset(
                                                  "images/frame$imageIndex.png",
                                                  height: height * 0.40,
                                                  fit: BoxFit.fitHeight,
                                                )
                                              : Image.asset(
                                                  "images/frame$imageIndex.png",
                                                  //   width: width * 0.5,
                                                ),
                                        ],
                                      );
                                    }),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                color: Colors.green,
                                buttonText: "Save to Gallery",
                                function: () async {
                                  showInSnackBar(
                                      "Saving to Gallery...", context);
                                  bytes1 = await Utils.capture(key1!);

                                  final result =
                                      await ImageGallerySaver.saveImage(
                                          Uint8List.fromList(bytes1!.toList()),
                                          quality: 100,
                                          name: "poframe");
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              "images/job_done.png",
                                              width: 100,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              "Image saved to Gallery",
                                              style: TextStyle(),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              "Share aggressively!!!😉",
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomButton(
                                color: Colors.red,
                                buttonText: "Share",
                                function: () async {
                                  if (_image == null) {
                                    Utils().displayToast("upload your image");
                                  } else {
                                    bool isPermitted =
                                        await Permission.storage.isGranted;
                                    if (isPermitted)
                                      work();
                                    else {
                                      await Permission.storage
                                          .request()
                                          .then((value) => work());
                                    }
                                  }
                                },
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getImagePosition(int index) {
    switch (index) {
      case 1:
        return Positioned(
            child: Center(
                child: Image.file(
          _image!,
          //   width: width * 0.90,
        )));
      case 2:
        return Positioned(
            top: width * 0.22,
            // right: width * 0.38,
            // left: width * 0.21,
            child: Center(
                child: Image.file(
              _image!,
              width: width * 0.66,
            )));
      case 3:
        return Positioned(
            top: width * 0.21,
            left: width * 0.19,
            child: Center(
                child: ClipRect(
              child: Image.file(
                _image!,
                width: width * 0.70,
              ),
            )));
      case 4:
        return Positioned(
            top: width * 0.255,
            child: Center(
                child: ClipRect(
              child: Image.file(
                _image!,
                width: width * 0.70,
              ),
            )));
      default:
        return Container();
    }
  }

  Widget getSingleImagePosition(int index) {
    switch (index) {
      case 1:
        return Positioned(
            child: Center(
                child: Image.file(
          _image!,
          filterQuality: FilterQuality.none,
          //   width: width * 0.50,
        )));
      case 2:
        return Positioned(
            top: width * 0.12,
            // right: width * 0.38,
            // left: width * 0.21,
            child: Center(
                child: Image.file(
              _image!,
              width: width * 0.75,
            )));
      case 3:
        return Positioned(
            top: width * 0.06,
            left: width * 0.22,
            child: Center(
                child: ClipRect(
              child: Image.file(
                _image!,
                width: width * 0.77,
              ),
            )));
      case 4:
        return Positioned(
            top: width * 0.20,
            child: Center(
                child: ClipRect(
              child: Image.file(
                _image!,
                width: width * 0.8,
              ),
            )));
      default:
        return Container();
    }
  }

  void work() async {
    bytes1 = await Utils.capture(key1!);
    showInSnackBar("Sharing Your Frame...", context);
    final Directory? temp = await getExternalStorageDirectory();
    final File imageFile = File('${temp!.path}/poFrameImage.jpg');
    imageFile.writeAsBytesSync(bytes1!.toList());
    Share.shareFiles(
      ['${temp.path}/poFrameImage.jpg'],
      text: ""
          "Hey Obidients!, I just created this beautiful frame with the poframe app ",
    );
  }

  showInSnackBar(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void openImagePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext ctx) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.camera, color: Colors.blue),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Camera",
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
            onPressed: () async {
              final pickedFile =
                  await _picker.pickImage(source: ImageSource.camera);

              if (pickedFile != null) {
                _image = File(pickedFile.path);

                croppedFile = await ImageCropper().cropImage(
                  sourcePath: pickedFile.path,
                  aspectRatioPresets: [
                    CropAspectRatioPreset.square,
                  ],
                  uiSettings: [
                    AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.blue[900],
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: true),
                    IOSUiSettings(
                      title: 'Cropper',
                    ),
                    WebUiSettings(
                      context: context,
                    ),
                  ],
                );

                _image = File(croppedFile!.path);

                setState(() {});
              } else {}
              Navigator.pop(ctx);
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.image, color: Colors.blue),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Gallery",
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
            onPressed: () async {
              final pickedFile =
                  await _picker.pickImage(source: ImageSource.gallery);

              if (pickedFile != null) {
                _image = File(pickedFile.path);

                croppedFile = await ImageCropper().cropImage(
                  sourcePath: pickedFile.path,
                  aspectRatioPresets: [
                    CropAspectRatioPreset.square,
                  ],
                  uiSettings: [
                    AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.blue[900],
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: true),
                    IOSUiSettings(
                      title: 'Cropper',
                    ),
                    WebUiSettings(
                      context: context,
                    ),
                  ],
                );

                _image = File(croppedFile!.path);

                setState(() {});
              } else {}
              Navigator.pop(ctx);
            },
          )
        ],
      ),
    );
  }
}
