class StatController < ApplicationController
  def top_urls
    results = {}
    (0..4).reverse_each do |i|
      day = Stat.mysql_datestamp(i)
      day_start = "#{day} 00:00:00"
      day_end   = "#{day} 23:59:59"
      result    = Stat.with_sql("select url, count(url) as visits from stats where created_at >= \'#{day_start}\' and created_at <= \'#{day_end}\' group by url order by visits desc")
      results[day] = result.all
    end

    render json: results
  end

  def top_referrers
    results = {}
    (0..4).reverse_each do |i|
      day = Stat.mysql_datestamp(i)
      day_start = "#{day} 00:00:00"
      day_end   = "#{day} 23:59:59"
      result    = Stat.with_sql(<<-sql
        select 
          s.url, sub.visits, referrer, count(referrer) as refer_visits 
        from 
          (select url, count(url) as visits from stats  group by url order by count(url) desc limit 10) sub         
        join                         
          stats s on sub.url=s.url 
        where 
          created_at >= '#{day_start}' and created_at <= '#{day_end}' 
        group by 
          s.url, s.referrer;
      sql
      )

      nested_result = {}
      rows = result.all

      rows.each do |row|
        unless nested_result[row.url]
          nested_result[row.url] = { :visits => row[:visits], :referrers => [] }
        end
        parent_row = nested_result[row.url]
        nested_result[row.url][:referrers].push({ url: row.referrer, visits: row[:refer_visits] })
      end

      results[day] = nested_result
    end

    render json: results
  end
end
