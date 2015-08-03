start_time = Time.now

urls = [
  'http://apple.com',
  'https://apple.com',
  'https://www.apple.com',
  'http://developer.apple.com',
  'http://en.wikipedia.org',
  'http://opensource.org',
  'http://copypastecharacter.com', 
  'http://codeacademy.com', 
  'http://lovelycharts.com', 
  'http://iconfinder.com', 
  'http://office.com', 
  'http://followupthen.com', 
  'http://jotti.org', 
  'http://wolframalpha.com', 
  'http://printwhatyoulike.com'
]

referrers = [
  'http://apple.com',
  'https://apple.com',
  'https://www.apple.com',
  'http://developer.apple.com',
  'http://copypastecharacter.com', 
  'http://codeacademy.com', 
  'http://lovelycharts.com', 
  'http://iconfinder.com', 
  'http://office.com', 
  'http://followupthen.com', 
  'http://jotti.org', 
  'http://wolframalpha.com', 
  'http://printwhatyoulike.com',
  nil
]

Sequel.transaction([]) do
  1000.times do |i|
    stats = []
    1000.times do |j|
      id = 1000 * i + j
      time_stamp = Stat.rand_mysql_timestamp
      hash = Digest::MD5.hexdigest({id: id, url: urls.sample, referrer: referrers.sample, created_at: time_stamp}.to_s)
      stats.push({url: urls.sample, referrer: referrers.sample, hash: hash, created_at: time_stamp})
    end
    Stat.multi_insert(stats)
  end
end

end_time = Time.now
diff = end_time - start_time
puts diff
