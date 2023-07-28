import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/rating_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/products_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_image_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/favourite_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/promise_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/seller_view.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/bottom_cart_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_image_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_specification_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_title_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/related_product_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/review_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/youtube_video_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'faq_and_review_screen.dart';

class ProductDetails extends StatefulWidget {
  final int productId;
  final String slug;
  final bool isFromWishList;

  ProductDetails(
      {@required this.productId,
      @required this.slug,
      this.isFromWishList = false});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int selectedIndex = 0;

  _loadData(BuildContext context) async {
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getProductDetails(context, widget.slug.toString());
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .removePrevReview();
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .initProduct(widget.productId, widget.slug, context);
    Provider.of<ProductProvider>(context, listen: false)
        .removePrevRelatedProduct();
    Provider.of<ProductProvider>(context, listen: false)
        .initRelatedProductList(widget.productId.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getCount(widget.productId.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getSharableLink(widget.slug.toString(), context);
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<WishListProvider>(context, listen: false)
          .checkWishList(widget.productId.toString(), context);
    }

    if (Provider.of<ProductDetailsProvider>(context, listen: false)
            .variantIndex >=
        Provider.of<ProductDetailsProvider>(context, listen: false)
            .productDetailsModel
            .images
            .length) {
      selectedIndex =
          Provider.of<ProductDetailsProvider>(context, listen: false)
                  .variantIndex -
              (Provider.of<ProductDetailsProvider>(context, listen: false)
                      .productDetailsModel
                      .colors
                      .length -
                  Provider.of<ProductDetailsProvider>(context, listen: false)
                      .productDetailsModel
                      .images
                      .length);
    } else {
      selectedIndex =
          Provider.of<ProductDetailsProvider>(context, listen: false)
              .variantIndex;
    }

    print(
        'bangla===>$selectedIndex/${Provider.of<ProductDetailsProvider>(context, listen: false).productDetailsModel.images.length}');
    // Provider.of<ProductProvider>(context, listen: false).initSellerProductList(Provider.of<ProductDetailsProvider>(context, listen: false).productDetailsModel.userId.toString(), 1, context);
  }

  List<Widget> _indicators(BuildContext context, List<String> images) {
    List<Widget> indicators = [];
    for (int index = 0; index < images.length; index++) {
      indicators.add(TabPageSelectorIndicator(
        backgroundColor: index ==
                Provider.of<ProductDetailsProvider>(context).imageSliderIndex
            ? Theme.of(context).primaryColor
            : ColorResources.WHITE,
        borderColor: ColorResources.WHITE,
        size: 10,
      ));
    }
    return indicators;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    _loadData(context);
    return WillPopScope(
      onWillPop: () async {
        if (widget.isFromWishList) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => WishListScreen()));
        } else {
          Navigator.of(context).pop();
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.arrow_back_ios,
                    color: Theme.of(context).cardColor, size: 20),
              ),
              onTap: widget.isFromWishList
                  ? () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (BuildContext context) => WishListScreen()))
                  : () => Navigator.pop(context),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Text(getTranslated('product_details', context),
                style: robotoRegular.copyWith(
                    fontSize: 20, color: Theme.of(context).cardColor)),
          ]),
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
              ? Colors.black
              : Theme.of(context).primaryColor,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _loadData(context);
            return true;
          },
          child: Consumer<ProductDetailsProvider>(
            builder: (context, details, child) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: !details.isDetails
                    ? Column(
                        children: [
                          details.productDetailsModel.imageColors.isEmpty
                              ? ProductImageView(
                                  productModel: details.productDetailsModel)
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ProductImageScreen(
                                                      title: getTranslated(
                                                          'product_image',
                                                          context),
                                                      imageList: details
                                                          .productDetailsModel
                                                          .images))),
                                      child: details
                                                  .productDetailsModel.images !=
                                              null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20)),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey[
                                                          Provider.of<ThemeProvider>(
                                                                      context)
                                                                  .darkTheme
                                                              ? 700
                                                              : 300],
                                                      spreadRadius: 1,
                                                      blurRadius: 5)
                                                ],
                                                gradient:
                                                    Provider.of<ThemeProvider>(
                                                                context)
                                                            .darkTheme
                                                        ? null
                                                        : LinearGradient(
                                                            colors: [
                                                              ColorResources
                                                                  .WHITE,
                                                              ColorResources
                                                                  .IMAGE_BG
                                                            ],
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                          ),
                                              ),
                                              child: Stack(children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  width: double.infinity,
                                                  child: details
                                                              .productDetailsModel
                                                              .images !=
                                                          null
                                                      ? FadeInImage
                                                          .assetNetwork(
                                                          fit: BoxFit.cover,
                                                          placeholder: Images
                                                              .placeholder,
                                                          image: (details.productDetailsModel
                                                                          .colors !=
                                                                      null &&
                                                                  details
                                                                          .productDetailsModel
                                                                          .colors
                                                                          .length >
                                                                      0)
                                                              ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${details.productDetailsModel.images[details.variantIndex]}??'
                                                              : '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${details.productDetailsModel.thumbnail}',
                                                          imageErrorBuilder: (c,
                                                                  o, s) =>
                                                              Image.asset(Images
                                                                  .placeholder),
                                                        )
                                                      // InkWell(
                                                      //         child: FadeInImage
                                                      //             .assetNetwork(
                                                      //           fit: BoxFit.cover,
                                                      //           placeholder:
                                                      //               Images.placeholder,
                                                      //           height:
                                                      //               MediaQuery.of(context)
                                                      //                   .size
                                                      //                   .width,
                                                      //           width:
                                                      //               MediaQuery.of(context)
                                                      //                   .size
                                                      //                   .width,
                                                      //           image:
                                                      //               '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${details.productDetailsModel.images[selectedIndex]}',
                                                      //           imageErrorBuilder:
                                                      //               (c, o, s) =>
                                                      //                   Image.asset(
                                                      //             Images.placeholder,
                                                      //             height: MediaQuery.of(
                                                      //                     context)
                                                      //                 .size
                                                      //                 .width,
                                                      //             width: MediaQuery.of(
                                                      //                     context)
                                                      //                 .size
                                                      //                 .width,
                                                      //             fit: BoxFit.cover,
                                                      //           ),
                                                      //         ),
                                                      //       )
                                                      // PageView.builder(
                                                      //         // controller: _controller,
                                                      //         itemCount: details
                                                      //             .productDetailsModel
                                                      //             .images
                                                      //             .length,
                                                      //         itemBuilder:
                                                      //             (context, index) {
                                                      //           return InkWell(
                                                      //             child: FadeInImage
                                                      //                 .assetNetwork(
                                                      //               fit: BoxFit.cover,
                                                      //               placeholder: Images
                                                      //                   .placeholder,
                                                      //               height: MediaQuery.of(
                                                      //                       context)
                                                      //                   .size
                                                      //                   .width,
                                                      //               width: MediaQuery.of(
                                                      //                       context)
                                                      //                   .size
                                                      //                   .width,
                                                      //               image:
                                                      //                   '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${details.productDetailsModel.images[index]}',
                                                      //               imageErrorBuilder:
                                                      //                   (c, o, s) =>
                                                      //                       Image.asset(
                                                      //                 Images.placeholder,
                                                      //                 height:
                                                      //                     MediaQuery.of(
                                                      //                             context)
                                                      //                         .size
                                                      //                         .width,
                                                      //                 width:
                                                      //                     MediaQuery.of(
                                                      //                             context)
                                                      //                         .size
                                                      //                         .width,
                                                      //                 fit: BoxFit.cover,
                                                      //               ),
                                                      //             ),
                                                      //           );
                                                      //         },
                                                      //         onPageChanged: (index) {
                                                      //           Provider.of<ProductDetailsProvider>(
                                                      //                   context,
                                                      //                   listen: false)
                                                      //               .setImageSliderSelectedIndex(
                                                      //                   index);
                                                      //         },
                                                      //       )
                                                      : SizedBox(),
                                                ),
                                                // Positioned(
                                                //   left: 0,
                                                //   right: 0,
                                                //   bottom: 30,
                                                //   child: Row(
                                                //     mainAxisAlignment:
                                                //         MainAxisAlignment.center,
                                                //     children: [
                                                //       SizedBox(),
                                                //       Spacer(),
                                                //       Row(
                                                //         mainAxisAlignment:
                                                //             MainAxisAlignment.center,
                                                //         children: _indicators(
                                                //             context,
                                                //             details
                                                //                 .productDetailsModel
                                                //                 .images),
                                                //       ),
                                                //       Spacer(),
                                                //       Provider.of<ProductDetailsProvider>(
                                                //                       context)
                                                //                   .imageSliderIndex !=
                                                //               null
                                                //           ? Padding(
                                                //               padding: const EdgeInsets
                                                //                       .only(
                                                //                   right: Dimensions
                                                //                       .PADDING_SIZE_DEFAULT,
                                                //                   bottom: Dimensions
                                                //                       .PADDING_SIZE_DEFAULT),
                                                //               child: Text(
                                                //                   '${Provider.of<ProductDetailsProvider>(context).imageSliderIndex + 1}' +
                                                //                       '/' +
                                                //                       '${details.productDetailsModel.images.length.toString()}'),
                                                //             )
                                                //           : SizedBox(),
                                                //     ],
                                                //   ),
                                                // ),
                                                Positioned(
                                                  top: 16,
                                                  right: 16,
                                                  child: Column(
                                                    children: [
                                                      FavouriteButton(
                                                        backgroundColor:
                                                            ColorResources
                                                                .getImageBg(
                                                                    context),
                                                        favColor:
                                                            Colors.redAccent,
                                                        isSelected: Provider.of<
                                                                    WishListProvider>(
                                                                context,
                                                                listen: false)
                                                            .isWish,
                                                        productId: details
                                                            .productDetailsModel
                                                            .id,
                                                      ),
                                                      SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_SMALL,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          if (Provider.of<ProductDetailsProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .sharableLink !=
                                                              null) {
                                                            Share.share(Provider.of<
                                                                        ProductDetailsProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .sharableLink);
                                                          }
                                                        },
                                                        child: Card(
                                                          elevation: 2,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50)),
                                                          child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Icon(
                                                                Icons.share,
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                size: Dimensions
                                                                    .ICON_SIZE_SMALL),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                details.productDetailsModel
                                                                .unitPrice !=
                                                            null &&
                                                        details.productDetailsModel
                                                                .discount !=
                                                            0
                                                    ? Positioned(
                                                        left: 0,
                                                        top: 0,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .all(Dimensions
                                                                      .PADDING_SIZE_EXTRA_SMALL),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  borderRadius:
                                                                      BorderRadius.only(
                                                                          bottomRight:
                                                                              Radius.circular(Dimensions.PADDING_SIZE_SMALL))),
                                                              child: Text(
                                                                '${PriceConverter.percentageCalculation(context, details.productDetailsModel.unitPrice, details.productDetailsModel.discount, details.productDetailsModel.discountType)}',
                                                                style: titilliumRegular.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .cardColor,
                                                                    fontSize:
                                                                        Dimensions
                                                                            .FONT_SIZE_LARGE),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox.shrink(),
                                                SizedBox.shrink(),
                                              ]),
                                            )
                                          : SizedBox(),
                                    ),
                                  ],
                                ),
                          Container(
                            transform:
                                Matrix4.translationValues(0.0, -25.0, 0.0),
                            padding: EdgeInsets.only(
                                top: Dimensions.FONT_SIZE_DEFAULT),
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                  topRight: Radius.circular(
                                      Dimensions.PADDING_SIZE_EXTRA_LARGE)),
                            ),
                            child: Column(
                              children: [
                                ProductTitleView(
                                    productModel: details.productDetailsModel,
                                    averageRatting: details.productDetailsModel
                                                ?.averageReview !=
                                            null
                                        ? details
                                            .productDetailsModel.averageReview
                                        : "0"),
                                (details.productDetailsModel?.details != null &&
                                        details.productDetailsModel.details
                                            .isNotEmpty)
                                    ? Container(
                                        height: 250,
                                        margin: EdgeInsets.only(
                                            top: Dimensions.PADDING_SIZE_SMALL),
                                        padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_SMALL),
                                        child: ProductSpecification(
                                            productSpecification: details
                                                    .productDetailsModel
                                                    .details ??
                                                ''),
                                      )
                                    : SizedBox(),
                                details.productDetailsModel?.videoUrl != null
                                    ? YoutubeVideoWidget(
                                        url: details
                                            .productDetailsModel.videoUrl)
                                    : SizedBox(),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.PADDING_SIZE_DEFAULT,
                                        horizontal:
                                            Dimensions.FONT_SIZE_DEFAULT),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor),
                                    child: PromiseScreen()),
                                details.productDetailsModel.addedBy == 'seller'
                                    ? SellerView(
                                        sellerId: details
                                            .productDetailsModel.userId
                                            .toString())
                                    : SizedBox.shrink(),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(
                                      top: Dimensions.PADDING_SIZE_SMALL),
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_DEFAULT),
                                  color: Theme.of(context).cardColor,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getTranslated(
                                              'customer_reviews', context),
                                          style: titilliumSemiBold.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE),
                                        ),
                                        SizedBox(
                                          height:
                                              Dimensions.PADDING_SIZE_DEFAULT,
                                        ),
                                        Container(
                                          width: 230,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: ColorResources.visitShop(
                                                context),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions
                                                    .PADDING_SIZE_EXTRA_LARGE),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              RatingBar(
                                                rating: double.parse(details
                                                    .productDetailsModel
                                                    .averageReview),
                                                size: 18,
                                              ),
                                              SizedBox(
                                                  width: Dimensions
                                                      .PADDING_SIZE_DEFAULT),
                                              Text('${double.parse(details.productDetailsModel.averageReview).toStringAsFixed(1)}' +
                                                  ' ' +
                                                  '${getTranslated('out_of_5', context)}'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            height: Dimensions
                                                .PADDING_SIZE_DEFAULT),
                                        Text('${getTranslated('total', context)}' +
                                            ' ' +
                                            '${details.reviewList != null ? details.reviewList.length : 0}' +
                                            ' ' +
                                            '${getTranslated('reviews', context)}'),
                                        details.reviewList != null
                                            ? details.reviewList.length != 0
                                                ? ReviewWidget(
                                                    reviewModel:
                                                        details.reviewList[0])
                                                : SizedBox()
                                            : ReviewShimmer(),
                                        details.reviewList != null
                                            ? details.reviewList.length > 1
                                                ? ReviewWidget(
                                                    reviewModel:
                                                        details.reviewList[1])
                                                : SizedBox()
                                            : ReviewShimmer(),
                                        details.reviewList != null
                                            ? details.reviewList.length > 2
                                                ? ReviewWidget(
                                                    reviewModel:
                                                        details.reviewList[2])
                                                : SizedBox()
                                            : ReviewShimmer(),
                                        InkWell(
                                            onTap: () {
                                              if (details.reviewList != null) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) => ReviewScreen(
                                                            reviewList: details
                                                                .reviewList)));
                                              }
                                            },
                                            child: details.reviewList != null &&
                                                    details.reviewList.length >
                                                        3
                                                ? Text(
                                                    getTranslated(
                                                        'view_more', context),
                                                    style: titilliumRegular
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                  )
                                                : SizedBox())
                                      ]),
                                ),
                                details.productDetailsModel.addedBy == 'seller'
                                    ? Padding(
                                        padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_DEFAULT),
                                        child: TitleRow(
                                            title: getTranslated(
                                                'more_from_the_shop', context),
                                            isDetailsPage: true),
                                      )
                                    : SizedBox(),
                                details.productDetailsModel.addedBy == 'seller'
                                    ? Padding(
                                        padding: EdgeInsets.all(Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                        child: ProductView(
                                            isHomePage: true,
                                            productType:
                                                ProductType.SELLER_PRODUCT,
                                            scrollController: _scrollController,
                                            sellerId: details
                                                .productDetailsModel.userId
                                                .toString()),
                                      )
                                    : SizedBox(),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: Dimensions.PADDING_SIZE_SMALL),
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_DEFAULT),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL,
                                            vertical: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                        child: TitleRow(
                                            title: getTranslated(
                                                'related_products', context),
                                            isDetailsPage: true),
                                      ),
                                      SizedBox(height: 5),
                                      RelatedProductView(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height,
                              child:
                                  Center(child: CircularProgressIndicator())),
                        ],
                      ),
              );
            },
          ),
        ),
        bottomNavigationBar: Consumer<ProductDetailsProvider>(
            builder: (context, details, child) {
          return !details.isDetails
              ? BottomCartView(product: details.productDetailsModel)
              : SizedBox();
        }),
      ),
    );
  }
}
