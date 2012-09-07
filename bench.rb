require "rubygems"
require "bundler/setup"

require 'cosm-rb'
require 'benchmark'
include Benchmark

RUNS = 10000
ds = []
10.times {ds << Cosm::Datastream.new({
  :id => "ds#{rand(1000)}",
  :current_value => rand(1024),
  :updated => Time.now,
  :unit_symbol => "C",
  :unit_label => "Temperature",
  :unit_type => "n/a",
  :min_value => 1,
  :max_value => 2,
  :tags => ['one'],
  :datapoints => [Cosm::Datapoint.new({:at => Time.now, :value => 123}), Cosm::Datapoint.new({:at => Time.now, :value => 321})]
})}

feed = Cosm::Feed.new(
  :title => "Profile feed",
  :datastreams => ds,
  :tags => ["a", "b", "c"],
  :creator => "Levent",
  :location_name => "London",
  :location_disposition => "Disposessed",
  :owner_login => "lebreeze"
)

datastream = ds[0]

feed_json = feed.to_json
feed_xml = feed.to_xml
feed_csv = feed.to_csv

datastream_json = datastream.to_json
datastream_xml = datastream.to_xml
datastream_csv = "2012-09-07T13:28:05.041739+00:00,321"

puts "Benchmarking feeds..."

Benchmark.bmbm do |x|
  x.report("feed#to_json") do
    RUNS.times do
      feed.to_json
    end
  end

  x.report("feed#to_xml") do
    RUNS.times do
      feed.to_xml
    end
  end

  x.report("feed#to_csv") do
    RUNS.times do
      feed.to_csv
    end
  end

  x.report("feed#from_json") do
    RUNS.times do
      Cosm::Feed.new(feed_json)
    end
  end

  x.report("feed#from_xml") do
    RUNS.times do
      Cosm::Feed.new(feed_xml)
    end
  end

  x.report("feed#from_csv") do
    RUNS.times do
      Cosm::Feed.new(feed_csv, :v2)
    end
  end
end

puts
puts "Benchmarking datastreams..."

Benchmark.bmbm do |x|
  x.report("datastream#to_json") do
    RUNS.times do
      datastream.to_json
    end
  end

  x.report("datastream#to_xml") do
    RUNS.times do
      datastream.to_xml
    end
  end

  x.report("datastream#to_csv") do
    RUNS.times do
      datastream.to_csv
    end
  end

  x.report("datastream#from_json") do
    RUNS.times do
      Cosm::Datastream.new(datastream_json)
    end
  end

  x.report("datastream#from_xml") do
    RUNS.times do
      Cosm::Datastream.new(datastream_xml)
    end
  end

  x.report("datastream#from_csv") do
    RUNS.times do
      Cosm::Datastream.new(datastream_csv)
    end
  end
end
