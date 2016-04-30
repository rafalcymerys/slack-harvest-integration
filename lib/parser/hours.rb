module Parser
  class Hours
    HOURS_PATTERN = /\A(?<hours>\d{0,2}):?(?<minutes>\d{0,2})\z/
    MINUTES_IN_HOUR = 60

    private_constant :HOURS_PATTERN, :MINUTES_IN_HOUR

    def parse(hours_string)
      match = HOURS_PATTERN.match(hours_string)
      raise IncorrectHoursError unless match

      hours = match[:hours].to_i
      minutes = match[:minutes].to_i

      hours + (minutes.to_f / MINUTES_IN_HOUR)
    end

    def valid?(hours_string)
      HOURS_PATTERN.match(hours_string) != nil
    end
  end
end
