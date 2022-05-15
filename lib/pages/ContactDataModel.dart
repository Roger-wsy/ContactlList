import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ContactDataModel {
  String? name;
  String? phone;
  DateTime? checkin;

  ContactDataModel({this.name, this.phone, this.checkin});

  ContactDataModel.fromJson(Map<String, dynamic> json) {
    name = json['user'];
    phone = json['phone'];
    checkin =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(json['check-in'].toString());
  }
}
