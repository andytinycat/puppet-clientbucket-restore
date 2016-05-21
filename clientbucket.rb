#!/usr/bin/ruby

require 'rubygems'
require 'find'
require 'optparse'

options = {:target_path => nil, :clientbucket_path => nil}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: clientbucket.rb -t target_path -c clientbucket_path"
  
  opts.on("-t", "--target_path target_path", "path to file to restore") do |t|
    options[:target_path] = t
  end

  opts.on("-c", "--clientbucket_path clientbucket_path", "path to file to restore") do |c|
    options[:clientbucket_path] = c
  end
end

parser.parse!

if options[:target_path] == nil
  print 'Enter target path: '
  options[:target_path] = gets.chomp
end

if options[:clientbucket_path] == nil
  print 'Enter clientbucket path: '
  options[:clientbucket_path] = gets.chomp
end

target_path = options[:target_path]

clientbucket_path =  options[:clientbucket_path]

available_files = Array.new

begin
  Find.find(clientbucket_path) do |file_path|

    # Skip directories and "contents" files
    next if FileTest.directory?(file_path)
    next unless File.basename(file_path) =~ /paths$/

    # See if this file has a path the user was looking for
    path = File.open(file_path).first
    path.chomp!
    if target_path == path

      # Get the md5 string the file is referred to by
      file_path =~ /([^\/]+)\/paths$/;
      file_hash = $1

      # Get the "contents" file containing the old file's contents
      contents_path = File.dirname(file_path) + "/contents"

      # Get the creation time
      ctime = File.stat(file_path).ctime

      details = {:hash => file_hash, :ctime => ctime, :contents_path => contents_path}
      available_files.push(details)

    end

  end
rescue
  puts "Unable to open file path #{clientbucket_path}"
end
# See if we found any files for the user
if available_files.length == 0
  puts "No files with path #{target_path} exist in the clientbucket"
  exit 2
end


while true

  # Sort by creation time
  available_files.sort! { |x, y| x[:ctime] <=> y[:ctime] }
  n = 0
  available_files.each {|file|
    puts "[#{n}]: #{file[:hash]} #{file[:ctime]}"
    # Stash the option number for this file
    available_files[n][:option_number] = n
    n+=1
  }

  puts "------------------------"

  print "Pick a file, or x to exit: "
  number = gets.strip
  number.chomp!

  if number !~ /^(x|\d+)$/
    puts "Invalid input"
    next
  end

  if number == "x"
    puts "Exiting"
    exit 0
  end

  number = number.to_i

  if number > n
    puts "Invalid file number"
    next
  end

  while true

    print "Restore (r), view (v), diff (d), unified diff (u), or x to go back: "
    choice = gets.strip
    choice.chomp!

    if choice !~ /^[rvdux]$/
      puts "Invalid choice"
      next
    end

    case choice
    when "x"
      break
    when "v"
      system("vim #{available_files[number][:contents_path]}")
    when "d"
      system("diff #{available_files[number][:contents_path]} #{target_path}")
    when "u"
      system("diff -u #{available_files[number][:contents_path]} #{target_path}")
    when "r"
      print "Restore to (default is to restore to #{target_path}): "
      choice = gets.strip
      choice.chomp!

      # If not specified, use the default
      restore_path = target_path
      if choice != ''
        restore_path = choice
      end

      puts "Restoring to #{restore_path}"
      system("cp -p #{available_files[number][:contents_path]} #{restore_path}")
      puts "Done"
      exit 0

    end

  end

end
