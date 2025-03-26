# frozen_string_literal: true

require 'faraday'

points = []

SCHEDULER.every '1m' do
  conn = Faraday.new(settings.icecast_url) do |builder|
    builder.response(:json)
    builder.response(:raise_error)
  end

  icecast_stats = conn.get('status-json.xsl').body
  sources = icecast_stats['icestats']['source'].select do |source|
    source['server_name'] == settings.icecast_server_name
  end
  current_listeners = sources.map { |source| source['listeners'] }.reduce { |sum, listeners| sum + listeners }

  points.shift if points.length > 240
  points << { x: Time.now.to_i, y: current_listeners }

  send_event('stream_listener', points: points)
end
