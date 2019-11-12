platform :ios, '10.0'

target 'readhub' do
  use_frameworks!

  # ignore all warnings from all pods
  inhibit_all_warnings!

  # Pods for readhub

  # Rx
  pod 'RxSwift', '~> 5.0'
  pod 'RxCocoa', '~> 5.0'
  pod "RxGesture"
  pod 'Moya/RxSwift', ' ~> 14.0.0-alpha.2'
  pod 'RxDataSources', '~> 4.0'
  pod 'NSObject+Rx'

  # UI
  pod 'SnapKit', '~> 5.0'
  pod 'MJRefresh', '~> 3.2'
  pod 'Reusable', '~> 4.1'
  pod 'TYPagerController', '~> 2.1.2'

  # Utils
  pod 'Then', '~> 2.6'
  pod 'SwiftDate', '~> 6.1'

  # Debug
  pod 'Reveal-SDK', :configurations => ['Debug']

  target 'readhubTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'readhubUITests' do
    # Pods for testing
  end

end
