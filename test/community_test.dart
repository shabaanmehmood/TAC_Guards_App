import 'package:flutter_test/flutter_test.dart';
import 'package:tac/modules/community/community_screen.dart';

void main() {
  test('community image paths resolve against the API origin', () {
    expect(
      communityImageUrl('images/a.jpg'),
      'https://api.control1security.com.au/uploads/images/a.jpg',
    );
    expect(
      communityImageUrl('https://cdn.example.com/a.jpg'),
      'https://cdn.example.com/a.jpg',
    );
  });
}
