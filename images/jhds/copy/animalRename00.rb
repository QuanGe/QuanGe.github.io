require 'digest/md5'


def traverse_dir()
  theFileDir = '/Users/Shared/GitHub/QuanGe.github.io/images/jhds/copy/plant/'
    if File.directory? theFileDir
        count = 0
        Dir.foreach(theFileDir) do |file|
            if file !="." and file !=".." and file !=".DS_Store"
              count = count+1
              if file.length != 36
                oldName = theFileDir+ file
                timestr = Time.now.strftime("%Y%m%d%H%M%S")
                newName = theFileDir+"zzQuanGeLabDw"+count.to_s+timestr
                File.rename(oldName,newName)
              end
            end
        end
    else
        puts "File:#{File.basename(theFileDir)}, Size:#{File.size(theFileDir)}"
    end
end
traverse_dir()