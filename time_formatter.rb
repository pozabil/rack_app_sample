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
  end

  def call
    incorrect_formats = @formats.reject{ |f| DIRECTIVES.keys.include?(f) }

    if incorrect_formats.empty?
      Time.now.strftime(@formats.join('-').gsub(Regexp.union(DIRECTIVES.keys), DIRECTIVES))
    else
      "Unknown time format [#{incorrect_formats.join(',')}]"
    end
  end
end