platform :ios, '13.0'

target 'Splashing' do
  use_frameworks!

  pod 'CocoaLumberjack/Swift'
  pod 'KeychainAccess'
  pod 'Kingfisher'
  pod 'RxCocoa'
  pod 'RxKingfisher'
  pod 'RxOptional', '4.0.0'
  pod 'RxSwift'
  pod 'SnapKit'
  pod 'SwiftyImage', '~> 1.1'
  pod 'Then'
  pod 'Toaster'
  
  deployment_target = '13.0'

  post_install do |installer|
      installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
              end
          end
          project.build_configurations.each do |bc|
              bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
          end
      end
  end

end
