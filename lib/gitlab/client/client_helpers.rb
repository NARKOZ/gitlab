class Gitlab::Client
  module Helpers
    def paginate url, options={}
      list = []
      loop do
        resp = http_response_for(:get, url, options)
        list.push validate resp
        break unless auto_paginate
        break if (url = rels(resp.headers)['next']).nil?
      end
      list.count > 1 ? list.flatten : list[0]
    end

    def rels headers
      links = headers['Link']
      return {} if links.nil?
      Hash[ links.split(', ').map { |l|
        (link,rel) = l.split('; ')
        key = /rel="(.*)"/.match(rel)[1]
        link = /<(.*)>/.match(link)[1]
        [key, link]
      }]
    end

  end
end