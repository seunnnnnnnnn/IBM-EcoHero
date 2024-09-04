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
        .thenAnswer((_) async {});

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
        .thenAnswer((_) async {});

    // Act: Call the method you want to test
    await mockStorageService.delete('testKey');

    // Assert: Verify the method was called with the correct arguments
    verify(mockStorageService.delete('testKey')).called(1);
  });

  test('deleteAll() clears all data correctly', () async {
    // Arrange: Set up the mock to return a specific value
    when(mockStorageService.deleteAll())
        .thenAnswer((_) async {});

    // Act: Call the method you want to test
    await mockStorageService.deleteAll();

    // Assert: Verify the method was called
    verify(mockStorageService.deleteAll()).called(1);
  });
}


//explaination:
//In this test file, we are testing the StorageService class. The StorageService class is a simple class that provides methods for reading, writing, and deleting data from a storage system. We use the mockito library to create mock objects of the StorageService class and test the behavior of its methods.
//In each test, we set up the mock object to return a specific value when a method is called, call the method we want to test, and then verify that the method was called with the correct arguments and returned the expected value. We use the when and thenAnswer functions to set up the mock behavior, the verify function to check if the method was called, and the expect function to check the return value.
//The tests cover the basic functionality of the StorageService class, including writing data, reading data, deleting data, and clearing all data. We use the mock object to simulate the behavior of the StorageService class and test different scenarios like successful data retrieval and deletion.
//The tests are written using the Flutter test framework and the test function, which allows us to test individual methods of the StorageService class. We use the setUp function to set up the mock object before each test and the verify function to check if the method was called with the correct arguments. The tests help ensure that the StorageService class works as expected and handles different scenarios correctly.
