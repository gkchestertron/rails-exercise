class StatController < ApplicationController
  def top_urls
    results = {}
    (0..4).reverse_each do |i|
      day = Stat.mysql_datestamp(i)
      day_start = "#{day} 00:00:00"
      day_end   = "#{day} 23:59:59"
      result    = Stat.with_sql("select url, count(url) as visit from stats where created_at >= \'#{day_start}\' and created_at <= \'#{day_end}\' group by url order by visit desc")
      results[day] = result.all
    end

    render json: results
  end

  def top_referrers
    render json: Stat.last()
  end
end
