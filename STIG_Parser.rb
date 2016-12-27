#!/usr/bin/ruby

#created by mhassan772
#This parser will get you the title and how to check the finding. You may uncomment the fix part to get the fix too.

#file_location = ARGV[0]

require 'nokogiri'

f = File.read('/path/to/file.xml')
doc = Nokogiri::XML(f)

groups_xml = 
doc.css('Group').each do |node|
	title = "#{node.css('Rule').css('title')}"
	title.slice! "<title>"
	title.slice! "</title>"
	puts "The title is: "
	puts title

	check = "#{node.css('Rule').css('check').css('check-content')}"
	check.slice! "</check-content>"
	check.slice! ("<check-content>")
	puts "How to check: "
	puts check

	#fix = "#{node.css('Rule').css('fixtext')}"
	#fix.slice! "</fixtext>"
	#fix.slice! (/<fixtext fixref=\"F-.*_fix\">/)
	#puts "The fix is: "
	#puts fix


	puts "######################################"
	puts "######################################"
end
