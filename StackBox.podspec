#
# Be sure to run `pod lib lint StackBox.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'StackBox'
  s.version          = '0.1.0'
  s.summary          = 'StackBox is a scrollable container where you can easily insert and remove boxes
.'

  s.description      = <<-DESC
StackBox is dynamic so you don't have to worry about the contentSize. Sub-boxes are
manage by a UIStackView.

StackBoxBox is the container object use by the StackBox to render stacks
Each box contains the StackBoxView create initialy by the you
Create your own StackBoxView by setting a view, his offset and alignement
                       DESC

  s.homepage         = 'https://github.com/hugweb/StackBox'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hugweb' => 'hugweb@gmail.com' }
  s.source           = { :git => 'https://github.com/hugweb/StackBox.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'StackBox/Classes/**/*'
  
end
