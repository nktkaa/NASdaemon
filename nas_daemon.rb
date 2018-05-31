require 'net/ftp'
require 'ipscanner'
require 'socket'
require 'thread'

#Process.daemon
#$PROGRAM_NAME = "nasServer-daemon"

FTP_LOGIN = "test"
FTP_PASSWD = "test"

def logwrite(text)
	time = Time.now
	File.open("log.txt", "a"){|f| f.puts("#{time} - #{text}")}
end

def scanports(host, ports)
	ports.each do |tryport|
		begin
	    sock = Socket.new(:INET, :STREAM)
	    if sock.connect(Socket.sockaddr_in(tryport, host))
	    	$ipftp << host
	    	logwrite("#{host}: #{tryport}")
	    	puts "#{host}: #{tryport} open."
	    end
	    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ETIMEDOUT
	    end
	end
end

def scanip(ip,range1,range2,start_port,end_port)
	scanned_ip=IPScanner.scan(ip_base = ip, range = range1..range2, t = 5)
	#For range scan uncomment row below
	#allports=*(start_port..end_port)
	allports = Array.new
	allports << start_port
	pc_thread = []
	scanned_ip.each do |ip|
		pc_thread << Thread.new(ip) do
			scanports(ip, allports)
		end
	end
	pc_thread.each {|t| t.join }
end

=begin

def trymount()

end

def matchftpfiles(files)
	each.files do |file|
	
	end
end

def ftpconnect(ipftp)
	each.ip_array do |ip|
		Net::FTP.open(ip, FTP_LOGIN, FTP_PASSWD) do |ftp|
			files = ftp.chdir('~/')
			files = ftp.list('n*')
			#files = ftp.list
			puts "list out files in root directory:"
			puts files
			matchftpfiles(files)
			ftp.get("test.txt", locale = File.basename("/test.txt"))
		end


		ftp = Net::FTP.new(ip)
		if ftp.login(user="test", passwd = "test")
		files = ftp.chdir('~/Documents')
		files = ftp.list('n*')
		puts files
		getftpfiles(files)
		#ftp.getbinaryfile('nif.rb-0.91.gz', 'nif.gz', 1024)
		ftp.close


	end
end
=end

#scan ports every hour, folders every 5 min
#delete copies older than 2 days

loop do
	$ipftp = []
	scanip('192.168.1.', 1, 254, 80, 7000) #(host, range, first_port, last_port)
	puts "#{$ipftp}"
end
