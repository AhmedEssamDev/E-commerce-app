import 'package:shop/features/auth/login/data/model/user_model.dart';

class LoginResponseModel {
  String? accessToken;
  String? refreshToken;
  bool? status;
  UserModel? userModel;

  LoginResponseModel({this.accessToken, this.refreshToken, this.status, this.userModel});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    status = json['status'];
    userModel = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'status': status,
      'user': userModel?.toJson(),
    };
  }
}