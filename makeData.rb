require 'open-uri'
require 'pp'
require 'json'

## 京都駅を中心のとき
range = 0.6 #検索範囲[lat and lng]
srange = 0.01 #検索間隔
startlat = 34.9862
startlng = 135.7578

#range = 0.2
#srange = 0.01
#startlat = 34.8903
#startlng = 135.8006
$counter = 0

#categorise table
$table = Hash::new
f = open("table.cvs")

while line = f.gets
	tmp = line.chomp.split(",")
	$table[tmp[0]] = tmp[1]
end

def chackTable(categorise)
	return $table[categorise]
end

##config
$f = open("config.txt","r");
$client_id = $f.gets.to_s.chomp
$client_secret = $f.gets.to_s.chomp

$f = open("locate.txt","w");

##距離演算（不要）
#def llLength(olat,olng,plat,plng)
#	p sprintf("%0.6f",(olat-plat).abs) + "," + sprintf("%0.6f",(olng-plng).abs);
#	return Math::sqrt((plat-olat)**2 + (plng-olng)**2)
#end

$day = Time.now
$day = $day
def vSearch(lat,lng,range)
	$counter = $counter + 1
	r = []

	#API制限回避
	while Time.now < $day
	end
	$day = $day + 18
	p $day

  uri = "https://api.foursquare.com/v2/venues/search?sw="+(lat-range).to_s+","+(lng-range).to_s+"&ne="+(lat+range).to_s+","+(lng+range).to_s+"&intent=browse&limit=500&client_id="+$client_id+"&client_secret="+$client_secret+"&v=20120620"
  p uri
  p fp = open("Data/d"+lat.to_s+","+lng.to_s+".txt","w")
	dtmp = ""
  open(uri){|f|
      f.each_line{|l| dtmp = dtmp + l}
  }
  fp.puts dtmp

  output = open("Output/o"+lat.to_s+","+lng.to_s+".txt","w");
  p "count is "+$counter.to_s

  data = JSON.parse(dtmp)["response"]["venues"];
  data.to_a.each {|x|
		cid = chackTable(x["categories"][0]["name"]) if x["categories"] != []
		cid = "0000000" if cid == nil
		r << [x["id"],cid,x["name"],x["location"]["lat"],x["location"]["lng"]]
		output.puts x["id"]+"\t"+cid+"\t"+x["name"]+"\t"+x["location"]["lat"].to_s+"\t"+x["location"]["lng"].to_s
  }
  $f.puts lat.to_s+","+lng.to_s
  return r
end

def venueSearch(lat,lng,range)
	p lat.to_s + "," + lng.to_s + "," + range.to_s
	if ((vSearch(lat,lng,range).length<50)||(range<0.0015))
		return true
	else
		newr = range/2;
		venueSearch(lat-newr, lng-newr, newr);
		venueSearch(lat-newr, lng     , newr);
		venueSearch(lat-newr, lng+newr, newr);
		venueSearch(lat     , lng-newr, newr);
		venueSearch(lat     , lng     , newr);
		venueSearch(lat     , lng+newr, newr);
		venueSearch(lat+newr, lng-newr, newr);
 		venueSearch(lat+newr, lng     , newr);
		venueSearch(lat+newr, lng+newr, newr);
	end
end

##main

p1 = startlat
p2 = startlng
step = srange*2

for r in 0..(range/srange)-1
	for i in 0..r
		venueSearch(p1,p2,srange)
		p1 = p1 + step
	end
	for i in 0..r
		venueSearch(p1,p2,srange)
		p2 = p2 + step
	end
	step = -step
end
for i in 0..range/srange-1
	venueSearch(p1,p2,srange)
	p1 = p1 + step
end

