# TODO: Write documentation for `HttpCryptoPrice`
require "http/client"
require "uri/params"
require "uri"
require "json"
require "money"
module HttpCryptoPrice
  VERSION = "0.1.0"

  puts "which crypto price do you want to check? eg: etheruem,bitcoin,tether,usd-coin...etc"
  print "> "
  crypto = gets
  exit if crypto.nil?
  date = Time.local
  uri_Host = URI.parse "api.coingecko.com"
  uri_Path = URI.parse "/api/v3/simple/price"
  params = URI::Params.encode({"ids" => crypto, "vs_currencies" => "inr,usd,eur,gbp"}) # => "author=John+Doe&offset=20"
  response = HTTP::Client.get URI.new("https", uri_Host.to_s, query: params, path: uri_Path.to_s)
  if response.status_code == 200
    json_response = JSON.parse(response.body)
    inr = json_response[crypto.downcase]["inr"].to_s
    inr_str = inr.to_f
    inr_fr = Money.new(inr_str, "INR").format
    usd = json_response[crypto.downcase]["usd"].to_s
    usd_str = usd.to_f
    usd_fr = Money.new(usd_str, "USD").format
    eur = json_response[crypto.downcase]["eur"].to_s
    eur_str = eur.to_f
    eur_fr = Money.new(eur_str, "EUR").format
    gbp = json_response[crypto.downcase]["gbp"].to_s
    gbp_str = gbp.to_f
    gbp_fr = Money.new(gbp_str, "GBP").format
    puts "\n"
    puts "#{crypto.upcase} price now (#{date.to_s("%b %d, %Y")} #{date.to_s("%r")}),", "INR: #{inr_fr}", "USD: #{usd_fr}", "EUR: #{eur_fr}", "GBP: #{gbp_fr}" 
  else
    puts response.status_code    
  end
end
