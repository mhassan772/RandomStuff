#!/usr/bin/env ruby

#Some code is taken from rubyfu.net by @KINGSABRI
#you need net-ping gem, you can add it by: gem install net-ping
require 'net/ping'
require 'ipaddr'

#The usage function
def usage
  puts "USAGE:"
  puts "#{__FILE__} [IP_ADDRESS_RANGE] [Repeating=2]"
  puts "examples:"
  puts "#{__FILE__} 156.36.56.3"
  puts "#this will try to ping the IP 156.36.56.3 at most 2 times"
  puts "#{__FILE__} 10.10.10.10/24 5"
  puts "#this will try to ping the each IP address in the IP range 10.10.10.10/24 at most 5 times"
end

#If there is no IP address
if not ARGV[0]
  usage
  exit
end

#Creating IP address object
ip_address = IPAddr.new(ARGV[0]).to_range

#Setting the repeat variable.

repeat = 2
repeat = ARGV[1].to_i if ARGV[1] 
i = 0


puts 'starting to ping..'


threads = ip_address.map do |ip|               #Taking the input IP by IP..
  Thread.new do
    i++
    if i % 15 == 0
      sleep(rand(0.5))                         #The sleep here not to overwhelm the network
    end
    @icmp = Net::Ping::ICMP.new(ip.to_s)    #The query
    (1..repeat).each do
      if @icmp.ping
        puts "#{ip.to_s} is a live"
        break
      end
    end
  end
end
threads.each {|t| t.join}

