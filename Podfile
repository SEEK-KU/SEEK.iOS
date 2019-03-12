# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

# Uncomment the next line to inhabits all warnings form the CocoaPods libraries
inhibit_all_warnings!

workspace 'SEEK.xcworkspace'

abstract_target 'App' do

  pod 'RxCocoa',    '~> 4.0'
  pod 'RxSwift',    '~> 4.0'

  target 'SEEK' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks

    project 'SEEK.xcodeproj'

    pod 'ActionSheetPicker-3.0'
    pod 'IQKeyboardManager'
    pod 'Moya', '~> 10.0'
    pod 'Moya/RxSwift', '~> 10.0'
    pod 'SnapKit', '~> 4.0'
    
  end

  target 'Shared' do

    project 'SEEK.xcodeproj'

    pod 'SnapKit', '~> 4.0'
  end
end

target 'APIGatewayService' do

  project 'APIGatewayService/APIGatewayService.xcodeproj'

  pod 'Moya', '~> 10.0'
  pod 'Moya/RxSwift', '~> 10.0'

end

target 'Interactor' do

  project 'Interactor/Interactor.xcodeproj'

  pod 'Moya', '~> 10.0'
  pod 'Moya/RxSwift', '~> 10.0'
  pod 'RxSwift',    '~> 4.0'

end
