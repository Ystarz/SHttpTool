# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
inhibit_all_warnings!

def cp #通用pods集
    # pod 'AFNetworking','~> 3.2.1'
    # pod 'Masonry'
    pod 'SDataTools'
    pod 'AFNetworking'
end
target 'SHttpTool' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  platform :ios, '9.3'
  cp
  # Pods for SHttpTool

  target 'SHttpToolTests' do
    # Pods for testing
  end

end

target 'SHttpTool_mac' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  platform :osx, '10.10'
  cp
  # Pods for SHttpTool_mac

end
