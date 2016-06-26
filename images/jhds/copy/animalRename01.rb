require 'digest/md5'


def traverse_dir()
  theFileDir = '/Users/Shared/GitHub/QuanGe.github.io/images/jhds/copy/plant/'
    if File.directory? theFileDir
        count = 0
        Dir.foreach(theFileDir) do |file|
            if file !="." and file !=".." and file !=".DS_Store" and file.length != 36

		            #File.rename('/Users/git/Desktop/jhds/copy/'+ file,'/Users/git/Desktop/jhds/copy/'+ "QuanGeLab"+file)
              oldName = theFileDir+ file
              newName = ""
              if(count<10)
                newName = theFileDir+"%0000"+count.to_s+"-"+Digest::MD5.hexdigest(file)+".jpg"
              elsif(count>9&&count<100)
                newName = theFileDir+"%000"+count.to_s+"-"+Digest::MD5.hexdigest(file)+".jpg"
              elsif(count>99&&count<1000)
                newName = theFileDir+"%00"+count.to_s+"-"+Digest::MD5.hexdigest(file)+".jpg"
              elsif(count>999&&count<10000)
                newName = theFileDir+"%0"+count.to_s+"-"+Digest::MD5.hexdigest(file)+".jpg"
              end
              File.rename(oldName,newName)
              count = count+1
            end
        end
    else
        puts "File:#{File.basename(theFileDir)}, Size:#{File.size(theFileDir)}"
    end
end
traverse_dir()