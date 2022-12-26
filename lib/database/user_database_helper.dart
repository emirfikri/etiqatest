import 'user_database_provider.dart';
import '../models/user_model.dart';

class UserDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createUser(User user) async {
    final db = await dbProvider.database;

    var result = db.insert(userTable, user.toDatabaseJson());
    return result;
  }

  Future<User?> getUser(int? id) async {
    final db = await dbProvider.database;
    try {
      List<Map<String, dynamic>> users = await db.query(userTable);
      if (users.isNotEmpty) {
        return User.fromDatabaseJson(users[0]);
      } else {
        return null;
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> logoutApiDeleteToken(int id) async {
    final db = await dbProvider.database;
    try {
      List<Map> users =
          await db.query(userTable, where: 'userId = ?', whereArgs: [id]);

      if (users.isNotEmpty) {
        await db.delete(userTable, where: "userId = ?", whereArgs: [id]);
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}
