require 'digest/md5'


def traverse_dir()
  theFileDir = '/Users/Shared/GitHub/QuanGe.github.io/images/jhds/copy/animal/'
    if File.directory? theFileDir
        Dir.foreach(theFileDir) do |file|
            if file !="." and file !=".." and file !=".DS_Store"
		            #File.rename('/Users/git/Desktop/jhds/copy/'+ file,'/Users/git/Desktop/jhds/copy/'+ "QuanGeLab"+file)
              oldName = theFileDir+ file
              newName = theFileDir+Digest::MD5.hexdigest(file)+".jpg"
              File.rename(oldName,newName)
            end
        end
    else
        puts "File:#{File.basename(theFileDir)}, Size:#{File.size(theFileDir)}"
    end
end
traverse_dir()