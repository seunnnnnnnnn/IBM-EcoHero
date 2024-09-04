import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:eco_hero_app/profile/email_entry_page.dart';
import 'package:eco_hero_app/profile/otp_verification_page.dart';
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
  group('EmailEntryPage', () {
    late MockClient mockClient;
    late MockStorageService mockStorageService;

    setUp(() {
      mockClient = MockClient();
      mockStorageService = MockStorageService();
    });

    testWidgets('displays error when email is empty', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: EmailEntryPage(storageService: mockStorageService, httpClient: mockClient)));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text("Please enter your email"), findsOneWidget);
    });

    testWidgets('navigates to OTPVerificationPage on successful OTP request', (WidgetTester tester) async {
      const email = 'test@example.com';

      when(mockClient.post(
        Uri.parse('https://server.eco-hero-app.com/v1/auth/token/'),
        body: json.encode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response('{}', 200));

      await tester.pumpWidget(MaterialApp(home: EmailEntryPage(storageService: mockStorageService, httpClient: mockClient)));

      await tester.enterText(find.byType(TextField), email);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(OTPVerificationPage), findsOneWidget);
    });

    testWidgets('shows error message on OTP request failure', (WidgetTester tester) async {
      const email = 'test@example.com';

      when(mockClient.post(
        Uri.parse('https://server.eco-hero-app.com/v1/auth/token/'),
        body: json.encode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response('{}', 400));

      await tester.pumpWidget(MaterialApp(home: EmailEntryPage(storageService: mockStorageService, httpClient: mockClient)));

      await tester.enterText(find.byType(TextField), email);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text("Failed to request OTP. Please try again."), findsOneWidget);
    });
  });
}


//explaination:
//In this test file, we are testing the EmailEntryPage widget. The EmailEntryPage widget is a simple widget that allows the user to enter their email address and request an OTP for verification.
//In the first test, we test that the widget displays an error message when the email field is empty. We create an EmailEntryPage widget and tap the submit button without entering an email address. We then assert that the widget displays the correct error message.
//In the second test, we test that the widget navigates to the OTPVerificationPage when the OTP request is successful. We mock the HTTP POST request to return a successful response, enter an email address, and tap the submit button. We then assert that the widget navigates to the OTPVerificationPage.
//In the third test, we test that the widget shows an error message when the OTP request fails. We mock the HTTP POST request to return a failure response, enter an email address, and tap the submit button. We then assert that the widget displays the correct error message.
//These tests ensure that the EmailEntryPage widget works as expected and displays the correct error messages and navigates to the OTPVerificationPage when the OTP request is successful.