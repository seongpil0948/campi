import 'package:campi/components/assets/carousel.dart';
import 'package:campi/components/layout/piffold.dart';
import 'package:campi/components/structs/store/product.dart';
import 'package:campi/modules/store/state.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:provider/provider.dart';

class StorePage extends StatelessWidget {
  const StorePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final headLineStyle = Theme.of(context).textTheme.headline6;
    final headLineLeftW = SizedBox(width: mq.size.width / 20);
    final rankProds = rankProducts.map((e) => Image.asset(e)).toList();
    final gridProds = gridProducts.map((e) => Image.asset(e)).toList();
    final prodInfos = getProds(15).toList();

    return Piffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: PiDotCorousel(
                imgs: storeBannerImgs
                    .map((path) => Image.asset(
                          path,
                          width: mq.size.width,
                          fit: BoxFit.cover,
                        ))
                    .toList())),
        Container(
            height: mq.size.height / 1.65,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: GridView.builder(
                itemCount: 2 * 2,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  // childAspectRatio: 3 / 2
                ),
                itemBuilder: (context, idx) =>
                    Stack(fit: StackFit.expand, children: [
                      rankProds[idx],
                      Positioned(
                          top: -5,
                          left: 10,
                          child: Container(
                            height: 50,
                            width: 22,
                            color: Theme.of(context).primaryColor,
                            child: Center(
                              child: Text(
                                "\n ${idx + 1}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ))
                    ]))),
        _HeadLine(
          headLineLeftW: headLineLeftW,
          headLineStyle: headLineStyle,
          title: "BEST",
        ),
        SizedBox(
          width: mq.size.width - 10,
          height: mq.size.height / 4,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) => Container(
              width: mq.size.width / 3,
              margin: const EdgeInsets.only(right: 10),
              child: InheritProduct(
                  prodInfo: prodInfos[index],
                  size: ProductCardSize.small,
                  child: const ProductCard()),
            ),
          ),
        ),
        const Divider(),
        Container(
            height: mq.size.height / 2.2,
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: GridView.builder(
                itemCount: 6,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  // childAspectRatio: 3 / 2
                ),
                itemBuilder: (context, idx) => gridProds[idx])),
        _HeadLine(
          headLineLeftW: headLineLeftW,
          headLineStyle: headLineStyle,
          title: "캠핑 페스타 핫딜",
        ),
        GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: prodInfos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.6
                // childAspectRatio: 3 / 2
                ),
            itemBuilder: (context, idx) => InheritProduct(
                prodInfo: prodInfos[idx],
                size: ProductCardSize.medium,
                child: const ProductCard()))
      ]),
    )));
  }
}

class _HeadLine extends StatelessWidget {
  const _HeadLine({
    Key? key,
    required this.headLineLeftW,
    required this.headLineStyle,
    required this.title,
  }) : super(key: key);

  final SizedBox headLineLeftW;
  final TextStyle? headLineStyle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            headLineLeftW,
            Text(title, style: headLineStyle),
            const Spacer(),
            const Text("+더보기")
          ],
        ),
        const Divider()
      ],
    );
  }
}
