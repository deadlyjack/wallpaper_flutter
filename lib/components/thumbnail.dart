import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Thumbnail extends StatefulWidget {
  final String label;
  final int index;
  final Color color;
  final ImageProvider? image;
  final void Function()? onPressed;
  final Future<ImageProvider> Function()? futureImage;

  const Thumbnail({
    Key? key,
    required this.label,
    required this.index,
    this.color = const Color(0xff1c1a32),
    this.image,
    this.onPressed,
    this.futureImage,
  }) : super(key: key);

  @override
  _ThumbnailState createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  static const MIN_MARGIN = 10.0;
  late double marginSize;
  late Size size;
  late double width;
  late double height;
  late EdgeInsets margin;
  ImageProvider? image;

  @override
  void initState() {
    final futureImage = widget.futureImage;

    if (futureImage != null) {
      futureImage().then((img) {
        setState(() {
          image = img;
        });
      });
    } else {
      image = widget.image;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    marginSize = ((size.width - 400) / 3)+MIN_MARGIN;
    width = (size.width - (marginSize * 3)) / 2;
    height = width * 1.5;

    margin = EdgeInsets.fromLTRB(marginSize, marginSize, marginSize, 0);
    if (widget.index % 2 == 0) {
      margin = EdgeInsets.fromLTRB(0, marginSize, 0, 0);
    }
    final img = image;
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: widget.onPressed,
      child: Container(
        margin: margin,
        child: SizedBox(
          width: width,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                image: (img != null)
                    ? DecorationImage(
                        image: img,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: Container()),
                  _cardTitle(widget.label),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _cardTitle(String label) {
    return Container(
      height: 60.0,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: const Color(0xffffffff),
          ),
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
          colors: [
            const Color(0x00000000),
            const Color(0x11000000),
            const Color(0x66000000),
            const Color(0x99000000),
          ],
        ),
      ),
    );
  }
}
