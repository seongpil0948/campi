part of './index.dart';

// TODO: Study
// class TransparentPointer extends SingleChildRenderObjectWidget {
//   const TransparentPointer({
//     Key? key,
//     this.transparent = true,
//     required this.child,
//   }) : super(key: key, child: child);
//   bool transparent;
//   final Widget child;

//   @override
//   RenderTransparentPointer createRenderObject(BuildContext context) {
//     return RenderTransparentPointer(
//       transparent: transparent, child: child.,
//     );
//   }

//   @override
//   void updateRenderObject(
//       BuildContext context, RenderTransparentPointer renderObject) {
//     renderObject.transparent = transparent;
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DiagnosticsProperty<bool>('transparent', transparent));
//   }
// }

// class RenderTransparentPointer extends RenderProxyBox {
//   RenderTransparentPointer({
//     required this.child,
//     this.transparent = true,
//   });
//   final RenderBox child;
//   final bool transparent;

//   @override
//   bool hitTest(BoxHitTestResult result, {@required Offset position}) {
//     // forward hits to our child:
//     final hit = super.hitTest(result, position: position);
//     // but report to our parent that we are not hit when `transparent` is true:
//     return !transparent && hit;
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DiagnosticsProperty<bool>('transparent', transparent));
//   }
// }
