require "rails_helper"

describe "BeermappingApi" do
  it "when HTTP GET returns one entry, it is parsed and returned" do
    mock_response = <<-EOS
      <?xml version="1.0" encoding="utf-8"?>
      <bmp_locations>
        <location>
          <id>18856</id>
          <name>Panimoravintola Koulu</name>
          <status>Brewpub</status>
          <reviewlink>https://beermapping.com/location/18856</reviewlink>
          <proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink>
          <blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap>
          <street>Eerikinkatu 18</street>
          <city>Turku</city>
          <state/>
          <zip>20100</zip>
          <country>Finland</country>
          <phone>(02) 274 5757</phone>
          <overall>0</overall>
          <imagecount>0</imagecount>
        </location>
      </bmp_locations>
    EOS

    stub_request(:get, /.*turku/).to_return(
      body: mock_response,
      headers: {
        "Content-Type" => "text/xml",
      },
    )

    places = BeermappingApi.places_in("turku")
    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("Panimoravintola Koulu")
    expect(place.street).to eq("Eerikinkatu 18")
  end

  it "when HTTP GET returns no entries, it returns empty array" do
    mock_response = <<-EOS
      <?xml version="1.0" encoding="utf-8"?>
      <bmp_locations>
        <location>
          <id/>
          <name/>
          <status/>
          <reviewlink/>
          <proxylink/>
          <blogmap/>
          <street/>
          <city/>
          <state/>
          <zip/>
          <country/>
          <phone/>
          <overall/>
          <imagecount/>
        </location>
      </bmp_locations>
    EOS

    stub_request(:get, /.*fakecity/).to_return(
      body: mock_response,
      headers: {
        "Content-Type" => "text/xml",
      },
    )

    places = BeermappingApi.places_in("fakecity")
    expect(places.size).to eq(0)
  end

  it "when HTTP GET returns multiple entries, it returns array of entries" do
    mock_response = <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <bmp_locations>
        <location>
          <id>6742</id>
          <name>Pullman Bar</name>
          <status>Beer Bar</status>
          <reviewlink>https://beermapping.com/location/6742</reviewlink>
          <proxylink>http://beermapping.com/maps/proxymaps.php?locid=6742&amp;d=5</proxylink>
          <blogmap>http://beermapping.com/maps/blogproxy.php?locid=6742&amp;d=1&amp;type=norm</blogmap>
          <street>Kaivokatu 1</street>
          <city>Helsinki</city>
          <state/>
          <zip>00100</zip>
          <country>Finland</country>
          <phone>+358 9 0307 22</phone>
          <overall>72.500025</overall>
          <imagecount>0</imagecount>
        </location>
        <location>
          <id>6743</id>
          <name>Belge</name>
          <status>Beer Bar</status>
          <reviewlink>https://beermapping.com/location/6743</reviewlink>
          <proxylink>http://beermapping.com/maps/proxymaps.php?locid=6743&amp;d=5</proxylink>
          <blogmap>http://beermapping.com/maps/blogproxy.php?locid=6743&amp;d=1&amp;type=norm</blogmap>
          <street>Kluuvikatu 5</street>
          <city>Helsinki</city>
          <state/>
          <zip>00100</zip>
          <country>Finland</country>
          <phone>+358 10 766 35</phone>
          <overall>67.499925</overall>
          <imagecount>1</imagecount>
        </location>
        <location>
          <id>6919</id>
          <name>Suomenlinnan Panimo</name>
          <status>Brewpub</status>
          <reviewlink>https://beermapping.com/location/6919</reviewlink>
          <proxylink>http://beermapping.com/maps/proxymaps.php?locid=6919&amp;d=5</proxylink>
          <blogmap>http://beermapping.com/maps/blogproxy.php?locid=6919&amp;d=1&amp;type=norm</blogmap>
          <street>Rantakasarmi</street>
          <city>Helsinki</city>
          <state/>
          <zip>00190</zip>
          <country>Finland</country>
          <phone>+358 9 228 5030</phone>
          <overall>69.166625</overall>
          <imagecount>0</imagecount>
        </location>
      </bmp_locations>
    EOS

    stub_request(:get, /.*helsinki/).to_return(
      body: mock_response,
      headers: {
        "Content-Type" => "text/xml",
      },
    )

    places = BeermappingApi.places_in("helsinki")
    expect(places.size).to eq(3)

    first_place = places.first
    expect(first_place.name).to eq("Pullman Bar")
    last_place = places.last
    expect(last_place.name).to eq("Suomenlinnan Panimo")
  end

  describe "in case of cache miss do" do
    before :each do
      Rails.cache.clear
    end

    it "when HTTP GET returns one entry, it is parsed and returned" do
      mock_response = <<-EOS
        <?xml version="1.0" encoding="utf-8"?>
        <bmp_locations>
          <location>
            <id>18856</id>
            <name>Panimoravintola Koulu</name>
            <status>Brewpub</status>
            <reviewlink>https://beermapping.com/location/18856</reviewlink>
            <proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink>
            <blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap>
            <street>Eerikinkatu 18</street>
            <city>Turku</city>
            <state/>
            <zip>20100</zip>
            <country>Finland</country>
            <phone>(02) 274 5757</phone>
            <overall>0</overall>
            <imagecount>0</imagecount>
          </location>
        </bmp_locations>
      EOS

      stub_request(:get, /.*turku/).to_return(
        body: mock_response,
        headers: {
          "Content-Type" => "text/xml",
        },
      )

      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end

    describe "in case of cache hit do" do
      before :each do
        Rails.cache.clear
      end

      it "returns cached response" do
        mock_response = <<-EOS
        <?xml version="1.0" encoding="utf-8"?>
        <bmp_locations>
          <location>
            <id>18856</id>
            <name>Panimoravintola Koulu</name>
            <status>Brewpub</status>
            <reviewlink>https://beermapping.com/location/18856</reviewlink>
            <proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink>
            <blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap>
            <street>Eerikinkatu 18</street>
            <city>Turku</city>
            <state/>
            <zip>20100</zip>
            <country>Finland</country>
            <phone>(02) 274 5757</phone>
            <overall>0</overall>
            <imagecount>0</imagecount>
          </location>
        </bmp_locations>
      EOS

        stub_request(:get, /.*turku/).to_return(
          body: mock_response,
          headers: {
            "Content-Type" => "text/xml",
          },
        )

        BeermappingApi.places_in("turku")
        places = BeermappingApi.places_in("turku")

        expect(places.size).to eq(1)
        place = places.first
        expect(place.name).to eq("Panimoravintola Koulu")
        expect(place.street).to eq("Eerikinkatu 18")
      end
    end
  end
end
