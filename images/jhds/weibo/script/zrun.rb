require 'digest/md5'

$theFileDir = '/Users/Shared/GitHub/QuanGe.github.io/images/jhds/weibo/data/'

def traverse_dir()
  result =  system "cd #{$theFileDir} git status"
  puts result
end
traverse_dir()