// import 'package:campy/components/assets/carousel.dart';
// import 'package:campy/components/buttons/pyffold.dart';
// import 'package:campy/components/structs/store/product.dart';
// import 'package:campy/models/product.dart';
// import 'package:campy/models/state.dart';
// import 'package:flutter/material.dart';
// // ignore: implementation_imports
// import 'package:provider/src/provider.dart';

// class ProductDetailView extends StatelessWidget {
//   const ProductDetailView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);
//     final appState = context.read<PiState>();
//     final info = appState.selectedProd;
//     return Piffold(
//         bSheet: _bottomSheet(),
//         body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Container(
//               margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
//               child: Text("스토어 > 텐트 > 간이 텐트")),
//           PiDotCorousel(
//             imgs: rankProducts.map((path) => Image.asset(
//                   path,
//                   width: mq.size.width,
//                   fit: BoxFit.cover,
//                 )).toList(),
//           ),
//           Container(
//             padding: const EdgeInsets.all(8.0),
//             height: 200,
//             width: mq.size.width,
//             child: ProductInfoW(iType: ProdInfoType.Detail, prod: info),
//           )
//         ]));
//   }
// }

// BottomSheet _bottomSheet() {
//   return BottomSheet(
//       backgroundColor: Colors.white,
//       onClosing: () {
//         print("Closing Prod Detail Bottom SHeet");
//       },
//       builder: (context) {
//         final T = Theme.of(context).textTheme;
//         final size = MediaQuery.of(context).size;
//         return Container(
//             height: size.height / 7,
//             width: size.width,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Divider(
//                   indent: size.width / 10,
//                   endIndent: size.width / 10,
//                 ),
//                 SizedBox(
//                     width: size.width * 0.9,
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ButtonStyle(
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(18.0))),
//                           backgroundColor:
//                               MaterialStateProperty.all<Color>(Colors.white)),
//                       child: Text(
//                         "옵션 선택",
//                         style: T.button,
//                       ),
//                     )),
//                 SizedBox(
//                     width: size.width * 0.9,
//                     child: Row(
//                       children: [
//                         Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               style: ButtonStyle(
//                                   shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(18.0))),
//                                   backgroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           Theme.of(context).primaryColor)),
//                               child: Text(
//                                 "구매하기",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             flex: 3),
//                         Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               style: ButtonStyle(
//                                   shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(18.0))),
//                                   backgroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           Theme.of(context).primaryColor)),
//                               child: Icon(
//                                 Icons.shopping_cart,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             flex: 1)
//                       ],
//                     )),
//               ],
//             ));
//       });
// }
