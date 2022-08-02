import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:manek_tech_practicle/bloc/ProductDataBloc.dart';
import 'package:manek_tech_practicle/db/CrudMethods.dart';
import 'package:manek_tech_practicle/db/Product_Database.dart';
import 'package:manek_tech_practicle/dialogs/AlertDialogBox.dart';
import 'package:manek_tech_practicle/models/Item.dart';
import 'package:manek_tech_practicle/models/response/GetProductResponse.dart';
import 'package:manek_tech_practicle/networking/NetworkConstant.dart';
import 'package:manek_tech_practicle/networking/Response.dart';
import 'package:manek_tech_practicle/pages/CartPage.dart';
import 'package:manek_tech_practicle/utils/AppColors.dart';
import 'package:manek_tech_practicle/utils/Strings.dart';
import 'package:manek_tech_practicle/utils/Styles.dart';
import 'package:manek_tech_practicle/widgets/ToastWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ProductDataBloc productDataBloc;

  List<Product> products = [];

  late ScrollController scrollController = ScrollController();
  bool loading = true;
  bool isMoreData = true;
  int currentPage = 1;
  bool isLadingData = true;
  List<Item> notes = [];
  List<String> ids = [];

/**
 * This Function 
 */
  void callGetProductApi() {
    Map data = {
      NetworkConstant.API_PARAM_PAGE: currentPage.toString(),
      NetworkConstant.API_PARAM_PER_PAGE: '5'
    };

    productDataBloc.callGetProductApi(data);
  }

/**
 * Here ProductDataStream is a listener which will reflect 
 * when data will be loaded from api.
 */
  void getHomePageDataListner() {
    productDataBloc.productDataStream.listen((event) {
      setState(() {
        loading = false;
        isLadingData = false;
      });
      if (event.status == Status.COMPLETED) {
        if (event.data.status == 200) {
          if (event.data.data.length > 5) {
            setState(() {
              isMoreData = true;
            });
          }
          for (int i = 0; i < event.data.data.length; i++) {
            products.add(event.data.data[i]);
          }
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialogBox(
                    errorMessage: event.data.message,
                    onRetryPressed: () {
                      Navigator.of(context).pop();
                    },
                  ));
        }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialogBox(
                  errorMessage: event.message,
                  onRetryPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                ));
      }
    });
  }

  @override
  void initState() {
    productDataBloc = ProductDataBloc();
    getHomePageDataListner();
    refreshNotes();
    callGetProductApi();

/**
 * Scroll controller listner.
 */
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        if (scrollController.position.maxScrollExtent ==
            scrollController.offset) {
          if (isMoreData == true) {
            setState(() {
              currentPage++;
            });
            callGetProductApi();
          }
        }
      }
    });

    super.initState();
  }

/**
 * This Function will Refresh your updated note.
 *  */
  Future refreshNotes() async {
    ids.clear();
    notes = await ProductDatabase.instance.readAllNotes();
    for (int i = 0; i < notes.length; i++) {
      ids.add(notes[i].productId);
    }

    setState(() {});
  }


 @override
  void dispose() {
    scrollController.dispose();
    
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        title: Text(
          widget.title,
          style: appbarTitleStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) =>
                          const CartPage(title: Strings.CART_PAGE_TITLE)))
                  .then((value) {
                refreshNotes();
              });
            },
            icon: const Icon(Icons.shopping_cart_outlined, size: 25),
          )
        ],
      ),
      body: OrientationBuilder(builder: (_, orientation) {
        if (orientation == Orientation.portrait) {
          return _productListProtraitLayout();
        } else {
          return _productListLandscapeLayout();
        }
      }),
    );
  }

  Widget _productListProtraitLayout() {
    return isLadingData == true
        ? shimmerEffectProtraitLayout()
        : SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              DataLoadedGridProtraitLayout(),
              const SizedBox(
                height: 10,
              ),
            ]),
          );
  }

  Widget _productListLandscapeLayout() {
    return isLadingData == true
        ? shimmerEffectLandscapeLayout()
        : SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              DataLoadedGridLandscapeLayout(),
              const SizedBox(
                height: 10,
              ),
            ]),
          );
  }

  Widget DataLoadedGridProtraitLayout() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return Bounce(
                duration: const Duration(milliseconds: 110),
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: AppColors.backgroundColor,
                    child: Container(
                        // ignore: prefer_const_constructors
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 50,
                              top: 10,
                              left: 0,
                              right: 0,
                              child: CachedNetworkImage(
                                imageUrl: products[index].featuredImage,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: Get.width / 3.5,
                                          child: Text(
                                            products[index].title,
                                            style: smallTextStyle,
                                          ),
                                        ),
                                        Bounce(
                                          duration:
                                              const Duration(milliseconds: 110),
                                          onPressed: () {
                                            if (ids.contains(products[index]
                                                    .id
                                                    .toString()) ==
                                                true) {
                                              alreadyInCart();
                                            } else {
                                              addToCart(products[index]);
                                            }
                                          },
                                          child: Icon(
                                            Icons.shopping_cart,
                                            size: 25,
                                            color: ids.contains(products[index]
                                                        .id
                                                        .toString()) ==
                                                    true
                                                ? AppColors.redColor
                                                : AppColors.dullColor,
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget shimmerEffectProtraitLayout() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              //controller: scrollController,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 0.9,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                return Bounce(
                  duration: const Duration(milliseconds: 110),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      // ignore: prefer_const_constructors
                      decoration: BoxDecoration(
                        color: AppColors.shimmerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  Widget DataLoadedGridLandscapeLayout() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              controller: scrollController,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.9,
              ),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return Bounce(
                  duration: const Duration(milliseconds: 110),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      elevation: 5,
                      shadowColor: Colors.grey.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: AppColors.backgroundColor,
                      child: Container(
                          // ignore: prefer_const_constructors
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 50,
                                top: 10,
                                left: 0,
                                right: 0,
                                child: CachedNetworkImage(
                                  imageUrl: products[index].featuredImage,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: Get.width / 7,
                                            child: Text(
                                              products[index].title,
                                              style: smallTextStyle,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Bounce(
                                            duration: const Duration(
                                                milliseconds: 110),
                                            onPressed: () {
                                              if (ids.contains(products[index]
                                                      .id
                                                      .toString()) ==
                                                  true) {
                                                alreadyInCart();
                                              } else {
                                                addToCart(products[index]);
                                              }
                                            },
                                            child: Icon(
                                              Icons.shopping_cart,
                                              size: 25,
                                              color: ids.contains(
                                                          products[index]
                                                              .id
                                                              .toString()) ==
                                                      true
                                                  ? AppColors.redColor
                                                  : AppColors.dullColor,
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                );
              }),
        ));
  }

  Widget shimmerEffectLandscapeLayout() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              //controller: scrollController,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 0.9,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                return Bounce(
                  duration: const Duration(milliseconds: 110),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      // ignore: prefer_const_constructors
                      decoration: BoxDecoration(
                        color: AppColors.shimmerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  void alreadyInCart() async {
    ToastWidget().showErrorToast(message: 'Already added into cart');
  }

  void addToCart(Product product) async {
    await CrudMethodHelper().addToCart(product);
    refreshNotes();
  }
}
