require 'open-uri'
require 'pp'

open("locate.txt").each{|line|
  uri="https://api.foursquare.com/v2/venues/search?ll="+line.strip+"&oauth_token=STETE4NXMCWUZCQCAQB23XAFK00GLLY533X1EJSZLFDPJF5S&v=20120331"
  fp=open("d"+line.strip+".txt","w")
  open(uri){|f|
    f.each_line{|l| fp.puts l}
  }
  sleep 5
}

