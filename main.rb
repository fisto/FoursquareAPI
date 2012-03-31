require 'json'
require 'pp'

r=""
for i in 1..5
  data = JSON.parse(open("data"+i.to_s+".txt","r").gets)["response"]["venues"]
  data.to_a.each {|x|
    r << x["name"] + "\t"
    r << x["location"]["lat"].to_s + "\t"
    r << x["location"]["lng"].to_s + "\t"
    r << x["categories"][0]["name"]+"\t" if x["categories"]!=[]
    r << "\n"
  }
end

print r
