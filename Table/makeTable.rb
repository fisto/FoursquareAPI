require 'json'
require 'pp'

r=""
lang="en"
num1=00
num2=000
num3=00

data = JSON.parse(open("categories_"+lang+".txt","r").gets)["response"]["categories"]

data.to_a.each {|x|
	num1 = num1 + 1;
	print x["name"]+","+sprintf("%02d",num1)+sprintf("%03d",num2)+sprintf("%02d",num3)+"\n"
	num2 = 000;
	x["categories"].to_a.each{|y|
		num2 = num2 + 1;
		print "" + y["name"]+","+sprintf("%02d",num1)+sprintf("%03d",num2)+sprintf("%02d",num3)+"\n"
		if [] != y["categories"]
			num3 = 00;
			y["categories"].to_a.each{|z|
				num3 = num3 + 1;
				print ""+z["name"]+","+sprintf("%02d",num1)+sprintf("%03d",num2)+sprintf("%02d",num3)+"\n"
			}
		end
	num3 = 00;
	}
	num2=000;
	#break;
}

#    r << x["name"] + "\t"
#    r << x["location"]["lat"].to_s + "\t"
#    r << x["location"]["lng"].to_s + "\t"
#    r << x["categories"][0]["name"]+"\t" if x["categories"]!=[]
#    r << "\n"
#  }

#print r
