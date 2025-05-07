import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/services/booking_service.dart';
import 'package:travel_app/models/booking.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter/services.dart';

@GenerateMocks([FlutterSecureStorage])
import 'booking_service_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'write':
            return null;
          case 'read':
            return null;
          default:
            return null;
        }
      },
    );
  });

  test('BookingService returns mock booking', () async {
    final service = BookingService();
    final booking = await service.bookTrip('Mumbai', DateTime.now());

    expect(booking.flight, 'Flight to Mumbai');
    expect(booking.hotel, 'Hotel in Mumbai');
    expect(booking.cab, 'Airport transfer');
    expect(booking.totalCost, 15000.0);
  });
} 