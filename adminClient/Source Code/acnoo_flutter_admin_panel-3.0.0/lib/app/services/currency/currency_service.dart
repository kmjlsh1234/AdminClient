import 'package:acnoo_flutter_admin_panel/app/models/currency/diamond.dart';
import 'package:acnoo_flutter_admin_panel/app/utils/factory/dio_factory.dart';

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

}