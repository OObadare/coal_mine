#!/usr/bin/env ruby

require 'optparse'
require 'etc'
require_relative 'logger'


class CoalMine
    attr_accessor :running, :user, :choice_data, :logger
    def initialize
        @running = true
        @user = Etc.getlogin
        @choice_data = clear_choice_data
        @logger = Logger.new
    end

    def start 
        while running
            puts "Hello. #{user}!"
            puts "Please enter the action you want to perform:"
            puts "1. Start a process"
            puts "2. Create a file"
            puts "3. Modify a file"
            puts "4. Delete a file"
            puts "5. Transmit data"
            puts "6. Exit"
            handle_choice(gets.chomp)
        end
    end

    def handle_choice(choice)
        case choice
        when "1"
          start_process
        when "2"
          create_file
        when "3"
          modify_file
        when "4"
          delete_file
        when "5"
          transmit_data
        when "6"
          puts "Thank you for using CoalMine!"
          @running = false
        else
          puts "Invalid choice, please try again."
        end
    end

    def start_process()
        puts "enter the process you want to start, followed by any optional command line args!"
        # how do I sanitize the process lol
        begin
            choice_data["process_command_line"] = gets.chomp
            choice_data["process_id"] = Process.spawn(choice_data["process_command_line"])
            choice_data["process_name"] = `ps -p #{choice_data["process_id"]} -o comm=`.strip
            choice_data["timestamp"] = Time.now
        rescue => e
            puts "error #{e}, please try another or check the logs."
        end
        logger.add_log_entry(choice_data)
        clear_choice_data

    end

    def create_file
        puts "Enter the path where you want to create your file:"
        choice_data["file_activity"] = "create_file"
        choice_data["file_path"] = gets.chomp
      
        content = "this is some content"
      
        cmd = "ruby helpers/create_file.rb '#{choice_data["file_path"]}' '#{content}'"
        choice_data["process_command_line"] = cmd
      
        choice_data["timestamp"] = Time.now
        choice_data["process_id"] = Process.spawn(choice_data["process_command_line"])
        choice_data["process_name"] = `ps -p #{choice_data["process_id"]} -o comm=`.strip
        Process.wait(choice_data["process_id"])
        logger.add_log_entry(choice_data)
        clear_choice_data
      end
      
    
    def modify_file
        puts "Enter the path of the file you want to modify, preferably a txt:"
        choice_data["file_activity"] = "modify_file"
        choice_data["file_path"] = gets.chomp

        puts "Enter the content to add to the file:"
        content_to_append = gets.chomp

        cmd = "ruby helpers/modify_file.rb '#{choice_data["file_path"]}' '#{content_to_append}'"
        choice_data["process_command_line"] = cmd

        choice_data["timestamp"] = Time.now
        choice_data["process_id"] = Process.spawn(choice_data["process_command_line"])
        choice_data["process_name"] = `ps -p #{choice_data["process_id"]} -o comm=`.strip

        Process.wait(choice_data["process_id"])
        logger.add_log_entry(choice_data)
        clear_choice_data
    end
    
    def delete_file
        puts "Enter the path of the file you want to delete:"
        choice_data["file_activity"] = "delete_file"
        choice_data["file_path"] = gets.chomp

        cmd = "ruby helpers/delete_file.rb '#{choice_data["file_path"]}'"
        choice_data["process_command_line"] = cmd

        choice_data["timestamp"] = Time.now
        choice_data["process_id"] = Process.spawn(choice_data["process_command_line"])
        choice_data["process_name"] = `ps -p #{choice_data["process_id"]} -o comm=`.strip

        Process.wait(choice_data["process_id"])
        logger.add_log_entry(choice_data)
        clear_choice_data
    end
    
    def transmit_data
        puts "Enter the destination address:"
        choice_data["destination_address"] = gets.chomp

        puts "Enter the destination port:"
        choice_data["destination_port"] = gets.chomp

        puts "Enter the data to send:"
        data_to_send = gets.chomp
        choice_data["data_size"] = data_to_send.bytesize
        # I know that the project spec implies that it should be programmable but like...
        choice_data["protocol"] = "TCP"

        cmd = "ruby helpers/send_data.rb '#{choice_data["destination_address"]}' '#{choice_data["destination_port"]}' '#{data_to_send}'"
        
        choice_data["file_activity"] = "transmit_data"
        choice_data["timestamp"] = Time.now
        choice_data["process_command_line"] = cmd
        choice_data["process_id"] = Process.spawn(cmd)
        choice_data["process_name"] = `ps -p #{choice_data["process_id"]} -o comm=`.strip

        logger.add_log_entry(choice_data)
        clear_choice_data
    end

    def clear_choice_data
        choice_data = {
            "username" => user,
            "timestamp" => nil,
            "process_id" => nil,
            "process_name" => nil,
            "process_command_line" => nil
        }
    end
end

do_stuff = CoalMine.new
do_stuff.start

