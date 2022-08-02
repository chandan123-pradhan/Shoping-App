import 'package:manek_tech_practicle/db/Product_Database.dart';
import 'package:manek_tech_practicle/models/Item.dart';
import 'package:manek_tech_practicle/models/response/GetProductResponse.dart';
import 'package:manek_tech_practicle/widgets/ToastWidget.dart';

class CrudMethodHelper {
/**
 * This Function will add your item into cart.
 * [product] required parameter is object of product.
 */
  Future<String> addToCart(Product product) async {
    final note = Item(
        title: product.title,
        fetureImage: product.featuredImage,
        price: product.price,
        description: product.description,
        productId: product.id.toString());

    var res = await ProductDatabase.instance.create(note);

    ToastWidget().showToast(message: 'Add to cart successfully done');
    return 'done';
  }

/**
 * This Function will add your item into cart.
 * [id] required parameter is id of the product.
 */
  Future<String>deleteCart(id) async {
    await ProductDatabase.instance.delete(id);
    ToastWidget().showToast(message: 'Item Remove From The Cart');
    return 'done';
  }
}
