import 'package:cmd_forntend/screens/PackageDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GridCardwidget extends StatefulWidget {
  final String iteam;
  final IconData iteamIcon;
  final Color iteamColor;
  final String iteamImage;
  const GridCardwidget({
    super.key,
    required this.iteam,
    required this.iteamIcon,
    required this.iteamColor,
    required this.iteamImage,
  });

  @override
  State<GridCardwidget> createState() => _GridCardwidgetState();
}

class _GridCardwidgetState extends State<GridCardwidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _gridController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHover = false;

  @override
  void initState() {
    _gridController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _gridController, curve: Curves.easeOutBack),
    );

    _elevationAnimation = Tween<double>(begin: 2.0, end: 16.0).animate(
      CurvedAnimation(parent: _gridController, curve: Curves.easeOutBack),
    );

    _gridController.addListener(() {
      print('Animation value: ${_gridController.value}');
    });
  }

  @override
  void dispose() {
    _gridController.dispose();
    super.dispose();
  }

  void OnHover(bool isHover) {
    setState(() {
      _isHover = isHover;
    });

    if (_isHover) {
      _gridController.forward();
    } else {
      _gridController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return MouseRegion(
      onEnter: (_) => OnHover(true),
      onExit: (_) => OnHover(false),
      child: AnimatedBuilder(
        animation: _gridController,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..scale(_scaleAnimation.value)
                  ..translate(0.0, 0.0, _isHover ? 250.0 : 0.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value / 2),
                  ),
                ],
              ),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
                child: InkWell(
                  onTap: () {
                    // go to collection page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                PackageListWidget(title: widget.iteam,commandType: widget.iteam,),
                      ),
                    );
                  },
                  child: Container(
                    height: screenHeight * 0.3,
                    width: screenWidth * 0.2,
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment:
                          _isHover
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.iteamIcon,
                          size: _isHover ? 30 : 40,
                          color: widget.iteamColor,
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.iteam,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize:
                                _isHover
                                    ? screenWidth * 0.011
                                    : screenWidth * 0.014,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _isHover
                            ? Column(children: [Text('comming Soon')])
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
