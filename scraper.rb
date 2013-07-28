require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'digest/md5'

base_url  = "http://elcorteingles.glamour.es/street-fashion-show/ranking/"
time =Time.now

data = Array.new

formatted_time = time.strftime "%Y-%m-%d %H:%M"

for page in 1..20
  url = base_url + page.to_s
  # Fetch page
  doc = Nokogiri::HTML(open(url))
  doc.css(".list li").each do |item|
    # Process participant
    participant = Hash.new
    participant = {
      "name" => item.at_css("a").text,
      # Hashes are cool for filenames, no ugly spaces or symbols
      "hash" => Digest::MD5.hexdigest(item.at_css("a").text),
      "votes" => item.at_css(".votes").text
    }
    data << participant
  end
end

# Save participants data
output_base_path = "data/participant_data/"

data.each  do |p|
    ## Tabs sepparated
    output_file = output_base_path + p["hash"] + ".txt"
    File.open(output_file, "a") do |f|
      f.write formatted_time + "\t" + p["votes"] + "\n"
    end
end

# Save all data
output_base_path = "data/time_data/"
underscored_time = time.strftime "%Y-%m-%d_%H%M"
output_file = output_base_path + "/" + underscored_time + ".txt"

File.open(output_file, "w") do |f|
  f.write formatted_time+"\n"
  data.each do |p|
   f.write  p["hash"] + "\t" + p["votes"] + "\t" + p["name"] + "\n"
  end
end
