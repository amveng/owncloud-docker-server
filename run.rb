#!/usr/bin/ruby
# frozen_string_literal: true

require 'net/dav'
require 'tempfile'
require 'digest'

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

chunk_size = (2**20) * 10
user = 'admin'
pass = 'admin'
folder = (0..16).to_a.map { rand(16).to_s(16) }.join
upload_error = false
file_name = 'file.mp4'
file_local_path = File.expand_path(file_name)
server_file_path = "http://127.0.0.1:8080/remote.php/dav/files/admin/#{file_name}"
dav = Net::DAV.new('http://127.0.0.1:8080/remote.php/dav/uploads/admin/', curl: false)
dav.verify_server = false
dav.credentials(user, pass)
if dav.exists?(server_file_path)
  puts 'The file is already on the server !'
  exit
end

dav.mkdir(folder)
File.open(file_local_path, 'rb') do |stream|
  number_chank = 1
  stream.each_chunk(chunk_size) do |chunk|
    tmp = Tempfile.new(number_chank.to_s)
    tmp.puts chunk
    upload_ready = false
    upload_retry = 0
    until upload_ready
      begin
        dav.put("./#{folder}/#{number_chank}", tmp.path, chunk.size)
        upload_ready = true
      rescue StandardError
        upload_retry += 1
        puts "Upload eror. Retrying...#{upload_retry}"
        sleep upload_retry
        if upload_retry >= 10
          upload_error = true
          break
        end
      end
    end
    tmp.close
    number_chank += 1
  end
end
dav.move("#{folder}/.file", server_file_path)
head = "`curl --silent -I -u admin:admin #{server_file_path}`".eval
checksum = Digest::SHA1.hexdigest(File.read(file_local_path))
if !head.include?(checksum) || upload_error
  dav.find('.', recursive: true, suppress_errors: true, filename: /\.*/) do |item|
    dav.delete(item.url.to_s)
  end
  dav.delete(server_file_path)
  puts 'Upload failed !!!'
else
  puts 'Upload complete'
end
