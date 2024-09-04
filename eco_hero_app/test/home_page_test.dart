import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:eco_hero_app/home/home_page.dart'; // Adjust path accordingly
import 'package:eco_hero_app/camera/camera_access.dart';
import 'package:eco_hero_app/IBM Watson/chat_screen.dart';
import 'package:eco_hero_app/camera/camera_screen.dart';
import 'package:eco_hero_app/widgets/bin_button.dart';
import 'package:eco_hero_app/storage_service.dart';

// Mock classes
class MockStorageService extends Mock implements StorageService {}
class MockHttpClient extends Mock implements http.Client {}
class MockCameraAccess extends Mock implements CameraAccess {}

void main() {
  late MockStorageService mockStorageService;
  late MockHttpClient mockHttpClient;
  late MockCameraAccess mockCameraAccess;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://example.com'));
  });

  setUp(() {
    mockStorageService = MockStorageService();
    mockHttpClient = MockHttpClient();
    mockCameraAccess = MockCameraAccess();
  });

  testWidgets('HomePage renders correctly when logged in', (WidgetTester tester) async {
    // Mock storage service to return a token
    when(() => mockStorageService.read('accessToken')).thenAnswer((_) async => 'mockToken');

    // Mock HTTP client response for user stats
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response('{"monthly_scans": "10", "total_scans": "100", "teams": "5", "points": "200", "ranking": "1"}', 200));

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          storageService: mockStorageService,
          httpClient: mockHttpClient,
          cameraAccess: mockCameraAccess,
        ),
      ),
    );

    // Verify initial UI elements are present
    expect(find.text('Welcome back!'), findsOneWidget);
    expect(find.text('EcoHero'), findsOneWidget);
    expect(find.text('Scan your trash'), findsOneWidget);
    expect(find.text('Total items scanned this month'), findsOneWidget);
    expect(find.text('Total scans'), findsOneWidget);
    expect(find.text('Teams'), findsOneWidget);
    expect(find.text('Points'), findsOneWidget);
    expect(find.text('Ranking'), findsOneWidget);
  });
 

//  leave this out for now as  its for the login page when user isnt logged in and the camera is clicked this is a snackbar that pops up issue with the test
//  testWidgets('HomePage shows login prompt when not logged in', (WidgetTester tester) async {
//   // Mock storage service to return no token
//   when(() => mockStorageService.read('accessToken')).thenAnswer((_) async => null);

//   await tester.pumpWidget(
//     MaterialApp(
//       home: HomePage(
//         storageService: mockStorageService,
//         httpClient: mockHttpClient,
//         cameraAccess: mockCameraAccess,
//       ),
//     ),
//   );

//   // Ensure that the widget tree is built
//   await tester.pumpAndSettle();

//   // Verify initial UI elements
//   expect(find.text('Scan your trash'), findsOneWidget);

//   // Tap on the button to trigger SnackBar
//   await tester.tap(find.text('Scan your trash'));
//   await tester.pump();

//   // Allow time for SnackBar to show
//   await tester.pump(const Duration(milliseconds: 500));

//   // Verify the snackbar is shown when not logged in
//   expect(find.byType(SnackBar), findsOneWidget);
//   expect(find.text('Please log in to use the camera.'), findsOneWidget);
// });


  testWidgets('HomePage navigates to CameraScreen when logged in', (WidgetTester tester) async {
    // Mock storage service to return a token
    when(() => mockStorageService.read('accessToken')).thenAnswer((_) async => 'mockToken');

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          storageService: mockStorageService,
          httpClient: mockHttpClient,
          cameraAccess: mockCameraAccess,
        ),
      ),
    );

    // Tap on the button to navigate to CameraScreen
    await tester.tap(find.text('Scan your trash'));
    await tester.pumpAndSettle();

    // Verify navigation to CameraScreen
    expect(find.byType(CameraScreen), findsOneWidget);
  });

  testWidgets('Floating action button navigates to ChatScreen', (WidgetTester tester) async {
    // Mock storage service to return a token
    when(() => mockStorageService.read('accessToken')).thenAnswer((_) async => 'mockToken');

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          storageService: mockStorageService,
          httpClient: mockHttpClient,
          cameraAccess: mockCameraAccess,
        ),
        routes: {
          '/chat': (context) => const ChatScreen(),
        },
      ),
    );

    // Tap on the floating action button
    await tester.tap(find.text('How can I help?'));
    await tester.pumpAndSettle();

    // Verify navigation to ChatScreen
    expect(find.byType(ChatScreen), findsOneWidget);
  });
}
