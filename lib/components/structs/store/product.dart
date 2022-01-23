import 'package:campi/modules/store/state.dart';
import 'package:campi/utils/parsers.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

enum ProdCardType { topImgBottomInfo, detail }
enum ProdInfoType { common, detail }

class ProductCard extends StatelessWidget {
  final ProdCardType cType;
  const ProductCard({Key? key, this.cType = ProdCardType.topImgBottomInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (cType) {
      case ProdCardType.topImgBottomInfo:
        return const _ProdBottom();
      case ProdCardType.detail:
        return const _ProdBottom(iType: ProdInfoType.detail);
    }
  }
}

class _ProdBottom extends StatelessWidget {
  final ProdInfoType iType;
  const _ProdBottom({Key? key, this.iType = ProdInfoType.common})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final I = InheritProduct.of(context);
    final size = MediaQuery.of(context).size;
    return InkWell(
        onTap: () => context
            .read<NavigationCubit>()
            .push(storeDetailPath, {"selectedProd": I.prodInfo}),
        child: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              image: AssetImage(I.prodInfo.imgPath),
              height: I.imgHeight,
              width: size.width,
            ),
          ),
          const ProductInfoW()
        ]));
  }
}

class ProductInfoW extends StatelessWidget {
  final ProdInfoType iType;
  final InheritProduct? prod;
  const ProductInfoW({Key? key, this.prod, this.iType = ProdInfoType.common})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (iType) {
      case ProdInfoType.common:
        return _ProdInfocommon(prod: prod);
      case ProdInfoType.detail:
        return _ProdInfocommon(prod: prod);
    }
  }
}

class _ProdInfocommon extends StatelessWidget {
  final InheritProduct? prod;
  const _ProdInfocommon({Key? key, this.prod}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final I = prod ?? InheritProduct.of(context);
    final T = Theme.of(context).textTheme;
    final isSmall = I.size == ProductCardSize.small;
    final prodInfo = I.prodInfo;
    final int salePercent = 100 -
        (priceToInt(prodInfo.salesPrice) /
                priceToInt(prodInfo.consumerPrice) *
                100)
            .round();

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.symmetric(vertical: 3),
              child: Text(prodInfo.brand, style: isSmall ? T.caption : null)),
          Text(prodInfo.title, style: !isSmall ? T.subtitle1 : null),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "$salePercent% ",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Text(
                "${prodInfo.salesPrice}원",
                style: !isSmall ? T.headline6 : null,
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text("리뷰 ${prodInfo.reviewCount} ",
                style: isSmall ? T.caption : null),
            const SizedBox(width: 10),
            Icon(Icons.star, size: isSmall ? 10 : null),
            const SizedBox(width: 5),
            Text("4.5", style: isSmall ? T.caption : null)
          ])
        ]);
  }
}

class InheritProduct extends InheritedWidget {
  const InheritProduct({
    required Widget child,
    required this.prodInfo,
    required this.size,
    this.imgHeight,
    LocalKey? key,
  }) : super(child: child, key: key);
  final ProductInfo prodInfo;
  final ProductCardSize size;
  final double? imgHeight;
  static InheritProduct of(BuildContext context) {
    InheritProduct? result =
        context.dependOnInheritedWidgetOfExactType<InheritProduct>();
    assert(result != null, 'No InheritProduct found in context');
    return result!;
  }

  // either rebuild or not
  @override
  bool updateShouldNotify(InheritProduct oldWidget) {
    return true;
  }
}
