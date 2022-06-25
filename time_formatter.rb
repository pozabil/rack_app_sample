class TimeFormatter
  DIRECTIVES = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }

  def initialize(formats)
    @formats = formats
    @incorrect_formats = @formats.reject{ |f| DIRECTIVES.keys.include?(f) }
  end

  def success?
    incorrect_formats.empty?
  end

  def body
    if success?
      formatted_time_string
    else
      invalid_formats_string
    end
  end

  private

  attr_reader :incorrect_formats

  def formatted_time_string
    Time.now.strftime(@formats.join('-').gsub(Regexp.union(DIRECTIVES.keys), DIRECTIVES)) if success?
  end

  def invalid_formats_string
    "Unknown time format [#{incorrect_formats.join(',')}]" unless success?
  end
end
