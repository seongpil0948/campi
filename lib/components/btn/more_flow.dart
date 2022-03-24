part of './index.dart';

class MoreMenuFlow extends StatefulWidget {
  const MoreMenuFlow({Key? key}) : super(key: key);

  @override
  _MoreMenuFlowState createState() => _MoreMenuFlowState();
}

class _MoreMenuFlowState extends State<MoreMenuFlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _myAnimation;

  final List<IconData> _icons = <IconData>[
    Icons.more_horiz_rounded,
    Icons.edit,
    Icons.delete_forever_rounded,
  ];

  @override
  void initState() {
    super.initState();

    _myAnimation = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  Widget _buildItem(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: RawMaterialButton(
        fillColor: Colors.cyan,
        shape: const CircleBorder(),
        constraints: BoxConstraints.tight(const Size.square(50.0)),
        onPressed: () {
          _myAnimation.status == AnimationStatus.completed
              ? _myAnimation.reverse()
              : _myAnimation.forward();
        },
        child: Icon(
          icon,
          color: Colors.white,
          size: 30.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
            behavior: HitTestBehavior.translucent,
            onSecondaryTap: () => debugPrint("ON Second Tap Grey "),
            onTap: () => debugPrint("ON Tap Grey"),
            child: Container(color: Colors.grey[200])),
        SizedBox(
          width: 50,
          height: 400,
          child: Positioned(
            right: 0,
            child: Flow(
              delegate: MoreMenuFlowDelegate(myAnimation: _myAnimation),
              children: _icons
                  .map<Widget>((IconData icon) => _buildItem(icon))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class MoreMenuFlowDelegate extends FlowDelegate {
  MoreMenuFlowDelegate({required this.myAnimation})
      : super(repaint: myAnimation);

  final Animation<double> myAnimation;

  @override
  bool shouldRepaint(MoreMenuFlowDelegate oldDelegate) {
    return myAnimation != oldDelegate.myAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = context.childCount - 1; i >= 0; i--) {
      final cs = context.getChildSize(i);
      if (cs != null) {
        double dx = (cs.height + 10) * i;
        context.paintChild(
          i,
          transform:
              Matrix4.translationValues(0, dx * myAnimation.value + 10, 0),
        );
      }
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return const Size(double.maxFinite, double.maxFinite);
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    // return i == 0 ? constraints : BoxConstraints.tight(const Size(50.0, 50.0));
    return BoxConstraints.tight(const Size(50.0, 50.0));
  }
}
