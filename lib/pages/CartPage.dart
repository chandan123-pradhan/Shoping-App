// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:manek_tech_practicle/db/CrudMethods.dart';
import 'package:manek_tech_practicle/db/Product_Database.dart';
import 'package:manek_tech_practicle/models/Item.dart';
import 'package:manek_tech_practicle/utils/AppColors.dart';
import 'package:manek_tech_practicle/utils/Strings.dart';
import 'package:manek_tech_practicle/utils/Styles.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Item> notes = [];
  bool isLoading = false;
  List<int> ids = [];
  int totalAmount = 0;
  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

/**
 * This Function will Refresh your updated note.
 *  */
  Future refreshNotes() async {
    totalAmount = 0;
    setState(() => isLoading = true);

    notes = await ProductDatabase.instance.readAllNotes();
    for (int i = 0; i < notes.length; i++) {
      totalAmount += notes[i].price;
      ids.add(notes[i].id!);
    }

    setState(() => isLoading = false);
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
      ),
      bottomNavigationBar: BottomAppBar(child: _bottomBarView()),
      body: OrientationBuilder(builder: (_, orientation) {
        if (orientation == Orientation.portrait) {
          return _productListProtraitLayout();
        } else {
          return _productListLandscapeLayout();
        }
      }),
    );
  }

  _productListProtraitLayout() {
    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(
          height: 10,
        ),
        isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : notes.isEmpty
                ? SizedBox(
                    height: Get.height / 1.3,
                    child: const Center(
                      child: Text(
                        "No Item Added into cart",
                        style: descriptionTextStyle,
                      ),
                    ),
                  )
                : DataLoadedGridProtraitLayout(),
      ]),
    );
  }

  Widget DataLoadedGridProtraitLayout() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 2.8,
              ),
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Stack(
                    children: [
                      Card(
                        elevation: 5,
                        shadowColor: Colors.grey.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: AppColors.backgroundColor,
                        child: Container(
                            // ignore: prefer_const_constructors
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 5, 10),
                                  child: Container(
                                    width: Get.width / 4,
                                    decoration: const BoxDecoration(
                                      // color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                    ),
                                    child: CachedNetworkImage(
                                      //fit: BoxFit.contain,
                                      imageUrl: notes[index].fetureImage,
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
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.whiteColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: Get.width / 1.9,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    notes[index].title,
                                                    style: normalTextStyle,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width / 1.9,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  Strings.PRICE,
                                                  style: smallTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      Strings.RS +
                                                          notes[index]
                                                              .price
                                                              .toString(),
                                                      style: smallTextStyle,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width / 2,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                const Text(
                                                  Strings.QUANTITY,
                                                  style: smallTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const Text(
                                                  "1",
                                                  style: smallTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Positioned(
                          right: 10,
                          top: 10,
                          child: Bounce(
                            duration: const Duration(milliseconds: 110),
                            onPressed: () {
                              deleteCart(notes[index].id);
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.delete,
                                  size: 25,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                );
              }),
        ));
  }

  _productListLandscapeLayout() {
    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(
          height: 10,
        ),
        isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : notes.isEmpty
                ? SizedBox(
                    height: Get.height / 1.3,
                    child: const Center(
                      child: Text(
                        "No Item Added into cart",
                        style: descriptionTextStyle,
                      ),
                    ),
                  )
                : DataLoadedGridLandscapeLayout(),
      ]),
    );
  }

  Widget DataLoadedGridLandscapeLayout() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.65,
              ),
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Stack(
                    children: [
                      Card(
                        elevation: 5,
                        shadowColor: Colors.grey.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: AppColors.backgroundColor,
                        child: Container(
                            // ignore: prefer_const_constructors
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 100,
                                  top: 10,
                                  left: 20,
                                  right: 20,
                                  child: CachedNetworkImage(
                                    //fit: BoxFit.contain,
                                    imageUrl: notes[index].fetureImage,
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
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: Get.width / 1,
                                              child: Text(
                                                notes[index].title,
                                                style: normalTextStyle,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  Strings.PRICE,
                                                  style: smallTextStyle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      Strings.RS +
                                                          notes[index]
                                                              .price
                                                              .toString(),
                                                      style: smallTextStyle,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            SizedBox(
                                              width: Get.width / 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                // ignore: prefer_const_literals_to_create_immutables
                                                children: [
                                                  const Text(
                                                    Strings.QUANTITY,
                                                    style: smallTextStyle,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: const [
                                                      Text(
                                                        "1",
                                                        style: smallTextStyle,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(width: 10)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Positioned(
                          right: 10,
                          top: 10,
                          child: Bounce(
                            duration: const Duration(milliseconds: 110),
                            onPressed: () {
                              deleteCart(notes[index].id);
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.delete,
                                  size: 25,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                );
              }),
        ));
  }

  void deleteCart(id) async {
    await CrudMethodHelper().deleteCart(id);
    refreshNotes();
  }

  _bottomBarView() {
    return Container(
      height: 50,
      width: Get.width / 1,
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    Strings.TOTAL_ITEMS,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    notes.length.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    Strings.GRAND_TOTAL,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    totalAmount.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
