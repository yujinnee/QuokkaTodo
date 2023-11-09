# QuokkaTodo
> 🤎 쿼카와 함께 성장하는 행복투두, 쿼카투두
>
> 📅 2023.09.25 ~ 2023.10.25
> [🔗 쿼카투두 - 앱 스토어 링크 바로 가기](https://apps.apple.com/app/id6470385256) </br>
![Group 70 (1)](https://github.com/yujinnee/QuokkaTodo/assets/51031771/1dd665a3-0a6c-4f0c-a7bc-3c8c81af4226)

## 🌱 Introduction
"쿼카투두" - 뽀모도로 타이머를 기반으로 쿼카와 함께 성장해 나갈 수 있는 투두 앱

## 📌 Features
### 투두 기록
- 오늘 할 일 / 곧 할 일 구분하여 투두 기록
- 나뭇잎 모양으로 투두별 작업 진행 시간 표시
- 투두 수정 및 삭제

### 뽀모도로 타이머
- 투두 별 25분 타이머 시작,일시정지,초기화 기능
- 원형 프로그레스바 애니메이션으로 남은 시간 표시 기능
- 라이브 액티비티를 통해 잠금화면에서 타이머 확인 가능
- 백그라운드 타이머 기능으로 앱을 종료해도 타이머 유지 가능
- 타이머 완료 시 알림 기능
  
### 쿼카 키우기 & 행복 일기
- 쿼카 캐릭터의 나뭇잎과 영양제 개수에 따른 유저 레벨 및 경험치 계산
- 유저 레벨에 따른 아이템 잠금 기능
- 경험치 프로그레스바 애니메이션 기능
- 데일리 일기 기록 및 특정 날짜 이전 일기 확인 잠금 기능
  
</br>


## 🛠️ Tech 
- UIKit, SwiftUI
- SnapKit, FSCalendar, Realm
- Firebase
- WidgetKit, ActivityKit, StoreKit, WebKit
- CompositionalLayout, DiffableDataSource
- MVC, MVVM
- RxSwift

</br>

## 회고
### Trouble Shooting
1. 백그라운드 타이머 with 뷰의 생명주기
  - 문제 상황 : 포그라운드 상태에서 타이머가 돌아가는 중에 앱의 화면을 백그라운드로 넘기면 백그라운드의 앱은 정해지지 않은 시점에 suspended로 넘어가게 됩니다. 운이 좋게 suspended로 넘어가지 않았다면 다시 앱을 포그라운드로 열었을 때도 돌아가던 타이머가 살아 있어 문제가 없어 보이지만 os의 처리에 의해 불특정한 시점에 suspended로 넘어가 버리게 되면 다시 앱을 열었을 때 타이머가 멈춰있던 것을 확인 하게 됩니다.
  - 해결 방법 : suspended로 넘어가든 안넘어가든 항상 동일하게 작동하도록 하기 위해 백그라운드를 넘어가는 시점에는 항상 예상 타이머 종료시간을 UserDefaults에 담아두고 다시 포그라운드로 넘어 올 때는 저장되어있는 예상 타이머 시간을 기준으로 뷰의 상태를 세팅하도록 구현하였습니다. 이를 적용하기 위해서 생명주기 함수를 살펴 보았는데  백그라운드로 넘어 갔을 때와 포그라운드로 돌아왔을 때의 시점에 대한 생명주기 함수는 뷰컨이 가지고 있지 않다는 것을 깨달았습니다. 해당 생명주기 함수는 AppDelegated에 있는데 NotificationCenter에 observer를 등록하여 해당 시점을 사용할 수 있었고 아래의 코드를 통해 백그라운드로 넘어갈때는 타이머를 invalidate()시키고 포그라운드로 넘어왔을 때 타이머 상태를 세팅 해주도록 하였습니다.

  ```Swift
  private func addLifeCycleObserver(){
        //옵저버 등록
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
   @objc private func didEnterBackground() {
        print("didEnterBackgroud")
        timer.invalidate()
    }

    @objc private func willEnterForeground() {
        print("willEnterForeground")
        setTimerProcess()
    }
private func setTimerProcess() {
             guard let endTime = DateFormatter.convertFromStringToDate(date: UserDefaultsHelper.standard.endTime ?? "") else { //저장되어있는 타이머 종료시간 확인
             ...
            return}
            ...
            leftTimeInterval = endTime.timeIntervalSince(.now)//남은 시간 계산
            timeLabel.text = leftTimeInterval.timeFormatString
            timer = Timer.scheduledTimer(timeInterval: timeUnit, target: self, selector: #selector(timerTimeChanged), userInfo: nil, repeats: true)//남은 시간부터 타이머 동작
            ...
}

  ```

2. 컬렉션뷰 동적 높이 설정하기
- 문제 상황 : 투두 컬렉션뷰의 라벨의 크기가 굉장히 길어질 경우 컬렉션뷰 셀의 높이를 동적으로 변하도록 설정하려고 하였으나 tableView의 AutomaticDimension 처럼 쉽게 설정할 수 있는 방법이 없었습니다.
- 해결 방법 : CollectionView의 sizeforItem에서  DummyCell을 만들어 해당 인덱스 데이터를 넣어보고 미리 사이즈를 결정한 뒤에 해당 사이즈를 리턴하는 방식을 이용하였습니다. 제가 동적 높이를 주려는 컬렉션뷰는 라벨의 길이에 따라 높이가 변하는 상태이기 때문에 라벨의 높이를 미리 가져와 설정해야하는 만큼 커스텀 셀에서 요소들의 오토레이아웃이 잘 잡혀있어야 했습니다. 셀 안에서 오토레이아웃을 잡을 때 라벨의 위치를 centerY로 했었을 때는 적용 되지 않았는데 verticalEdges(top,bottom)로 고정적으로 주니 해결 되었습니다.
     ```Swift
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let estimatedHeight: CGFloat = 300.0
        let dummyCell = TodoCollectionViewCell(frame: CGRect(x: 0, y: 0, width: width, height: estimatedHeight))
        
        switch indexPath.section{
        case 0:
            let item = soonArray?[indexPath.row] ?? Todo()
            dummyCell.todoLabel.text = item.contents
        case 1:
            let item = todayArray?[indexPath.row] ?? Todo()
            dummyCell.todoLabel.text = item.contents
        default:
            break
        }
        dummyCell.contentView.setNeedsLayout()
        dummyCell.contentView.layoutIfNeeded()
        var height = dummyCell.contentView.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)).height
        dummyCell.prepareForReuse()
        return CGSize(width: width, height: height)
        
    }
   ```


</br>

### 개발 기간
- 프로젝트 기간 : 2023.09.25 ~ 2022.10.25
  - 1주차 : 프로젝트 초기 설정, Realm 데이터베이스 및 투두 탭 초기 구현
  - 2주차 : 투두 탭 세부 기능 구현 및 FSCalendar 사용하여 달력뷰 구현,타이머 초기 구현
  - 3주차 : 타이머, 원형프로그레스바 및 라이브액티비티 구현
  - 4주차 : 쿼카 탭 및 설정 구현


## 📑 개발일지
[바로가기](https://succulent-stallion-ac8.notion.site/f8c8b6ae2d5d4d1f9095077393c01f20?v=b25bc72663a84af8a517ffff374e91db&pvs=4)

