require 'rake'
require 'rake/testtask'
require 'rubygems'

desc "Run tests."
Rake::TestTask.new do | t |
  t.test_files = FileList['tests/**/test_*.rb']
end