#encoding: utf-8

require 'digest/md5'
require "open-uri"
require 'net/http'
require 'json'

$since_id = ""
$index = 0
$theTextDir = '../data/'
$itemContents = Array.new
$frontExistNames = Array.new

def frontExist
  Dir.foreach($theTextDir) do |file|
    if file !="." and file !=".." and file !=".DS_Store"
      $frontExistNames[0,0] = file.split('_').last.split('.').first
    end
  end
end
frontExist()

$index = $index + $frontExistNames.size
#puts $frontExistNames.to_s
def traverse_dir()

  if File.directory? $theTextDir
    urlstr = ""

    urlstr = "http://m.weibo.cn/page/json?containerid=1005055663851873_-_WEIBO_SECOND_PROFILE_WEIBO&page=1"

    urlstr = URI.escape(urlstr)
    url = URI.parse(urlstr)
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url.request_uri)
    request["Content-Type"] = "application/json"
    request["Cookie"] = ""
    resp = http.start {|http|
      http.request(request)
    }

    if(resp.code.to_s == "200")
      json_temp_str = JSON.parse(resp.body)

      card_group = json_temp_str['cards'][0]['card_group']
      card_group.each do |weiboItem|
        if !($frontExistNames.include?weiboItem['mblog']['idstr'] ) && (weiboItem['mblog']['text'].gsub(/<\/?.*?>/, "").include?"#简画大师#")
          $itemContents[0,0] = "{\"idstr\":\"#{weiboItem['mblog']['idstr']}\",\"text\":\"#{weiboItem['mblog']['text'].gsub(/<\/?.*?>/, "")}\"
              ,\"pic_ids\":#{weiboItem['mblog']['pic_ids'].to_s}
              ,\"original_pic\":\"#{weiboItem['mblog']['original_pic']}\",\"userIcon\":\"#{weiboItem['mblog']['user']['profile_image_url']}\"
              ,\"nickName\":\"#{weiboItem['mblog']['user']['screen_name']}\",\"userId\":\"#{weiboItem['mblog']['user']['id'].to_s}\"
              ,\"created_timestamp\":\"#{weiboItem['mblog']['created_timestamp'].to_s}\"}"
        end
      end



      writeDataToDir()


    else
      puts "接口报错了 #{resp.code}: #{resp.body}"
    end



  end

end

def writeDataToDir
  if($itemContents.size == 0)
    puts "看上面，没有获取到数据"
  end
  $itemContents.each do |item|
    json_temp_str = JSON.parse(item)
    newFileName = ""
    if($index<10)
      newFileName = $theTextDir+"z0000"+$index.to_s+"_"+json_temp_str['idstr']+".txt"
    elsif($index>9&&$index<100)
      newFileName = $theTextDir+"z000"+$index.to_s+"_"+json_temp_str['idstr']+".txt"
    elsif($index>99&&$index<1000)
      newFileName = $theTextDir+"z00"+$index.to_s+"_"+json_temp_str['idstr']+".txt"
    elsif($index>999&&$index<10000)
      newFileName = $theTextDir+"z0"+$index.to_s+"_"+json_temp_str['idstr']+".txt"
    end
    aFile = File.new(newFileName,"w")
    aFile.print item
    aFile.close
    $index = $index+1
  end
end
traverse_dir()


