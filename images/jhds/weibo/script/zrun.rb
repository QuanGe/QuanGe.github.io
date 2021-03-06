#encoding: utf-8
require 'digest/md5'
require 'open3'
require 'rufus-scheduler'
require 'rubygems'
require 'rufus/scheduler'
$scheduler = Rufus::Scheduler.new
$theFileDir = '../../../../'
$subcmd = ""
$tag = 0
def pushCode()
  if($subcmd != "")
    timestr = Time.now.strftime("%Y%m%d%H%M%S")
    $subcmd.concat(" && git commit -m 'update weibo data#{timestr}' && git pull --rebase && git push")
    puts timestr+"开始上传微博数据#{$subcmd}"
    Open3.popen3($subcmd) do |stdin, stdout, stderr, wait_thr|
      $subcmd = ""
      stdout.each_line { |line|
        puts line
      }
      #puts "上传成功"
    end

  end

end

def traverse_dir()

  cd = "ruby ./getWeiboData.rb && ruby ./getWeiboDatalyh.rb && ruby ./getWeiboDatalyy.rb && ruby ./weiboClipToTxt.rb && cd #{$theFileDir} && git status "
  Open3.popen3(cd) do |stdin, stdout, stderr, wait_thr|

    $subcmd = ""
    stdout.each_line { |line|
      if (!line.include?"On branch master") && (!line.include?" to unstage") && (!line.include?" update what will be committed") && (!line.include?"Your branch is up") && (!line.include?"Changes not staged") && (!line.include?"include in what will be committed") && (!line.include?"Untracked files") && (!line.include?"no changes added t") && (!line.include?"git checkout --")

        if(line.include?"modified:   ")
          file = line.split("modified:   ").last.rstrip
          if (!line.include?"getWeiboData") && (!line.include?"zrun") && ($subcmd == "")
           $subcmd.concat("git add --all #{$theFileDir}")
          end
        elsif(line.include?"new file:   ")
          file = line.split("new file:   ").last.rstrip
          if (!line.include?"getWeiboData") && (!line.include?"zrun") && ($subcmd == "")
            $subcmd.concat("git add --all #{$theFileDir}")
          end
        elsif (line.include?".") && ($subcmd == "")
          $subcmd.concat("git add --all #{$theFileDir}")
        else
          
        end

      end

    }


  end


end

def dowiboData()
  $scheduler.every '60s' do
    timestr = Time.now.strftime("%Y%m%d%H%M%S")
    if($tag==0)
      
      puts  timestr+"====开始处理微博数据"
      traverse_dir()
      $tag = $tag +1
    else
      puts  timestr+"将要上传微博数据#{$subcmd}"
      pushCode()
      $tag = 0
    end


  end
  $scheduler.join
end

dowiboData()


