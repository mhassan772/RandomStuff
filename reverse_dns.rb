#!/usr/bin/env ruby
#Created by Mohamed Hassan | @mhassan772
require 'net/dns'

def usage()
	puts "USAGE:"
	puts "#{__FILE__} [IP_ADDRESS] [FIRST DNS] [SECOND DNS]"
	puts "examples:"
	puts "#{__FILE__} 156.36.56.3"
	puts "#this will find the PTR for 156.36.56.3 in the dns servers 8.8.8.8 and 4.4.4.4"
	puts "#{__FILE__} 10.10.10.10 172.3.5.2"
	puts "#this will find the PTR for 10.10.10.10 in the dns server 172.3.5.2"


end

if not ARGV[0]
	usage()
	exit
end
#"98.56.36.2"
resolver = Net::DNS::Resolver.new
ip_address = ARGV[0]

resolver.nameservers = ["8.8.4.4" , "8.8.8.8"]
query = resolver.query(ip_address, Net::DNS::PTR)

my_hash = {}

query.to_s.each_line do |line|
	if line.include? "PTR" and not line.include? ";;"
		name = line.split(" ")[4]
		if my_hash[ip_address]
    	my_hash[ip_address] << name
  	else
    	my_hash[ip_address] = [name]
  	end
	end
end

puts my_hash
