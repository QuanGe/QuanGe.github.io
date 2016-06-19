require 'digest/md5'


def traverse_dir()
  theFileDir = '/Users/Shared/GitHub/QuanGe.github.io/images/jhds/copy/plant/'
  theTextDir = '/Users/Shared/GitHub/QuanGe.github.io/images/jhds/copy/'
  theTextUrl = 'http://quangelab.com/images/jhds/copy/plant/'
  theTextTag = 'copy_1'
    if File.directory? theFileDir
        names = Array.new
        text = "["
        count = 0
        nameIndex = 0
        Dir.foreach(theFileDir) do |file|
            if file !="." and file !=".." and file !=".DS_Store"
              count = count+1
              fileName = theTextUrl+ file
              text = text + "{\"url\":"+"\"#{fileName}\",\"detail\":"+"\"#{fileName}\",\"type\":\"0\"}"
              if(count == 10)
                text = text +"]"
                count = 0
                names[nameIndex] = text
                nameIndex = nameIndex +1
                text = "["
              else
                text = text +","
              end


            end
        end

        if(count != 0)
          text = text[0,text.length-1]
          text = text +"]"
          names[nameIndex] = text
          nameIndex = nameIndex +1

        end

        textIndex = 0
        names.each do |text|

          aFile = File.new("#{theTextDir}#{theTextTag}_#{names.size-textIndex-1}.txt","w")
          aFile.print text
          aFile.close

          textIndex = textIndex +1
        end


        aFile = File.new("#{theTextDir}#{theTextTag}.txt","w")
        aFile.print names.size.to_s
        aFile.close

        puts "已经解析到#{theTextDir}文件夹"

    else
        puts "File:#{File.basename(theFileDir)}, Size:#{File.size(theFileDir)}"
    end
end
traverse_dir()