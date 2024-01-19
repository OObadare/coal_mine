
file_path = ARGV[0]

begin
  if File.exist?(file_path)
    File.delete(file_path)
    puts "File deleted: #{file_path}"
  else
    puts "File not found: #{file_path}"
  end

rescue StandardError => e
  puts "An error occurred: #{e.message}"
end