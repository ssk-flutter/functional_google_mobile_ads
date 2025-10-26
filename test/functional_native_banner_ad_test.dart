import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:functional_google_mobile_ads/functional_native_banner_ad.dart';

void main() {
  group('FunctionalNativeBannerAd', () {
    const testAdUnitId = 'ca-app-pub-3940256099942544/2247696110';

    testWidgets('should create widget with required parameters',
        (WidgetTester tester) async {
      const widget = FunctionalNativeBannerAd(
        adUnitId: testAdUnitId,
      );

      expect(widget.adUnitId, equals(testAdUnitId));
      expect(widget.templateType, equals(TemplateType.medium));
      expect(widget.nativeAdOptions, isNull);
      expect(widget.nativeAdListener, isNull);
      expect(widget.adRequest, isNull);
      expect(widget.width, isNull);
      expect(widget.height, isNull);
      expect(widget.nativeTemplateStyle, isNull);
    });

    testWidgets('should create widget with custom parameters',
        (WidgetTester tester) async {
      final customListener = NativeAdListener();
      final customRequest = AdRequest();
      final customStyle = NativeTemplateStyle(templateType: TemplateType.small);
      final customOptions = NativeAdOptions();

      final widget = FunctionalNativeBannerAd(
        adUnitId: testAdUnitId,
        nativeAdListener: customListener,
        adRequest: customRequest,
        width: 300,
        height: 200,
        templateType: TemplateType.small,
        nativeTemplateStyle: customStyle,
        nativeAdOptions: customOptions,
      );

      expect(widget.adUnitId, equals(testAdUnitId));
      expect(widget.nativeAdListener, equals(customListener));
      expect(widget.adRequest, equals(customRequest));
      expect(widget.width, equals(300));
      expect(widget.height, equals(200));
      expect(widget.templateType, equals(TemplateType.small));
      expect(widget.nativeTemplateStyle, equals(customStyle));
      expect(widget.nativeAdOptions, equals(customOptions));
    });

    testWidgets('should display loading state initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FunctionalNativeBannerAd(
              adUnitId: testAdUnitId,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have correct default size',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FunctionalNativeBannerAd(
              adUnitId: testAdUnitId,
            ),
          ),
        ),
      );

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final adSizedBox = sizedBoxes.firstWhere((box) => box.width == 320);
      expect(adSizedBox.width, equals(320));
      expect(adSizedBox.height, equals(250));
    });

    testWidgets('should use custom width and height when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FunctionalNativeBannerAd(
              adUnitId: testAdUnitId,
              width: 400,
              height: 300,
            ),
          ),
        ),
      );

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final adSizedBox = sizedBoxes.firstWhere((box) => box.width == 400);
      expect(adSizedBox.width, equals(400));
      expect(adSizedBox.height, equals(300));
    });

    testWidgets('should adjust size for small template type',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FunctionalNativeBannerAd(
              adUnitId: testAdUnitId,
              templateType: TemplateType.small,
            ),
          ),
        ),
      );

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final adSizedBox = sizedBoxes.firstWhere((box) => box.width == 320);
      expect(adSizedBox.width, equals(320));
      expect(adSizedBox.height, equals(150)); // Small template height
    });

    group('State Management', () {
      testWidgets('should initialize with correct initial state',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: FunctionalNativeBannerAd(
                adUnitId: testAdUnitId,
              ),
            ),
          ),
        );

        // Should show loading state initially
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Error Handling', () {
      test('should handle null ad unit id gracefully', () {
        expect(
          () => FunctionalNativeBannerAd(adUnitId: ''),
          returnsNormally,
        );
      });
    });

    group('Template Types', () {
      test('TemplateType enum should have correct values', () {
        expect(TemplateType.values.length, greaterThanOrEqualTo(2));
        expect(TemplateType.values, contains(TemplateType.small));
        expect(TemplateType.values, contains(TemplateType.medium));
      });
    });
  });
}
