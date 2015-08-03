class Stat < Sequel::Model
  def self.mysql_datestamp(day_diff)
    day = Time.now + day_diff.days
    day.strftime("%Y-%m-%d")
  end

  def self.mysql_timestamp(day_diff = 0)
    day = Time.now + day_diff.days
    if day_diff
      day.strftime("%Y-%m-%d 00:00:00")
    else
      day.strftime("%Y-%m-%d %H:%M:%S")
    end
  end

  def self.rand_mysql_timestamp(days=11)
    (Time.now - rand(11).days).strftime("%Y-%m-%d %H:%M:%S")
  end
end
