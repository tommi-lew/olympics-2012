if Country.count == 0
  require 'nokogiri'
  require 'open-uri'

  continents = ["http://www.london2012.com/countries/area=africa/",
                "http://www.london2012.com/countries/area=asia/",
                "http://www.london2012.com/countries/area=europe/",
                "http://www.london2012.com/countries/area=oceania/",
                "http://www.london2012.com/countries/area=americas/"]

  continents.each do |continent|
    doc = Nokogiri::HTML(open(continent))

    doc.css('div.itemsList.countryList ul li').each do |country|
      name = country.css('div.countryName a').text
      flagSrc = country.css('div.image a img').attribute("src")
      url = country.css('div.countryName a').attribute("href")

      c = Country.new(name: name, flagSrc: flagSrc, url: url)
      c.save
    end
  end
end
