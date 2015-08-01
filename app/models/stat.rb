class Stat < Sequel::Model
  def self.mysql_datestamp(days_ago)
    day = Time.now - days_ago.days
    day.strftime("%Y-%m-%d")
  end

  def self.mysql_timestamp(days_ago = 0)
    day = Time.now - days_ago.days
    if days_ago
      day.strftime("%Y-%m-%d 00:00:00")
    else
      day.strftime("%Y-%m-%d %H:%M:%S")
    end
  end

  def self.rand_mysql_timestamp(days=11)
    (Time.now - rand(11).days).strftime("%Y-%m-%d %H:%M:%S")
  end
end
