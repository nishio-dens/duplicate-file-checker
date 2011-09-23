require 'find'
require 'pathname'
require 'digest/md5'

def create_index(checkDirPath)
  dir = Pathname.new(checkDirPath)
  index = {}
  if dir.directory?
    Find.find(dir.to_s) do |path|
      f = Pathname.new(path).realpath
      if f.file?
        md5 = Digest::MD5.file(f.to_s).hexdigest
        list = index[md5] || []
        list << f.to_s
        index[md5] = list
      end
    end
  end
  index
end

if ARGV.length < 1
  puts "usage: #{__FILE__} CheckDirectoryPath"
  exit 1
end

path = ARGV[0]
create_index(path).each_pair do |k,v|
  if v.length >= 2
    v.each{|d| puts d}
    puts "---"
  end
end
