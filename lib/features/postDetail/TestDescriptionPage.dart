import 'package:flutter/material.dart';

import 'widgets/PostDetailContentWidget.dart';
import 'widgets/SimpleReadMoreWidget.dart';

class TestDescriptionPage extends StatelessWidget {
  const TestDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String veryLongDescription =
        'This is a very long description that should definitely exceed the 3-line limit. '
        'We are testing the more/less button functionality to ensure it works correctly. '
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor '
        'incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud '
        'exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute '
        'irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla '
        'pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia '
        'deserunt mollit anim id est laborum. '
        'The quick brown fox jumps over the lazy dog. The five boxing wizards jump quickly. '
        'How vexingly quick daft zebras jump! Pack my box with five dozen liquor jugs. '
        'We promptly judged antique ivory buckles for the next prize. Crazy Fredrick bought many very exquisite opal jewels.';

    // Print info about the description
    print('Test description length: ${veryLongDescription.length}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Description'),
        backgroundColor: Colors.amber,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Original Implementation:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            PostDetailContentWidget(
              postImage: 'assets/images/post_image.png',
              profileImage: 'assets/images/shopping.svg',
              description: veryLongDescription,
              location: 'Test Location',
              username: 'TestUser',
              useLightTheme: true,
            ),
            Divider(thickness: 2, height: 40),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'SimpleReadMoreWidget Implementation:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SimpleReadMoreWidget(
                text: veryLongDescription,
                trimLines: 3,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'FacebookSans',
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
