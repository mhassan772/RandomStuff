#Created by Mohamed Hassan | @mhassan772
#!/usr/bin/env ruby
require 'net/dns'																				#To install this gem: gem install net-dns
require 'ipaddr'

#The usage function
def usage
  puts "USAGE:"
  puts "#{__FILE__} [IP_ADDRESS] [FIRST DNS] [SECOND DNS]"
  puts "examples:"
  puts "#{__FILE__} 156.36.56.3"
  puts "#this will find the PTR for 156.36.56.3 in the dns servers 8.8.8.8 and 4.4.4.4"
  puts "#{__FILE__} 10.10.10.10/24 172.3.5.2"
  puts "#this will find the PTR for 10.10.10.10/24 in the dns server 172.3.5.2"
end

#If there is no IP address
if not ARGV[0]
  usage
  exit
end



resolver = Net::DNS::Resolver.new
ip_address = IPAddr.new(ARGV[0]).to_range

#Sitting the Name Server
if ARGV[1] and ARGV[2] then
  resolver.nameservers = [ARGV[1] , ARGV[2]]
elsif ARGV[1] then
  resolver.nameservers = [ARGV[1]]
else
resolver.nameservers = ["8.8.4.4" , "8.8.8.8"]
end

my_hash = {}
i = 0

threads = ip_address.map do |ip|											#Taking the input IP by IP..
  Thread.new do
    i++
    if i % 15 == 0
      sleep(rand(0.5))																#The sleep here not to overwhelm the network
    end
    query = resolver.query(ip.to_s, Net::DNS::PTR)		#The query
    query.to_s.each_line do |line|
      if line.include? "PTR" and not line.include? ";;"		
        name = line.split(" ")[4]											#Parse the query to get the address only
        if my_hash[ip.to_s]
          my_hash[ip.to_s] << name
        else
          my_hash[ip.to_s] = [name]
        end
      end
    end
  end
end
threads.each {|t| t.join}

puts my_hash
