import 'dart:convert';
import 'package:eco_hero_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:eco_hero_app/profile/otp_verification_page.dart';
import '../mocks.mocks.dart'; // Correctly importing generated mock classes

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
  group('OTPVerificationPage', () {
    late MockClient mockClient;
    late MockStorageService mockStorageService;

    setUp(() {
      mockClient = MockClient();
      mockStorageService = MockStorageService();
    });

    testWidgets('verifies OTP and navigates to MainPage on success', (WidgetTester tester) async {
      const email = 'test@example.com';
      const otp = '123456';

      // Mock the HTTP POST request
      when(mockClient.post(
        Uri.parse('https://server.eco-hero-app.com/v1/auth/verify/'),
        body: json.encode({'email': email, 'otp': otp}),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response(
          json.encode({'access': 'access_token', 'refresh': 'refresh_token'}), 200));

      // Mock storage service write calls
      when(mockStorageService.write(any, any)).thenAnswer((_) async => {});

      await tester.pumpWidget(MaterialApp(
        home: OTPVerificationPage(email: email, storageService: mockStorageService, httpClient: mockClient),
      ));

      await tester.enterText(find.byType(TextField), otp);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verifications
      verify(mockStorageService.write('accessToken', 'access_token')).called(1);
      verify(mockStorageService.write('refreshToken', 'refresh_token')).called(1);
      verify(mockStorageService.write('email', email)).called(1);
      expect(find.byType(MainPage), findsOneWidget);
    });

    testWidgets('shows error message on OTP verification failure', (WidgetTester tester) async {
      const email = 'test@example.com';
      const otp = '123456';

      // Mock the HTTP POST request failure
      when(mockClient.post(
        Uri.parse('https://server.eco-hero-app.com/v1/auth/verify/'),
        body: json.encode({'email': email, 'otp': otp}),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response('{}', 400));

      await tester.pumpWidget(MaterialApp(
        home: OTPVerificationPage(email: email, storageService: mockStorageService, httpClient: mockClient),
      ));

      await tester.enterText(find.byType(TextField), otp);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text("Invalid OTP, please try again"), findsOneWidget);
    });
  });
}

//explaination:
//In this test file, we are testing the OTPVerificationPage widget. The OTPVerificationPage widget is a simple widget that verifies an OTP code entered by the user and navigates to the MainPage if the verification is successful.
//In the first test, we test that the widget verifies the OTP code and navigates to the MainPage on success. We create an OTPVerificationPage with a dummy email and OTP code, and mock the HTTP POST request to return a successful response with access and refresh tokens. We also mock the storage service write calls to store the tokens and email. We then enter the OTP code, tap the button, and assert that the tokens and email are stored and the MainPage is displayed.
//In the second test, we test that the widget shows an error message on OTP verification failure. We mock the HTTP POST request to return a failure response, create an OTPVerificationPage with a dummy email and OTP code, enter the OTP code, tap the button, and assert that the error message is displayed.
//These tests ensure that the OTPVerificationPage widget works as expected and verifies the OTP code, stores the tokens and email on success, and shows an error message on failure.
//The tests are written using the Flutter test framework and the testWidgets function, which allows us to test widgets in a Flutter app. We use the pumpWidget function to build the widget tree, the enterText function to enter text in a text field, the tap function to simulate tapping a button, and the expect function to assert the expected behavior of the widget.
//The tests also use the Mockito library to mock the HTTP client and storage service, and verify that the correct methods are called with the correct parameters. This allows us to isolate the widget under test and focus on its behavior without relying on external dependencies.
//The tests are organized into a group using the group function, which allows us to group related tests together. This makes it easier to organize and run multiple tests for the same widget. The setUp function is used to set up common resources before each test, and the reset function is used to reset the mocks before each test to ensure a clean state.
//Overall, these tests provide good coverage of the OTPVerificationPage widget and help ensure that it works correctly under different scenarios. You can run these tests using the flutter test command in the terminal or by using the test runner in your IDE.