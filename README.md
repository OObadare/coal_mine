### COALMINE
To use this app, you must first `chmod +x app.rb` to make it runnable
Then simply `./app.rb`


You should also ensure that ruby is installed on the system that you are trying to run this on.

Originally I used process.spawn to create/edit the files directly in each of the associated methods, but honestly I got a little nervous about the file modification. 
It feels a little silly, since the "start a process" step already lets you mess around with your computer in all sorts of ways (and since this program needs executable permissions anyways) but I ended up using the ruby File methods, which necessitated breaking them out into their own files so that I could execute them and keep track of the processes. 
Really, it was a lateral move as far as I'm concerned, especially because I don't think it actually _reduced_ complexity any.

As for data sending, we use the ruby TCP library to create a TCP/IP client and connect to a server. To test this I spun up a simple ruby server.


## 1. Start a process

Takes a command line argument. One example would be `"open 'http://www.example.com'"` on mac OS, or `"xdg-open 'http://www.google.com'"` on ubuntu. Actually, doing those may require some finnicky configuring of permissions that would have to be done on the command line, but I was perfectly happy to try it with `ls` or `echo "Hello, World!"`

## 2. Create a file

Takes a file location. You'd need to add the file ending yourself - I tested that it works with a .txt and a .csv, but presumably there are other types of files that would cause more issues.

## 3. Modify a file

Also takes a file location (with a file actually present). Any file modifications are also entered in the command line, which could probably present a problem with certain filetypes.

## 4. Delete a file

A nice and simple one! This one just deletes a file, straight up and down.

## 5. Transmit data

Transmits entered data to the specified source and port, provided that you didn't want to send anything more complex than a string. 