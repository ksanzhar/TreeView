target 'TreeUI' do
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, ‘9.0’
use_frameworks!

pod 'SwiftHTTP', '~> 2.0.0'
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'AlamofireImage'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = ‘3.0’
        end
    end
end
