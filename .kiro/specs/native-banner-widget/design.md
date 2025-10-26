# Design Document

## Overview

FunctionalNativeBannerAd는 Google Mobile Ads의 네이티브 광고를 Flutter 앱에서 쉽게 사용할 수 있도록 하는 StatefulWidget입니다. 이 위젯은 기존 FunctionalBannerAd의 패턴을 따르면서도 네이티브 광고의 특성에 맞는 커스터마이징 기능을 제공합니다.

네이티브 광고는 앱의 콘텐츠와 자연스럽게 어우러지는 광고 형태로, 개발자가 광고의 레이아웃과 스타일을 자유롭게 커스터마이징할 수 있습니다. 이를 통해 사용자 경험을 해치지 않으면서도 효과적인 광고 노출이 가능합니다.

## Architecture

### Class Structure

```
FunctionalNativeBannerAd (StatefulWidget)
├── _FunctionalNativeBannerAdState (State)
│   ├── NativeAd _nativeAd
│   ├── NativeAdListener _nativeAdListener
│   ├── AdRequest _adRequest
│   └── bool _isAdLoaded
└── NativeAdListener (callback wrapper)
```

### Widget Lifecycle

1. **Initialization**: `didChangeDependencies()`에서 네이티브 광고 초기화
2. **Loading**: `NativeAd.load()` 호출하여 광고 로드
3. **Display**: 광고 로드 완료 시 `AdWidget`으로 표시
4. **Disposal**: `dispose()`에서 네이티브 광고 리소스 정리

## Components and Interfaces

### FunctionalNativeBannerAd Widget

```dart
class FunctionalNativeBannerAd extends StatefulWidget {
  const FunctionalNativeBannerAd({
    Key? key,
    required this.adUnitId,
    this.nativeAdOptions,
    this.nativeAdListener,
    this.adRequest,
    this.width,
    this.height,
    this.templateType = TemplateType.medium,
    this.nativeTemplateStyle,
  }) : super(key: key);

  final String adUnitId;
  final NativeAdOptions? nativeAdOptions;
  final NativeAdListener? nativeAdListener;
  final AdRequest? adRequest;
  final double? width;
  final double? height;
  final TemplateType templateType;
  final NativeTemplateStyle? nativeTemplateStyle;
}
```

### State Management

```dart
class _FunctionalNativeBannerAdState extends State<FunctionalNativeBannerAd> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;
  
  // 네이티브 광고 초기화
  void _initializeNativeAd();
  
  // 네이티브 광고 리스너 생성
  NativeAdListener _createNativeAdListener();
  
  // 위젯 크기 계산
  Size _calculateAdSize(BuildContext context);
}
```

### Native Ad Listener Wrapper

기존 FunctionalBannerAd의 패턴을 따라 사용자 정의 리스너를 래핑하는 구조:

```dart
NativeAdListener _createNativeAdListener() {
  return NativeAdListener(
    onAdLoaded: (ad) {
      setState(() => _isAdLoaded = true);
      widget.nativeAdListener?.onAdLoaded?.call(ad);
    },
    onAdFailedToLoad: (ad, error) {
      widget.nativeAdListener?.onAdFailedToLoad?.call(ad, error);
      ad.dispose();
      debugPrint('Failed to load native ad: $error');
    },
    // 기타 이벤트 핸들러들...
  );
}
```

## Data Models

### Template Types

네이티브 광고 템플릿 타입을 정의하는 enum:

```dart
enum NativeTemplateType {
  small,   // 작은 템플릿 (이미지 + 텍스트)
  medium,  // 중간 템플릿 (기본)
  large,   // 큰 템플릿 (더 많은 콘텐츠)
}
```

### Native Ad Configuration

네이티브 광고 설정을 위한 데이터 모델:

```dart
class NativeAdConfiguration {
  final String adUnitId;
  final NativeAdOptions? options;
  final AdRequest request;
  final NativeTemplateType templateType;
  final NativeTemplateStyle? templateStyle;
  
  const NativeAdConfiguration({
    required this.adUnitId,
    this.options,
    this.request = const AdRequest(),
    this.templateType = NativeTemplateType.medium,
    this.templateStyle,
  });
}
```

## Error Handling

### Error Types

1. **Load Errors**: 네이티브 광고 로드 실패
2. **Display Errors**: 네이티브 광고 표시 실패
3. **Configuration Errors**: 잘못된 설정 매개변수

### Error Handling Strategy

```dart
void _handleAdLoadError(Ad ad, LoadAdError error) {
  // 1. 광고 리소스 정리
  ad.dispose();
  
  // 2. 디버그 정보 출력
  debugPrint('Native ad failed to load: ${error.message}');
  
  // 3. 사용자 콜백 호출
  widget.nativeAdListener?.onAdFailedToLoad?.call(ad, error);
  
  // 4. 상태 업데이트 (필요시)
  if (mounted) {
    setState(() => _isAdLoaded = false);
  }
}
```

### Fallback Mechanism

네이티브 광고 로드 실패 시 빈 컨테이너 또는 플레이스홀더 표시:

```dart
Widget _buildAdWidget() {
  if (_isAdLoaded && _nativeAd != null) {
    return AdWidget(ad: _nativeAd!);
  } else {
    return Container(
      width: widget.width ?? _calculateAdSize(context).width,
      height: widget.height ?? _calculateAdSize(context).height,
      color: Colors.grey[200],
      child: const Center(
        child: Text('Ad Loading...', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
```

## Testing Strategy

### Unit Tests

1. **Widget Creation Tests**
   - 필수 매개변수 검증
   - 기본값 설정 확인
   - 위젯 생성 및 초기화 테스트

2. **State Management Tests**
   - 광고 로드 상태 변화 테스트
   - 리스너 콜백 호출 확인
   - 에러 상태 처리 테스트

3. **Lifecycle Tests**
   - 위젯 생성/소멸 시 리소스 관리
   - 메모리 누수 방지 확인

### Widget Tests

1. **Rendering Tests**
   - 광고 로드 전/후 UI 렌더링 확인
   - 다양한 화면 크기에서의 레이아웃 테스트
   - 에러 상태 UI 표시 확인

2. **Interaction Tests**
   - 광고 클릭 이벤트 처리
   - 콜백 함수 호출 확인

### Integration Tests

1. **Ad Loading Tests**
   - 실제 테스트 광고 ID를 사용한 로드 테스트
   - 네트워크 연결 상태에 따른 동작 확인

2. **Performance Tests**
   - 메모리 사용량 모니터링
   - 광고 로드 시간 측정

### Test Configuration

```dart
// 테스트용 네이티브 광고 ID (Google 제공)
class TestNativeAdIds {
  static const String android = 'ca-app-pub-3940256099942544/2247696110';
  static const String ios = 'ca-app-pub-3940256099942544/3986624511';
}

// 테스트 헬퍼 함수
Widget createTestNativeAd({
  String? adUnitId,
  NativeAdListener? listener,
}) {
  return FunctionalNativeBannerAd(
    adUnitId: adUnitId ?? TestNativeAdIds.android,
    nativeAdListener: listener,
  );
}
```

## Implementation Considerations

### Platform Compatibility

- Android: Google Mobile Ads SDK 지원
- iOS: Google Mobile Ads SDK 지원
- 플랫폼별 네이티브 광고 템플릿 차이점 고려

### Performance Optimization

1. **Lazy Loading**: 위젯이 화면에 표시될 때만 광고 로드
2. **Resource Management**: dispose() 시 확실한 리소스 정리
3. **Memory Efficiency**: 불필요한 상태 변수 최소화

### Accessibility

1. **Screen Reader Support**: 네이티브 광고 콘텐츠에 적절한 시맨틱 라벨 제공
2. **Focus Management**: 키보드 네비게이션 지원
3. **High Contrast**: 고대비 모드에서의 가독성 확보

### Customization Flexibility

1. **Template System**: 다양한 네이티브 광고 템플릿 지원
2. **Style Customization**: 색상, 폰트, 레이아웃 커스터마이징
3. **Size Adaptation**: 다양한 화면 크기에 대한 반응형 디자인