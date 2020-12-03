#!/usr/bin/ruby
# frozen_string_literal: true

require 'net/dav'
require 'tempfile'

class File
  def each_chunk(chunk_size = 2**20)
    yield read(chunk_size) until eof?
  end
end

url = 'http://127.0.0.1:8080/remote.php/dav/uploads/admin/'
user = 'admin'
pass = 'admin'
folder = (0..16).to_a.map { |_a| rand(16).to_s(16) }.join
file_name = 'file.mp4'
dav = Net::DAV.new(url, curl: false)
dav.verify_server = false
dav.credentials(user, pass)
dav.mkdir(folder)
File.open("./#{file_name}", 'rb') do |stream|
  number_chank = 1
  stream.each_chunk do |chunk|
    tmp = Tempfile.new(number_chank.to_s)
    tmp.puts chunk
    dav.put("./#{folder}/#{number_chank}", tmp.path, chunk.size)
    tmp.close
    number_chank += 1
  end
end
dav.move("#{folder}/.file", "http://127.0.0.1:8080/remote.php/dav/files/admin/#{file_name}")
# dav.put("./#{folder}/#{file_name}", stream, File.size(local_file))
# sleep 15
# dav.delete(folder)
# curl -X MOVE -u admin:admin --header 'Destination:http://127.0.0.1:8080/remote.php/dav/files/admin/file.zip' http://127.0.0.1:8080/remote.php/dav/uploads/admin/681bb5c5980ca7a66/.file

