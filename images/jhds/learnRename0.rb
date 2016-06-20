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
                newName = theFileDir+Digest::MD5.hexdigest(timestr)+"-"+file

                File.rename(oldName,newName)
              else


                md5str,type,lessonIndex,imgIndex = file.split('-')
                timestr = Time.now.strftime("%Y%m%d%H%M%S") + "QuanGeLabLn"+"#{type}#{lessonIndex}"
                newName = theFileDir+"#{type}-#{lessonIndex}-#{imgIndex}"
                #newName = theFileDir+Digest::MD5.hexdigest(timestr)+"-#{type}-#{lessonIndex}-#{imgIndex}"

                File.rename(oldName,newName)

              end

            end
        end
    else
        puts "File:#{File.basename(theFileDir)}, Size:#{File.size(theFileDir)}"
    end
end
traverse_dir()