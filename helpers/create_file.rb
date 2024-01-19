file_path = ARGV[0]
content = ARGV[1] || "This is some default content"

begin
  File.write(file_path, content)
  puts "File created successfully at #{file_path}"
rescue IOError => e
  puts "An IOError occurred: #{e.message}"
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end