#!/usr/bin/env ruby
#Created by mhassan772
#Usage: ./hash_parser.rb filename.txt

str = File.read(ARGV[0])

my_hash = {}

str.each_line do |line|
    first, second = line.split(':')
    first.strip!
    second.strip!
    if(my_hash.has_key?(first)) then
	if my_hash[first].kind_of?(Array) then
            my_hash[first].insert(-1, second)
        else
            my_hash[first] = [my_hash[first], second]
        end
    else
        my_hash[first] = second
    end

end

puts my_hash
