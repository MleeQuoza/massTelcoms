class Time
  def self.valid_date_string?(string)
    Time.parse(string).present?
  rescue
    return false
  end
end