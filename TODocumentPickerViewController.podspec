Pod::Spec.new do |spec|
  spec.name         = 'TODocumentPickerViewController'
  spec.version      = '0.1.0'
  spec.platform     = :ios, '7.0'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage     = 'https://github.com/TimOliver/TODocumentPickerViewController'
  spec.authors      = { 'Tim Oliver' => 'info@timoliver.com.au' }
  spec.summary      = 'A view controller for interacting with file systems on iOS.'
  spec.source       = { :git => 'https://github.com/TimOliver/TODocumentPickerViewController.git', :tag => spec.version }
  spec.source_files = 'TODocumentPickerViewController/**/*.{h,m}'
end
