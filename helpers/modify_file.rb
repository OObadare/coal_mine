file_path, content = ARGV

begin
  File.open(file_path, "a") do |file|
    file.puts content
  end
  puts "File modified: #{file_path}"

rescue IOError => e
  puts "An IOError occurred: #{e.message}"
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end