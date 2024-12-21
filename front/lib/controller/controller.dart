import 'package:get/get.dart';
import 'package:whackiest/model/msg.dart';

class chatController extends GetxController {
  var chatMessages = <Message>[].obs;
  var connectedUsers = 0.obs;
}
