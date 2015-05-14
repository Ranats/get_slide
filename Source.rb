require 'open-uri'
require 'openssl'
require 'rubygems'
require 'nokogiri'
require 'fileutils'

@url = "https://s3-ap-northeast-1.amazonaws.com/i.schoo/images/class/slide/" #2329/44-1024.jpg"

print "講義ID : "
id = gets.chomp

# -- nokogiri --
charset = nil
html = open("https://schoo.jp/class/"+id.to_s, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してオブジェクトを生成
doc = Nokogiri::HTML.parse(html, nil, charset)

# タイトルを表示
#p doc.title
dir = doc.title.partition(" - 無料動画学習")[0]
FileUtils.mkdir(dir) unless FileTest.exist?(dir)
# -- nokogiri --

@url = @url + id.to_s + "/"

index = 1

while true do
  @path = @url + index.to_s + "-1024.jpg"
#  puts @path

  begin
    if open(URI.parse(@path), :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)
      # File.basename1
      # => 引数の'/'以降の文字列を返す
      # http://docs.ruby-lang.org/ja/search/class:File/query:File.basename/
      fileName = dir +"/"+ File.basename(@path)

      open(fileName,"wb") do |output|
        open(@path, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |data|
#         puts data.read  # 取得して1行ずつ読みだす
          output.write(data.read)
          puts fileName + " has created"
        end
      end
    end
  rescue => err
    if err == "403 Forbidden"
      puts "completed."
    else
      puts err
    end
    exit(1)
  end

  index = index + 1
end