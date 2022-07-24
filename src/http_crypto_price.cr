# TODO: Write documentation for `CrystalHttpTest`
require "http/client"
require "uri/params"
require "uri"
require "json"
require "money"
module CrystalHttpTest
  VERSION = "0.1.0"

  def self.http_request(crypto)
    date = Time.local
    uri_Host = URI.parse "api.coingecko.com"
    uri_Path = URI.parse "/api/v3/simple/price"
    uri_Path2 = URI.parse "/api/v3/coins/#{crypto}"
    params = URI::Params.encode({"ids" => crypto, "vs_currencies" => ["inr,usd,eur,gbp"]})
    response = HTTP::Client.get URI.new("https", uri_Host.to_s, query: params, path: uri_Path.to_s)
    response2 = HTTP::Client.get URI.new("https", uri_Host.to_s, query: "", path: uri_Path2.to_s)
    status_code = response2.status_code
    case
    when
      status_code == 404
      puts "\n"
      puts "Error! Try Again"
    else
      json_response = JSON.parse(response.body)
      inr = json_response[crypto]["inr"].to_s
      inr_str = inr.to_f
      inr_fr = Money.new(inr_str, "INR").format
      usd = json_response[crypto]["usd"].to_s
      usd_str = usd.to_f
      usd_fr = Money.new(usd_str, "USD").format
      eur = json_response[crypto]["eur"].to_s
      eur_str = eur.to_f
      eur_fr = Money.new(eur_str, "EUR").format
      gbp = json_response[crypto]["gbp"].to_s
      gbp_str = gbp.to_f
      gbp_fr = Money.new(gbp_str, "GBP").format
      puts "\n"
      puts "#{crypto.upcase} Price Now (#{date.to_s("%b %d, %Y")} #{date.to_s("%r")}),", "INR: #{inr_fr}", "USD: #{usd_fr}", "EUR: #{eur_fr}", "GBP: #{gbp_fr}" 
    end
  end
  puts "which crypto price do you want to check? eg: etheruem,bitcoin,tether,usd-coin...etc"
  print "> "
  crypto = gets
  case
  when crypto == ""
    puts "You have not given an input. Check the current value of Bitcoin."
    http_request "bitcoin"
    exit
  else
    puts "Please wait...."
    crypto = crypto.to_s.downcase.sub(" ", "-").sub(" ", "-").sub(" ", "-")
    http_request crypto
    exit
  end
end
