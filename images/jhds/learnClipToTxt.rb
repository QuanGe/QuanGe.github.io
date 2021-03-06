require 'digest/md5'
require 'fastimage'

def traverse_dir()
  theFileDir = '/Users/Shared/GitHub/QuanGe.github.io/images/jhds/learn/'
  theTextDir = '/Users/Shared/GitHub/QuanGe.github.io/images/jhds/learn/'
  theTextTag = 'learn_'
    if File.directory? theFileDir



        #动物合集
        names0 = Array.new
        #植物合集
        names1 = Array.new
        #人物合集
        names2 = Array.new
        #其他合集
        names3 = Array.new


        lessonCount0 = 0
        lessonCount1 = 0
        lessonCount2 = 0
        lessonCount3 = 0

        text0 = "["
        text1 = "["
        text2 = "["
        text3 = "["

        nameIndex0 = 0
        nameIndex1 = 0
        nameIndex2 = 0
        nameIndex3 = 0

        lastFileType = ""
        lastLessonIndex = -1
        lastType = 0
        subsText = "["
        lastTheAllInfor = ""
        lastimgIndex = ""

        infoText = ""
        lastInfoText = ""
        theListImage = ""

        temNames = Array.new
        count = 0
        Dir.foreach(theFileDir) do |file|
          if file !="." and file !=".." and file !=".DS_Store"
            temNames[count] = file

            count = count+1
          end
        end
        count = temNames.size-1

        temNames2 = Array.new

        temNames.each do |file|
          temNames2[count] = file
          count = count-1
        end

        count = 0
        temNames2.each do |file|
            if file !="." and file !=".." and file !=".DS_Store"

              count = count+1
              fileName =  file.split('.')
              theAllInfor = fileName[0]
              md5str = ""
              type = ""
              lessonIndex = ""
              imgIndex = ""
              ortherInfo = ""
              args = theAllInfor.split('-')
              if(args.size == 4)
                md5str,type,lessonIndex,imgIndex = theAllInfor.split('-')
              else
                ortherInfo,md5str,type,lessonIndex,imgIndex = theAllInfor.split('-')
              end

              puts "#{theAllInfor}<<<<<<<<<<<"
              if(fileName[1] == "txt")
                lastInfoText = infoText
                infoText = IO.read("#{theTextDir}#{file}");
              end
              if(lastType == type && lastLessonIndex ==lessonIndex)
                subsText = subsText.insert(1,"\"#{theAllInfor}\",")
                #subsText = subsText+"\"#{theAllInfor}\","

              elsif ((lastLessonIndex !=lessonIndex && (lastLessonIndex != -1)) ||((lastType != type) && (lastLessonIndex != -1)))
                subsText = subsText[0,subsText.length-1]
                subsText = subsText +"]"

                puts "#{lastTheAllInfor}<<<<<<<<<<<"+"#{subsText}"

                size = FastImage.size(theFileDir + theListImage + ".jpg")

                if(lastType == "0")

                  text0 = text0 + "{\"url\":"+"\"#{theListImage}\",\"detail\":"+"#{subsText},\"size\":\"#{size[0]/2},#{size[1]/2}\",\"info\":\"#{lastInfoText}\",\"stdNum\":\"200\",\"type\":\"0\"}"
                  lessonCount0 = lessonCount0 + 1

                  if(lessonCount0 == 10)
                    text0 = text0 + "]"
                    names0[nameIndex0] = text0
                    nameIndex0 = nameIndex0+1
                    lessonCount0 = 0
                    text0 = "["
                  elsif
                    text0 = text0 + ","
                  end
                elsif(lastType == "1")
                  text1 = text1 + "{\"url\":"+"\"#{theListImage}\",\"detail\":"+"#{subsText},\"size\":\"#{size[0]/2},#{size[1]/2}\",\"info\":\"#{lastInfoText}\",\"stdNum\":\"200\",\"type\":\"0\"}"
                  lessonCount1 = lessonCount1 + 1
                  if(lessonCount1 == 10)
                    text1 = text0 + "]"
                    names1[nameIndex1] = text1
                    nameIndex1 = nameIndex1+1
                    lessonCount1 = 0
                    text1 = "["
                  elsif
                    text1 = text1 + ","
                  end
                elsif(lastType == "2")
                  text2 = text2 +  "{\"url\":"+"\"#{theListImage}\",\"detail\":"+"#{subsText},\"size\":\"#{size[0]/2},#{size[1]/2}\",\"info\":\"#{lastInfoText}\",\"stdNum\":\"200\",\"type\":\"0\"}"
                  lessonCount2 = lessonCount2 + 1
                  if(lessonCount2 == 10)
                    text2 = text2 + "]"
                    names2[nameIndex2] = text2
                    nameIndex2 = nameIndex2 + 1
                    lessonCount2 = 0
                    text2 = "["
                  elsif
                    text2 = text2 + ","
                  end
                elsif(lastType == "3")
                  text3 = text3 + "{\"url\":"+"\"#{theListImage}\",\"detail\":"+"#{subsText},\"size\":\"#{size[0]/2},#{size[1]/2}\",\"info\":\"#{lastInfoText}\",\"stdNum\":\"200\",\"type\":\"0\"}"
                  lessonCount3 = lessonCount3+1
                  if(lessonCount3 == 10)
                    text3 = text3 + "]"
                    names3[nameIndex3] = text3
                    nameIndex3 = nameIndex3+1
                    lessonCount3 = 0
                    text3 = "["
                  elsif
                  text3 = text3 + ","
                  end
                end

                subsText = "["
              end

              if(count == temNames2.size)
                subsText = subsText[0,subsText.length-1]
                subsText = subsText +"]"

                puts "#{lastTheAllInfor}<<<<<<<<<<<"+"#{subsText}"

                size = FastImage.size(theFileDir + theListImage + ".jpg")

                if(type == "0")

                  text0 = text0 + "{\"url\":"+"\"#{theListImage}\",\"detail\":"+"#{subsText},\"size\":\"#{size[0]/2},#{size[1]/2}\",\"info\":\"#{lastInfoText}\",\"stdNum\":\"200\",\"type\":\"0\"}"

                  text0 = text0 + "]"
                  names0[nameIndex0] = text0
                  nameIndex0 = nameIndex0+1

                elsif(type == "1")
                  text1 = text1 + "{\"url\":"+"\"#{theListImage}\",\"detail\":"+"#{subsText},\"size\":\"#{size[0]/2},#{size[1]/2}\",\"info\":\"#{lastInfoText}\",\"stdNum\":\"200\",\"type\":\"0\"}"

                  text1 = text0 + "]"
                  names1[nameIndex1] = text1
                  nameIndex1 = nameIndex1+1
                  lessonCount1 = 0

                elsif(type == "2")
                  text2 = text2 +  "{\"url\":"+"\"#{theListImage}\",\"detail\":"+"#{subsText},\"size\":\"#{size[0]/2},#{size[1]/2}\",\"info\":\"#{lastInfoText}\",\"stdNum\":\"200\",\"type\":\"0\"}"
                  text2 = text2 + "]"
                  names2[nameIndex2] = text2
                  nameIndex2 = nameIndex2 + 1
                  lessonCount2 = 0
                elsif(type == "3")
                  text3 = text3 + "{\"url\":"+"\"#{theListImage}\",\"detail\":"+"#{subsText},\"size\":\"#{size[0]/2},#{size[1]/2}\",\"info\":\"#{lastInfoText}\",\"stdNum\":\"200\",\"type\":\"0\"}"
                  text3 = text3 + "]"
                  names3[nameIndex3] = text3
                  nameIndex3 = nameIndex3+1
                  lessonCount3 = 0
                end
              end

              if(lastFileType == "txt")
                theListImage = theAllInfor
              end
              lastTheAllInfor = theAllInfor
              lastType = type
              lastLessonIndex = lessonIndex
              lastimgIndex = imgIndex
              lastFileType = fileName[1]


            end
        end

        if(lessonCount0 != 0)
          text0 = text0[0,text0.length-1]
          text0 = text0 + "]"

          names0[nameIndex0] = text0
          nameIndex0 = nameIndex0 + 1

        end

        if(lessonCount1 != 0)
          text1 = text1[0,text1.length-1]
          text1 = text1 + "]"

          names1[nameIndex1] = text1
          nameIndex1 = nameIndex1 + 1

        end
        if(lessonCount2 != 0)
          text2 = text2[0,text2.length-1]
          text2 = text2 + "]"

          names2[nameIndex2] = text2
          nameIndex2 = nameIndex2 + 1

        end
        if(lessonCount3 != 0)
          text3 = text3[0,text3.length-1]
          text3 = text3 + "]"

          names3[nameIndex3] = text3
          nameIndex3 = nameIndex3 + 1

        end


        textIndex0 = 0
        names0.each do |text|

          aFile = File.new("#{theTextDir}#{theTextTag}0_#{names0.size-textIndex0-1}.txt","w")
          aFile.print text
          aFile.close

          textIndex0 = textIndex0 + 1
        end

        textIndex1 = 0
        names1.each do |text|

          aFile = File.new("#{theTextDir}#{theTextTag}1_#{names1.size-textIndex1-1}.txt","w")
          aFile.print text
          aFile.close

          textIndex1 = textIndex1 + 1
        end

        textIndex2 = 0
        names2.each do |text|

          aFile = File.new("#{theTextDir}#{theTextTag}2_#{names2.size-textIndex2-1}.txt","w")
          aFile.print text
          aFile.close

          textIndex2 = textIndex2 + 1
        end

        textIndex3 = 0
        names3.each do |text|

          aFile = File.new("#{theTextDir}#{theTextTag}3_#{names3.size-textIndex3-1}.txt","w")
          aFile.print text
          aFile.close

          textIndex3 = textIndex3 +1
        end



        aFile = File.new("#{theTextDir}#{theTextTag}0.txt","w")
        aFile.print names0.size.to_s
        aFile.close

        aFile = File.new("#{theTextDir}#{theTextTag}1.txt","w")
        aFile.print names1.size.to_s
        aFile.close

        aFile = File.new("#{theTextDir}#{theTextTag}2.txt","w")
        aFile.print names2.size.to_s
        aFile.close

        aFile = File.new("#{theTextDir}#{theTextTag}3.txt","w")
        aFile.print names3.size.to_s
        aFile.close

        puts "已经解析到#{theTextDir}文件夹"

    else
        puts "File:#{File.basename(theFileDir)}, Size:#{File.size(theFileDir)}"
    end
end
traverse_dir()