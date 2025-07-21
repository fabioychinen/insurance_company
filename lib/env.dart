
  import 'app/core/services/api_services.dart';

class Environments {
  static const String prod = 'https://www.portoseguro.com.br/seguro-auto';
}


final apiServices = ApiServices(
  baseUrl: Environments.prod, 
);