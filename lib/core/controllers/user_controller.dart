import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/models/user/user_model.dart';
import 'package:insan_jamd_hawan/core/repository/user_repository.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository.instance;

  UserModel? _user;
  UserModel? get user => _user;

  Future<UserModel?> getUser() async {
    return await _userRepository.getUser();
  }

  Future<void> initUser() async {
    _user = await getUser();
    update();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await initUser();
  }
}
