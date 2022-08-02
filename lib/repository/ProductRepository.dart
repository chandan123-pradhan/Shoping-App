import 'package:manek_tech_practicle/models/response/GetProductResponse.dart';
import 'package:manek_tech_practicle/networking/ApiProvider.dart';

class ProductRepository {
  ApiProvider _apiProvider = ApiProvider();

  Future<GetProductResponse> getProduct(Map parameter) async {
    final response = await _apiProvider.postAfterAuth(parameter);
    return GetProductResponse.fromJson(response);
  }
}
