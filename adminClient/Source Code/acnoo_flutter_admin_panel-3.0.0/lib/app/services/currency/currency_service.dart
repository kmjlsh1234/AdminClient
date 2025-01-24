import 'package:acnoo_flutter_admin_panel/app/models/currency/diamond.dart';
import 'package:acnoo_flutter_admin_panel/app/param/currency/currency_mod_param.dart';
import 'package:acnoo_flutter_admin_panel/app/utils/factory/dio_factory.dart';
import 'package:retrofit/dio.dart';



import '../../models/currency/chip.dart';
import '../../models/currency/coin.dart';
import '../../retrofit/currency/currency_client.dart';

class CurrencyService {
  late CurrencyClient client = CurrencyClient(DioFactory.createDio());

  Future<int> getChip(int userId) async {
    Chip chip = await client.getChip(userId);
    return chip.amount;
  }

  Future<int> getCoin(int userId) async {
    Coin coin = await client.getCoin(userId);
    return coin.amount;
  }

  Future<int> getDiamond(int userId) async {
    Diamond diamond = await client.getDiamond(userId);
    return diamond.amount;
  }

  Future<bool> modChip(int userId, CurrencyModParam currencyModParam) async {
    HttpResponse result = await client.modChip(userId, currencyModParam);
    return result.response.statusCode == 200;
  }

  Future<bool> modCoin(int userId, CurrencyModParam currencyModParam) async {
    HttpResponse result = await client.modCoin(userId, currencyModParam);
    return result.response.statusCode == 200;
  }

  Future<bool> modDiamond(int userId, CurrencyModParam currencyModParam) async {
    HttpResponse result = await client.modDiamond(userId, currencyModParam);
    return result.response.statusCode == 200;
  }
}