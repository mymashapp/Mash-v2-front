import 'package:mash/API_handler/api_base_handler.dart';
import 'package:mash/configs/base_url.dart';
import 'package:mash/widgets/error_snackbar.dart';

Future addWallet(dynamic value) async {
  final response = await ApiBaseHelper.post(WebApi.addWallet, value, true);

  if (response.statusCode == 201) {
    return true;
  } else {
    appSnackBar("Error", "Wallet not added");
    return false;
  }
}
