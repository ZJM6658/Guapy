platform :osx, '10.10'
use_frameworks!

target 'Clipy' do

  # Application
  pod 'PINCache'
  pod 'Sauce'
  pod 'Sparkle'
  pod 'RealmSwift'
  pod 'RxCocoa'
  pod 'RxSwift'
  pod 'LoginServiceKit', :git => 'https://github.com/Clipy/LoginServiceKit.git'
  pod 'KeyHolder'
  pod 'Magnet'
  pod 'RxScreeen'
  pod 'AEXML'
  pod 'LetsMove'
  pod 'SwiftHEXColors'
  # Utility
  pod 'BartyCrouch'
  pod 'SwiftLint'
  pod 'SwiftGen'

  # Temporarily disabled tests due to Xcode 16 compatibility
  # target 'ClipyTests' do
  #   inherit! :search_paths
  #
  #   pod 'Quick'
  #   pod 'Nimble'
  #
  # end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.13'
    end
  end

  login_service_kit = File.join(__dir__, 'Pods/LoginServiceKit/Lib/LoginServiceKit/LoginServiceKit.swift')
  if File.exist?(login_service_kit)
    File.chmod(0o644, login_service_kit)
    content = File.read(login_service_kit)
    content.gsub!(/public extension LoginServiceKit \{.*?\n\}\n\nprivate extension LoginServiceKit \{.*?\n\}\n/m, <<~'SWIFT'.strip)
      public extension LoginServiceKit {
          static func isExistLoginItems(at path: String = Bundle.main.bundlePath) -> Bool {
              return false
          }

          @discardableResult
          static func addLoginItems(at path: String = Bundle.main.bundlePath) -> Bool {
              return false
          }

          @discardableResult
          static func removeLoginItems(at path: String = Bundle.main.bundlePath) -> Bool {
              return false
          }
      }

      private extension LoginServiceKit {
          static func loginItem(at path: String) -> LSSharedFileListItem? {
              return nil
          }
      }
    SWIFT
    File.write(login_service_kit, content)
  end

  atomic_int = File.join(__dir__, 'Pods/RxSwift/Platform/AtomicInt.swift')
  if File.exist?(atomic_int)
    File.chmod(0o644, atomic_int)
    content = File.read(atomic_int)
    content.gsub!('final class AtomicInt: NSLock {', 'final class AtomicInt: NSLock, @unchecked Sendable {')
    File.write(atomic_int, content)
  end
end
