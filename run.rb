#!/usr/bin/ruby
# frozen_string_literal: true

require 'net/dav'
require 'tempfile'

class File
  def each_chunk(chunk_size=2**20)
    yield self.read(chunk_size) until self.eof?
  end
end

url = 'http://127.0.0.1:8080/remote.php/dav/files/admin/'
user = 'admin'
pass = 'admin'
folder = (0..16).to_a.map { |_a| rand(16).to_s(16) }.join
local_file = './001.mp4'
file_name = 'part'
dav = Net::DAV.new(url, curl: false)
dav.verify_server = false
dav.credentials(user, pass)
dav.mkdir(folder)
# dav.find('.', recursive: true, suppress_errors: true, filename: /\.*/) do |item|
#   puts 'Checking: ' + item.url.to_s
# end
# chunk_size = 2**20
# number_chank = 1
# File.open(local_file).each(nil, chunk_size) do |chunk|
#   dav.put("./#{folder}/#{number_chank}#{file_name}", chunk, chunk.size)
#   sleep 1
#   number_chank += 1
# end


File.open(local_file, 'rb') do |stream|
  number_chank = 1
  stream.each_chunk do |chunk|
    tmp = Tempfile.new("#{number_chank}")
    tmp.puts chunk
    dav.put("./#{folder}/#{number_chank}#{file_name}", tmp.path, chunk.size)
    tmp.close
    number_chank += 1
  end
end
# dav.put("./#{folder}/#{file_name}", stream, File.size(local_file))
# sleep 15
# dav.delete(folder)
