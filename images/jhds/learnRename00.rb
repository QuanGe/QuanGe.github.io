require 'digest/md5'


def traverse_dir()
  theFileDir = '/Users/Shared/GitHub/QuanGe.github.io/images/jhds/learn/'
    if File.directory? theFileDir
        count = 0

        Dir.foreach(theFileDir) do |file|
            if file !="." and file !=".." and file !=".DS_Store"
              count = count+1
              oldName = theFileDir+ file

              if(file.length<32)
                type,lessonIndex,imgIndex = file.split('-')
                timestr = Time.now.strftime("%Y%m%d%H%M%S") + "QuanGeLabLn"+"#{type}#{lessonIndex}"
                newName = ""
                if(count<10)
                  newName = theFileDir+"z0000"+count.to_s+"-"+Digest::MD5.hexdigest(timestr)+"-"+file
                elsif(count>9&&count<100)
                  newName = theFileDir+"z000"+count.to_s+"-"+Digest::MD5.hexdigest(timestr)+"-"+file
                elsif(count>99&&count<1000)
                  newName = theFileDir+"z00"+count.to_s+"-"+Digest::MD5.hexdigest(timestr)+"-"+file
                elsif(count>999&&count<10000)
                  newName = theFileDir+"z0"+count.to_s+"-"+Digest::MD5.hexdigest(timestr)+"-"+file
                end

                File.rename(oldName,newName)

              end

            end
        end

        puts "已经解析到#{theFileDir}文件夹"
    else
        puts "File:#{File.basename(theFileDir)}, Size:#{File.size(theFileDir)}"
    end
end
traverse_dir()