Pod::Spec.new do |s|
    s.name    = 'ServiceKit'
    s.version = '0.2.0'
    s.summary = 'SOA Services Kit for iOS development.'

    # MUST add all new service to kit' SOA list 
    s.description = <<-DESC
Collection of SOA Services:
- StoreService
- NetworkConnectionService (Reachability)
    DESC
    
    s.homepage = 'https://github.com/Viveron/ServiceKit'
    s.license  = { :type => 'MIT', :file => 'LICENSE' }
    s.author   = { 'Victor Shabanov' => 'shabanov.dev.git@gmail.com' }
    s.source   = { :git => 'https://github.com/Viveron/ServiceKit.git', :tag => s.version.to_s }
    
    s.swift_version         = '4.2'
    s.ios.deployment_target = '9.0'
    
    s.subspec 'StoreService' do |ss|
        ss.source_files        = 'ServiceKit/Services/StoreService/**/*'
        ss.header_mappings_dir = 'ServiceKit/Services/StoreService'
        ss.frameworks          = 'StoreKit'
    end

    s.subspec 'NetworkConnectionService' do |ncs|
        ncs.source_files        = 'ServiceKit/Services/NetworkConnectionService/**/*'
        ncs.header_mappings_dir = 'ServiceKit/Services/NetworkConnectionService'
        ncs.frameworks          = 'SystemConfiguration'
    end
end
