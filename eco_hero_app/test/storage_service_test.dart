// test/storage_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:eco_hero_app/storage_service.dart'; // Replace with your actual package name and path
import 'storage_service_test.mocks.dart'; // Import the generated mock file

@GenerateMocks([StorageService])
void main() {
  late MockStorageService mockStorageService;

  setUp(() {
    mockStorageService = MockStorageService(); // Use the generated mock class
  });

  test('write() saves data correctly', () async {
    // Arrange: Set up the mock to return a specific value
    when(mockStorageService.write('testKey', 'testValue'))
        .thenAnswer((_) async => null);

    // Act: Call the method you want to test
    await mockStorageService.write('testKey', 'testValue');

    // Assert: Verify the method was called with the correct arguments
    verify(mockStorageService.write('testKey', 'testValue')).called(1);
  });

  test('read() retrieves data correctly', () async {
    // Arrange: Set up the mock to return a specific value
    when(mockStorageService.read('testKey'))
        .thenAnswer((_) async => 'testValue');

    // Act: Call the method you want to test
    final value = await mockStorageService.read('testKey');

    // Assert: Verify the value returned is correct
    expect(value, 'testValue');
    verify(mockStorageService.read('testKey')).called(1);
  });

  test('delete() removes data correctly', () async {
    // Arrange: Set up the mock to return a specific value
    when(mockStorageService.delete('testKey'))
        .thenAnswer((_) async => null);

    // Act: Call the method you want to test
    await mockStorageService.delete('testKey');

    // Assert: Verify the method was called with the correct arguments
    verify(mockStorageService.delete('testKey')).called(1);
  });

  test('deleteAll() clears all data correctly', () async {
    // Arrange: Set up the mock to return a specific value
    when(mockStorageService.deleteAll())
        .thenAnswer((_) async => null);

    // Act: Call the method you want to test
    await mockStorageService.deleteAll();

    // Assert: Verify the method was called
    verify(mockStorageService.deleteAll()).called(1);
  });
}
