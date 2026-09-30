import 'package:flutter_test/flutter_test.dart';
import 'package:lab_09_clima/main.dart';

void main() {
  testWidgets('Weather App UI components render test', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherApp());

    // Verify Title
    expect(find.text('Weather App'), findsOneWidget);

    // Verify Search button
    expect(find.text('Search'), findsOneWidget);

    // Verify Default initial city and stats
    expect(find.text('Hanoi, VN'), findsOneWidget);
    expect(find.text('22°C'), findsWidgets);
    expect(find.text('Humidity'), findsOneWidget);
    expect(find.text('Wind Speed'), findsOneWidget);
    expect(find.text('Min Temp'), findsOneWidget);
    expect(find.text('Max Temp'), findsOneWidget);
  });
}
