require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/gempackagetask'

desc "Run tests."
Rake::TestTask.new do | t |
  t.test_files = FileList['tests/**/test_*.rb']
end

spec = Gem::Specification.new do |s|
  s.name = "httprb"
  s.version = File.read('VERSION').chomp
  s.author = "thomas metge"
  s.email = "tom@accident-prone.com"
  s.homepage = "http://github.com/tommetge/httprb"
  s.summary = "http the ruby way: sinatra-like http client DSL"
  s.description = "HTTP client DSL, inspired by sinatra."
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.test_files = FileList["{tests}/**/*"].to_a
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
  pkg.need_zip = true
end