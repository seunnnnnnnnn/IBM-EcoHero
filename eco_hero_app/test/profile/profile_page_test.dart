import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:eco_hero_app/profile/profile_page.dart';
import '../mocks.mocks.dart'; // Import your generated mocks

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Ensure test environment

  late MockClient mockClient;
  late MockStorageService mockStorageService;

  setUp(() {
    mockClient = MockClient();
    mockStorageService = MockStorageService();
    reset(mockClient); // Reset mocks before each test
    reset(mockStorageService);
  });
  group('ProfilePage', () {
    late MockClient mockClient;
    late MockStorageService mockStorageService;

    setUp(() {
      mockClient = MockClient();
      mockStorageService = MockStorageService();
    });

    testWidgets('displays email when logged in', (WidgetTester tester) async {
      // Arrange
      when(mockStorageService.read('email')).thenAnswer((_) async => 'test@example.com');

      // Act
      await tester.pumpWidget(MaterialApp(
        home: ProfilePage(storageService: mockStorageService, httpClient: mockClient),
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('@test'), findsOneWidget);
    });

    testWidgets('shows login button when not logged in', (WidgetTester tester) async {
      // Arrange
      when(mockStorageService.read('email')).thenAnswer((_) async => null);

      // Act
      await tester.pumpWidget(MaterialApp(
        home: ProfilePage(storageService: mockStorageService, httpClient: mockClient),
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Continue with Email'), findsOneWidget);
    });

    testWidgets('logs out correctly', (WidgetTester tester) async {
      // Arrange
      when(mockStorageService.read('email')).thenAnswer((_) async => 'test@example.com');
      when(mockStorageService.deleteAll()).thenAnswer((_) async => {});

      // Act
      await tester.pumpWidget(MaterialApp(
        home: ProfilePage(storageService: mockStorageService, httpClient: mockClient),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      // Assert
      verify(mockStorageService.deleteAll()).called(1);
      expect(find.text('Anonymous user'), findsOneWidget);
    });
  });
}



//explaination:
//this test is testing the profile page of the app
//it tests the profile page when the user is logged in and when the user is not logged in
//it also tests the logout functionality of the app
//it uses mockito to mock the client and storage service
//it uses the generated mocks from the mocks.mocks.dart file
//it uses the setUp method to reset the mocks before each test
//it uses the testWidgets method to test the widgets of the app
//it uses the pumpWidget method to pump the widget into the tester
//it uses the pumpAndSettle method to allow async operations to complete
//it uses the expect method to verify the text displayed on the screen
//it uses the verify method to verify the method calls on the mock objects
//it uses the tap method to simulate tapping on a button
//it uses the find method to find widgets on the screen
//it uses the when method to set up the mock objects to return specific values
//it uses the reset method to reset the mock objects before each test
//it uses the reset method to reset the mock objects before each test
//it uses the reset method to reset the mock objects before each test
//it uses the reset method to reset the mock objects before each test
//it uses the reset method to reset the mock objects before each test

//In this test file, we are testing the ProfilePage widget. The ProfilePage widget is a simple widget that displays the user's email and allows the user to log out. If the user is not logged in, it displays a login button instead.
//In the first test, we test that the widget displays the user's email when logged in. We create a ProfilePage with a dummy email, mock the storage service to return the email, and assert that the email and username are displayed.
