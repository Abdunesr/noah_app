// test/user_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:noah/models/user_model.dart';

void main() {
  test('UserModel parses roles correctly and identifies waterreader', () {
    final json = {
      "id": 4,
      "name": "Abdnesr7",
      "email": "nesredinabdelah33@gmail.com",
      "phone": "+251900729339",
      "status": "Active",
      "email_verified_at": null,
      "last_active_at": "2026-08-02T17:16:20.000000Z",
      "created_at": "2026-08-01T17:57:53.000000Z",
      "updated_at": "2026-08-02T17:16:20.000000Z",
      "roles": [
        "waterreader"
      ]
    };

    final user = UserModel.fromJson(json);

    expect(user.roles, contains('waterreader'));
    expect(user.isWaterReader, isTrue);
    expect(user.isAdmin, isFalse);
    expect(user.isResident, isFalse);
  });
}
