import 'dart:async';
import 'dart:io';

import 'package:manek_tech_practicle/models/response/GetProductResponse.dart';
import 'package:manek_tech_practicle/networking/Response.dart';
import 'package:manek_tech_practicle/repository/ProductRepository.dart';

class ProductDataBloc {
  late ProductRepository productRepository;
  late StreamController<Response<GetProductResponse>> streamController;
  
  StreamSink<Response<GetProductResponse>> get productDataSink => streamController.sink;

  Stream<Response<GetProductResponse>> get productDataStream => streamController.stream;

 
  ProductDataBloc() {
    streamController = StreamController<Response<GetProductResponse>>();
    productRepository = ProductRepository();
    
  }

  callGetProductApi(Map parameter) async {
    try {
      GetProductResponse chuckCats = await productRepository.getProduct(parameter);
      productDataSink.add(Response.completed(chuckCats));
    } catch (e) {
      productDataSink.add(Response.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    streamController.close();
    
  }
}