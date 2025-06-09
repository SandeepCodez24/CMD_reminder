import 'package:cmd_forntend/constants/strings.dart';
import 'package:cmd_forntend/constants/url.dart';
import 'package:cmd_forntend/widgets/PackageDialog.dart';
import 'package:cmd_forntend/widgets/gridCard.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> imageList = AppUrl.imageUrlLists;
  final List<String> boxName = [
    AppStrings.ML_Package,
    AppStrings.firebaseCommands,
    AppStrings.flutterCommands,
    AppStrings.gitCommands,
    AppStrings.linuxCommands,
    AppStrings.macOScommands,
    AppStrings.python_Commands,
    AppStrings.windowComands,
  ];

  bool _isHover = false;
  bool _isAddClicked = false;
  void _OnHover(isHover) {
    setState(() {
      _isHover = isHover;
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return PackageDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Stack(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: boxName.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      GridCardwidget(
                        iteam: boxName[index],
                        iteamIcon: AppStrings.icons[index],
                        iteamColor: AppStrings.colors[index],
                        iteamImage: imageList[index],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          Positioned(
            bottom: 10,
            right: 20,
            child: MouseRegion(
              onEnter: (event) => _OnHover(true),
              onExit: (event) => _OnHover(false),
              child: InkWell(
                onTap:
                    () => setState(() {
                      _isAddClicked = true;
                      _showDialog(context);
                    }),
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: _isHover ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: _isHover ? null : BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Icon(Icons.add, size: 40, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
