require 'digest/md5'
require 'open3'
require 'rufus-scheduler'
$scheduler = Rufus::Scheduler.new
$theFileDir = '/Users/Shared/GitHub/QuanGe.github.io/'
$subcmd = "cd #{$theFileDir} "
$tag = 0
def pushCode()
  if($subcmd != "cd #{$theFileDir} ")
    $subcmd.concat("&& git commit -m 'update weibo data' && git push")
    puts "开始上传微博数据#{$subcmd}"
    Open3.popen3($subcmd) do |stdin, stdout, stderr, wait_thr|
      $subcmd = "cd #{$theFileDir} "
      stdout.each_line { |line|
        puts line
      }
      #puts "上传成功"
    end

  end

end

def traverse_dir()

  cd = "ruby /Users/Shared/GitHub/QuanGe.github.io/images/jhds/weibo/script/getWeiboData.rb &&


        ruby /Users/Shared/GitHub/QuanGe.github.io/images/jhds/weibo/script/weiboClipToTxt.rb && cd #{$theFileDir} && git status"
  Open3.popen3(cd) do |stdin, stdout, stderr, wait_thr|

    $subcmd = "cd #{$theFileDir} "
    stdout.each_line { |line|
      if (!line.include?"On branch master") && (!line.include?" to unstage") && (!line.include?" update what will be committed") && (!line.include?"Your branch is up") && (!line.include?"Changes not staged") && (!line.include?"include in what will be committed") && (!line.include?"Untracked files") && (!line.include?"no changes added t") && (!line.include?"git checkout --")

        if(line.include?"modified:   ")
          file = line.split("modified:   ").last.rstrip
          if (!line.include?"getWeiboData") && (!line.include?"zrun")
            $subcmd.concat("&& git add #{file}")
          end
        elsif(line.include?"new file:   ")
          file = line.split("new file:   ").last.rstrip
          if (!line.include?"getWeiboData") && (!line.include?"zrun")
            $subcmd.concat("&& git add #{file}")
          end
        elsif line.include?"."
          $subcmd.concat("&& git add #{line.lstrip.rstrip}")
        end

      end

    }


  end


end

def dowiboData()
  $scheduler.every '15s' do
    if($tag==0)
      puts "开始处理微博数据"
      traverse_dir()
      $tag = $tag +1
    else
      puts "将要上传微博数据#{$subcmd}"
      pushCode()
      $tag = 0
    end


  end
  $scheduler.join
end

dowiboData()


