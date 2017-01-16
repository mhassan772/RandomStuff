
#!/usr/bin/ruby

#created by mhassan772
#This script will help you to decide what number you can add, sub or multiply to get
#the encoded number you want

############################################
########## Modify This #####################
shell = "\x33"                             #
upper_limit = 80                           #
down_limit = 40                            #
############################################
############################################

result = [];

#addtion
b = 0
0.upto(255) do |n|  
  shell.split("").each do |i|
    converted = ((i.ord + n) % 256)
    if  converted > upper_limit or converted < down_limit
      b = 1
      break
    end
  end
  if b == 0 
    result << n
  end
  b = 0
end

puts "you may add one of the following numbers to your shell:"
p result
