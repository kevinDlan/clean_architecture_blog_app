import 'package:blog_app/core/errors/exception.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword(
      {required String name, required String email, required String password});

  Future<UserModel> loginWithEmailPassword(
      {required String email, required String password});

  Future<UserModel?> currentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> currentUserData() async {
    try {
      if (currentUserSession == null) return null;

      final userModelData = await supabaseClient
          .from("profiles")
          .select()
          .eq("id", currentUserSession!.user.id);
      return UserModel.fromJson(userModelData.first)
          .copyWith(email: currentUserSession!.user.email);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> loginWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const ServerException("User is null");
      }

      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (error) {
      throw ServerException(error.message);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signUp(email: email, password: password, data: {'name': name});
      if (response.user == null) {
        throw const ServerException("User is null");
      }

      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (error) {
      throw ServerException(error.message);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
