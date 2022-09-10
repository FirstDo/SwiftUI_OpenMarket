# 🛒 오픈 마켓 (with SwiftUI)
> 프로젝트 기간: 2022-09-05 ~ 2022-09-010
> 개인 프로젝트

## 🔎 프로젝트 소개

> 물건을 사고 파는 나만의 오픈마켓 with SwiftUI

## 🔑 키워드

- SwiftUI (3.0)
- Combine, MVVM
- async await
- UIViewControllerRepresentable(PHPickerViewController)
- `Image Caching`과 `무한 스크롤`

## 🛠 개발환경 및 라이브러리
- [![swift](https://img.shields.io/badge/swift-5.5-orange)]()
- [![xcode](https://img.shields.io/badge/Xcode-13.0-purple)]()
- [![iOS](https://img.shields.io/badge/iOS-15.0-red)]()
- [![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-blue)]()

## 📺 프로젝트 실행화면

|메인화면|무한스크롤|
|---|---|
|![ 프로모션 페이지](https://user-images.githubusercontent.com/69573768/189482967-101661ca-b7fe-48b8-865e-a4b745e3ff23.gif)|![무한스크롤](https://user-images.githubusercontent.com/69573768/189482887-170cd5b6-5130-4e7b-9b80-a7d23bf74844.gif)|

|상품등록|상품삭제|
|---|---|
|![RPReplay_Final1662814860](https://user-images.githubusercontent.com/69573768/189484639-6d513a63-50c7-4652-916d-1772c41361a6.gif)|![RPReplay_Final1662811037](https://user-images.githubusercontent.com/69573768/189483141-b35efb09-46d8-4294-9f1d-58e8371a30ad.gif)|

## 이슈

### 무한스크롤

UIKit에서는 CollectionView의 PrefetchDataSource를  이용했지만, 
SwiftUI에서는 해당기능이 없어서 List + ProductView의 onAppear를 이용해서 그냥 미리 네트워크 요청을 보내도록 구현

### NavigationLink & Routing

SwiftUI는 Routing이 너무 불편하다 
Routing, Alert을 위한 State 프로퍼티들을 ViewModel에서 관리하는데, 너무 지저분하다는 생각이 들었다

ex) 리스트의 뷰중 하나를 누르면, 다음페이지로 넘어가는 이 간단한 기능을 예로 들어보자

<img src = "https://user-images.githubusercontent.com/69573768/189484958-3b75c597-0925-4b49-8f01-a06d09a0e8aa.gif" width = "200">

UIKit이라면 Delegate나 rx를 통해 한줄의 코드로 해결이 가능하다

SwiftUI는, 해당 뷰에 tapGesture를 달아서

```swift
  // ProductMainViewModel
  @Published var showProductDetailView = false
  @Published var selectedProduct = Product.preview
}
```

이 두가지 프로퍼티를 변경해 줘야한다.
그러면 뷰 어딘가 선언되어 있는 코드가 실행되어서 화면이 전환된다

```swift
NavigationLink(
  destination: viewFactory.productDetailView(
    with: viewModel.selectedProduct,
    updateTrigger: viewModel.refresh
  ),
  isActive: $viewModel.showProductDetailView,
  label: { EmptyView() }
)
```

물론 내가 방법을 모르는 걸수도 있다..

### View Refreshing (issue)

https://user-images.githubusercontent.com/69573768/189488594-fccd510b-8d37-49ca-b437-aae1cd2889eb.MP4

화면이 전환되거나 다시 되돌아 올때, 왜인지는 모르겠는데 View가 Refreshing된다.
SwiftUI는 @State로 된 프로퍼티가 바뀐다면, View가 업데이트 된느걸로 알고 있는데, 
Routing을 위한 프로퍼티만 변경됬음에도 불구하고 View가 새로고침되는 이슈가 있다

### UIKit vs SwiftUI

편한건 엄청편한데 (view 그리기, preview, list의 refreshable, searchable 등등),
불편한건 엄청 불편하다 (Navivagion Custom, Alert, Sheet, NavigationLink 등등..)
결국 핵심은 단방향 아키텍쳐를 적용하는것인것 같다. 현재 Pure한 MVVM은 별로 좋지 않아보임
대부분의 문제를 TCA로 해결할 수 있다고 들어서, 추후 공부 예정

