if Country.count == 0
  require 'nokogiri'
  require 'open-uri'

  continents = {'africa' => 'http://www.london2012.com/countries/area=africa/',
                'asia' => 'http://www.london2012.com/countries/area=asia/',
                'europe' => 'http://www.london2012.com/countries/area=europe',
                'oceania' => 'http://www.london2012.com/countries/area=oceania/',
                'americas' => 'http://www.london2012.com/countries/area=americas/'}

  continents.each do |k,v|
    doc = Nokogiri::HTML(open(v))

    doc.css('div.itemsList.countryList ul li').each do |country|
      continent = k
      name = country.css('div.countryName a').text
      flagSrc = country.css('div.image a img').attribute("src")
      url = country.css('div.countryName a').attribute("href")
      url_name = country.css('a').attribute("href").text
      url_name.slice!("/country/")
      url_name.chop!.chop!

      c = Country.new(name: name, flagSrc: flagSrc, url: url, continent: continent, url_name: url_name)
      c.save
    end
  end
end
