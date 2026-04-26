Pod::Spec.new do |s|
  s.name             = 'iOSAppTemplates'
  s.version          = '2.1.0'
  s.summary          = 'Swift package template families and starter surfaces for Apple platform app ideas.'
  s.description      = <<-DESC
    iOSAppTemplates ships modular Swift package targets, template families, and starter
    app surfaces for common Apple-platform product lanes. The repository currently mixes
    shared package modules, standalone template roots, examples, and documentation. Use
    it as a starter system and code reference, not as blanket distribution proof.
  DESC

  s.homepage         = 'https://github.com/muhittincamdali/iOSAppTemplates'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhittin Camdali' => 'contact@muhittincamdali.com' }
  s.source           = { :git => 'https://github.com/muhittincamdali/iOSAppTemplates.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.osx.deployment_target = '12.0'
  s.tvos.deployment_target = '15.0'
  s.watchos.deployment_target = '8.0'

  s.swift_versions = ['5.9', '5.10', '6.0']

  s.source_files = 'Sources/**/*.swift'

  s.frameworks = 'Foundation', 'SwiftUI', 'Combine'

  s.default_subspecs = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'Sources/iOSAppTemplates/**/*.swift'
  end

  s.subspec 'Social' do |social|
    social.source_files = 'Sources/SocialTemplates/**/*.swift'
    social.dependency 'iOSAppTemplates/Core'
  end

  s.subspec 'Commerce' do |commerce|
    commerce.source_files = 'Sources/CommerceTemplates/**/*.swift'
    commerce.dependency 'iOSAppTemplates/Core'
  end

  s.subspec 'Health' do |health|
    health.source_files = 'Sources/HealthTemplates/**/*.swift'
    health.dependency 'iOSAppTemplates/Core'
  end

  s.subspec 'Finance' do |finance|
    finance.source_files = 'Sources/FinanceTemplates/**/*.swift'
    finance.dependency 'iOSAppTemplates/Core'
  end

  s.subspec 'Education' do |education|
    education.source_files = 'Sources/EducationTemplates/**/*.swift'
    education.dependency 'iOSAppTemplates/Core'
  end

  s.subspec 'Travel' do |travel|
    travel.source_files = 'Sources/TravelTemplates/**/*.swift'
    travel.dependency 'iOSAppTemplates/Core'
  end

  s.subspec 'Productivity' do |productivity|
    productivity.source_files = 'Sources/ProductivityTemplates/**/*.swift'
    productivity.dependency 'iOSAppTemplates/Core'
  end

  s.subspec 'Entertainment' do |entertainment|
    entertainment.source_files = 'Sources/EntertainmentTemplates/**/*.swift'
    entertainment.dependency 'iOSAppTemplates/Core'
  end
end
