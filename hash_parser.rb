#!/usr/bin/env ruby
#Created by mhassan772
#Usage: ./hash_parser.rb filename.txt
###############################################################
#Sample input:
#description : AAAA
#info : BBBB
#info : CCCC
#info : DDDD
#solution : EEEE
#solution : FFFF
#reference : GGGG
#reference : HHHH
#see_also : IIII
#see_also : JJJJ
#http://hi.com : OOOO
#PPPP : http://hi.com
##############################################################
#sample output:
#{"description"=>["AAAA"], "info"=>["BBBB", "CCCC", "DDDD"], 
#"solution"=>["EEEE", "FFFF"], "reference"=>["GGGG", "HHHH"], 
#"see_also"=>["IIII", "JJJJ"], "http://hi.com"=>["OOOO"], "PPPP"=>["http://hi.com"]}
##############################################################
#The only condetion on the input for the code to work porbarly is there has to be at least 
#single space between the ":" and the second value
#
#
#

str = File.read(ARGV[0])

my_hash = {}

str.each_line do |line|
  first, second = line.split(': ', 2)
  first.strip!
  second.strip!
 
  if my_hash[first]
    my_hash[first] << second
  else
    my_hash[first] = [second]
  end
end

puts my_hash
