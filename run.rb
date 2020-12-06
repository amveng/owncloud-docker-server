#!/usr/bin/ruby
# frozen_string_literal: true

require 'net/dav'
require 'tempfile'
require 'pry'

class File
  def each_chunk(chunk_size = 2**20)
    yield read(chunk_size) until eof?
  end
end

class String
  def eval
    Kernel.eval self
  end
end

url = 'http://127.0.0.1:8080/remote.php/dav/uploads/admin/'
user = 'admin'
pass = 'admin'
folder = (0..16).to_a.map { rand(16).to_s(16) }.join
file_name = 'file.mp4'
file_local_path = File.expand_path(file_name)
dav = Net::DAV.new(url, curl: false)
dav.verify_server = false
dav.credentials(user, pass)

# dav.mkdir(folder)
# File.open(file_local_path, 'rb') do |stream|
#   number_chank = 1
#   stream.each_chunk do |chunk|
#     tmp = Tempfile.new(number_chank.to_s)
#     tmp.puts chunk
#     dav.put("./#{folder}/#{number_chank}", tmp.path, chunk.size)
#     tmp.close
#     number_chank += 1
#   end
# end
# dav.move("#{folder}/.file", "http://127.0.0.1:8080/remote.php/dav/files/admin/#{file_name}")
# dav.find('.', recursive: true, suppress_errors: true, filename: /\.*/) do |item|
#   # dav.delete(item.url.to_s)
#   puts 'Checking: ' + item.content.to_s
# end
# binding pry

# dav.put("./#{folder}/#{file_name}", stream, File.size(local_file))
# sleep 15
# dav.delete(folder)
# curl -X MOVE -u admin:admin --header 'Destination:http://127.0.0.1:8080/remote.php/dav/files/admin/file.zip' http://127.0.0.1:8080/remote.php/dav/uploads/admin/681bb5c5980ca7a66/.file

# a = dav.propfind("http://127.0.0.1:8080/remote.php/dav/files/admin/#{file_name}", '<?xtml version="1.0" encoding="utf-8"?><DAV:propfind xmlns:DAV="DAV:"><checksum/></DAV:propfind>')
# a = dav.proppatch("http://127.0.0.1:8080/remote.php/dav/files/admin/#{file_name}", "<d:resourcetype>static-file</d:resourcetype>")
# p a
# binding pry

# connect = Mysql2::Client.new(:host => "127.0.0.1", :username => "owncloud", :password => "owncloud", :database => "owncloud")
# result = connect.query("SELECT path, checksum FROM oc_filecache WHERE path='files/#{file_name}';")
# result.each {  |x| puts x }
# curl -X PROPFIND -u admin:admin --header 'Destination:http://127.0.0.1:8080/remote.php/dav/files/admin/file.zip' http://127.0.0.1:8080/remote.php/dav/uploads/admin/681bb5c5980ca7a66/.file
# curl --silent -u admin:admin 'http://localhost:8080/ocs/v1.php/cloud/capabilities?format=json' | json_pp
# curl -X PROPFIND -H "Depth: 1" -u admin:admin "http://localhost:8080/remote.php/dav/files/admin/1.txt" | xml_pp
# curl -u admin:admin 'http://localhost:8080/remote.php/dav/' -X SEARCH -u admin:admin -H "content-Type: text/xml" --data '<?xml version="1.0" encoding="UTF-8"?>'
# curl -I -u admin:admin "http://localhost:8080/remote.php/dav/files/admin/file.mp4"

# uri = URI('http://localhost:8080/remote.php/dav/files/admin/1.txt')

# req = Net::HTTP::Head.new(uri)
# req.basic_auth 'admin', 'admin'

# res = Net::HTTP.start(uri.hostname, uri.port) {|http|
#   http.request(req)
# }
# puts res.header
# binding pry

# c = Curl::Easy.new("http://localhost:8080/remote.php/dav/files/admin/1.avi")
# c.http_auth_types = :basic
# c.username = 'admin'
# c.password = 'admin'
# c.perform
# p c.head
# p c.head.include?('SHA1:01838d0aa7e32383118d9e87e682237d6764aec0')
# # binding pry

head = "`curl --silent -I -u admin:admin http://localhost:8080/remote.php/dav/files/admin/#{file_name}`".eval
p head.include?('SHA1:01838d0aa7e32383118d9e87e682237d6764aec0')
