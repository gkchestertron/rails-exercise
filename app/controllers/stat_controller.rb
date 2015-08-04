class StatController < ApplicationController
  def top_urls
    day_start = Stat.mysql_datestamp(-5)
    day_end   = Stat.mysql_datestamp(0)

    result    = Stat.with_sql(<<-sql
      select 
        date(created_at) as c_date, url, count(url) as visits 
      from 
        stats 
      where 
        date(created_at) >= \'#{day_start}\' and date(created_at) <= \'#{day_end}\' 
      group by c_date, url 
      order by c_date desc, visits desc
      sql
    )

    render json: self.nested_result(result.all, false)
  end

  def top_referrers
    day_start = Stat.mysql_datestamp(-5)
    day_end   = Stat.mysql_datestamp(0)
    result    = Stat.with_sql(<<-sql
      select 
        date(s.created_at) as c_date, s.url, sub.visits, referrer, count(referrer) as refer_visits 
      from 
        (select url, count(url) as visits from stats  group by url order by count(url) desc limit 10) sub         
      join                         
        stats s on sub.url=s.url 
      where 
        date(created_at) >= '#{day_start}' and created_at <= '#{day_end}' 
      group by 
        c_date, s.url, s.referrer
      order by c_date desc;
    sql
    )

    render json: self.nested_result(result.all, true)
  end

  def nested_result(rows, referrers=false)
    p rows
    nested_result = {}

    rows.each do |row|
      next if referrers and row[:referrer] == nil

      unless nested_result[row[:c_date]] 
        nested_result[row[:c_date]] = []
      end

      unless nested_result[row[:c_date]].any?{|nested_row| nested_row[:url] == row[:url]}
        if row[:referrer]
          nested_result[row[:c_date]].push({ :url => row[:url], :visits => row[:visits], :referrers => [] })
        else
          nested_result[row[:c_date]].push({ :url => row[:url], :visits => row[:visits] })
        end
      end

      if row[:referrer]
        parent_row = nested_result[row[:c_date]].find{|nested_row| nested_row[:url] == row[:url]}
        parent_row[:referrers].push({ url: row.referrer, visits: row[:refer_visits] })
      end
    end

    nested_result
  end
end
