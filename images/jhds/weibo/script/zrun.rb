require 'digest/md5'
require 'open3'
$theFileDir = '/Users/Shared/GitHub/QuanGe.github.io/'

def traverse_dir()

  cd = "ruby /Users/Shared/GitHub/QuanGe.github.io/images/jhds/weibo/script/getWeiboData.rb &&


        ruby /Users/Shared/GitHub/QuanGe.github.io/images/jhds/weibo/script/weiboClipToTxt.rb && cd #{$theFileDir} && git status"
  Open3.popen3(cd) do |stdin, stdout, stderr, wait_thr|

    subcmd = "cd #{$theFileDir} "
    stdout.each_line { |line|
      if (!line.include?"On branch master") && (!line.include?"Your branch is up-") && (!line.include?"Changes not staged") && (!line.include?"git add <file>.") && (!line.include?"Untracked files") && (!line.include?"no changes added t") && (!line.include?"git checkout --")
        puts line
        if(line.include?"modified:   ")
          subcmd = subcmd + "&& git add #{line.split("modified:   ").last}"
        elsif line.include?"."
          subcmd = subcmd + "&& git add #{line}"
        end
      end

    }
    puts subcmd
  end
end
traverse_dir()