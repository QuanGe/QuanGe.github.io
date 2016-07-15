require 'digest/md5'

$theFileDir = '/Users/Shared/GitHub/QuanGe.github.io/images/jhds/weibo/data/'
$outFileDir = '/Users/Shared/GitHub/QuanGe.github.io/images/jhds/weibo/'
def traverse_dir()

    if File.directory? $theFileDir
        names = Array.new
        text = "["

        nameIndex = 0
        items = Array.new

        Dir.foreach($theFileDir) do |file|
          if file !="." and file !=".." and file !=".DS_Store"
            filePath =  $theFileDir + file
            items[0,0] =  IO.read(filePath);
          end
        end

        count = 0
        items.each do |item|
              count = count+1
              text = text + item
              if(count == 12)
                text = text +"]"
                count = 0
                names[nameIndex] = text
                nameIndex = nameIndex +1
                text = "["
              else
                text = text +","
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

          aFile = File.new("#{$outFileDir}weibo_#{names.size-textIndex-1}.txt","w")
          aFile.print text
          aFile.close

          textIndex = textIndex +1
        end


        aFile = File.new("#{$outFileDir}weibo_num.txt","w")
        aFile.print names.size.to_s
        aFile.close

        puts "已经解析到#{$outFileDir}文件夹"

    else
        puts "File:#{File.basename($theFileDir)}, Size:#{File.size($theFileDir)}"
    end
end
traverse_dir()