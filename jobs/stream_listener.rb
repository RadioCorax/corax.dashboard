# frozen_string_literal: true

require 'faraday'

points = []
(1..100).each do |i|
  points << { x: i, y: 0 }
end

SCHEDULER.every '1m' do
  conn = Faraday.new(settings.icecast_url) do |builder|
    builder.response(:json)
    builder.response(:raise_error)
  end

  icecast_stats = conn.get('status-json.xsl').body
  current_listeners = icecast_stats['icestats']['source'].select do |source|
    source['server_name'] == settings.icecast_server_name
  end.reduce(0) { |sum, stream| sum + stream['listeners'] }

  points.shift
  points << { x: points.last[:x] + 1, y: current_listeners }

  send_event('stream_listener', points: points)
end
