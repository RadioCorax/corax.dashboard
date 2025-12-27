# frozen_string_literal: true

require 'faraday'

SCHEDULER.every '1m' do
  conn = Faraday.new(settings.mairlist_url, request: { timeout: 15 }) do |builder|
    builder.request(:authorization, :basic, settings.mairlist_username, settings.mairlist_password)
    builder.request(:json)
    builder.response(:json)
    builder.response(:raise_error)
  end

  send_event('playlist_day', conn.get(settings.mairlist_playlist_day).body)
  send_event('playlist_night', conn.get(settings.mairlist_playlist_night).body)
end
