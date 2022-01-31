import 'package:campi/components/assets/carousel.dart';
import 'package:campi/components/layout/piffold.dart';
import 'package:campi/components/structs/store/product.dart';
import 'package:campi/modules/store/state.dart';
import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as PiPageConfig;
    final info = args.args['selectedProd'] as InheritProduct;
    return Piffold(
        bSheet: _bottomSheet(),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: const Text("스토어 > 텐트 > 간이 텐트")),
          PiDotCorousel(
            imgs: rankProducts
                .map((path) => Image.asset(
                      path,
                      width: mq.size.width,
                      fit: BoxFit.cover,
                    ))
                .toList(),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 200,
            width: mq.size.width,
            child: ProductInfoW(iType: ProdInfoType.detail, prod: info),
          )
        ]));
  }
}

BottomSheet _bottomSheet() {
  return BottomSheet(
      backgroundColor: Colors.white,
      onClosing: () {
        debugPrint("Closing Prod Detail Bottom SHeet");
      },
      builder: (context) {
        final T = Theme.of(context).textTheme;
        final size = MediaQuery.of(context).size;
        return SizedBox(
            height: size.height / 7,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Divider(
                  indent: size.width / 10,
                  endIndent: size.width / 10,
                ),
                SizedBox(
                    width: size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0))),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                      child: Text(
                        "옵션 선택",
                        style: T.button,
                      ),
                    )),
                SizedBox(
                    width: size.width * 0.9,
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0))),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColor)),
                              child: const Text(
                                "구매하기",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            flex: 3),
                        Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0))),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColor)),
                              child: const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                            ),
                            flex: 1)
                      ],
                    )),
              ],
            ));
      });
}
