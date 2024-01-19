require 'socket'

destination_address, destination_port, data_to_send = ARGV
destination_port = destination_port.to_i

begin
  socket = TCPSocket.new(destination_address, destination_port)

  socket.write(data_to_send)

  response = socket.read
  puts "Response: #{response}"

  socket.close
rescue => e
  puts "An error occurred: #{e.message}"
end