# Implementation Plan

- [ ] 1. 네이티브 광고 위젯 기본 구조 생성
  - FunctionalNativeBannerAd StatefulWidget 클래스 생성
  - 필수 매개변수 (adUnitId) 및 선택적 매개변수 정의
  - State 클래스 기본 구조 구현
  - _Requirements: 1.1, 4.1_

- [ ] 2. 네이티브 광고 로딩 및 상태 관리 구현
  - NativeAd 인스턴스 생성 및 초기화 로직 구현
  - 광고 로드 상태 관리 (_isAdLoaded 플래그)
  - didChangeDependencies에서 광고 초기화 구현
  - _Requirements: 1.2, 4.2_

- [ ] 3. 네이티브 광고 리스너 시스템 구현
  - NativeAdListener 래퍼 함수 생성
  - onAdLoaded, onAdFailedToLoad, onAdClicked, onAdImpression 콜백 처리
  - 사용자 정의 리스너와 내부 리스너 연결
  - _Requirements: 3.1, 3.2, 3.3, 3.4_

- [ ] 4. 에러 처리 및 디버깅 시스템 구현
  - 광고 로드 실패 시 에러 처리 로직
  - 디버그 정보 출력 기능
  - 광고 리소스 자동 정리 메커니즘
  - _Requirements: 1.3, 4.2_

- [ ] 5. 위젯 렌더링 및 크기 조정 구현
  - AdWidget을 사용한 네이티브 광고 표시
  - 동적 크기 계산 로직 (_calculateAdSize 메서드)
  - 반응형 레이아웃 지원
  - _Requirements: 5.1, 5.2, 5.3_

- [ ] 6. 네이티브 광고 템플릿 시스템 구현
  - NativeTemplateType enum 정의
  - 기본 템플릿 스타일 설정
  - 커스텀 NativeTemplateStyle 지원
  - _Requirements: 2.2, 2.3_

- [ ] 7. 폴백 UI 및 로딩 상태 표시 구현
  - 광고 로드 중 플레이스홀더 UI
  - 광고 로드 실패 시 빈 컨테이너 표시
  - 로딩 인디케이터 또는 텍스트 표시
  - _Requirements: 1.3, 2.2_

- [ ] 8. 라이브러리 통합 및 export 설정
  - functional_google_mobile_ads.dart에 FunctionalNativeBannerAd export 추가
  - 필요한 Google Mobile Ads 타입들 re-export
  - 라이브러리 일관성 확인
  - _Requirements: 4.3_

- [ ] 9. 단위 테스트 작성
  - 위젯 생성 및 초기화 테스트
  - 광고 로드 상태 변화 테스트
  - 리스너 콜백 호출 테스트
  - 에러 처리 로직 테스트
  - _Requirements: 1.1, 1.2, 3.1, 3.2, 3.3, 3.4_

- [ ] 10. 위젯 테스트 작성
  - 네이티브 광고 렌더링 테스트
  - 다양한 화면 크기에서의 레이아웃 테스트
  - 로딩 상태 UI 표시 테스트
  - 에러 상태 UI 표시 테스트
  - _Requirements: 5.1, 5.2, 5.3_

- [ ] 11. 예제 앱에 네이티브 광고 통합
  - example/lib/main.dart에 FunctionalNativeBannerAd 사용 예제 추가
  - 테스트 네이티브 광고 ID 사용
  - 다양한 템플릿 타입 시연
  - _Requirements: 1.1, 2.1, 2.2_

- [ ] 12. 문서화 및 사용법 가이드 작성
  - README.md에 FunctionalNativeBannerAd 사용법 추가
  - 코드 주석 및 문서화 완성
  - 커스터마이징 옵션 설명 추가
  - _Requirements: 4.1, 2.1_