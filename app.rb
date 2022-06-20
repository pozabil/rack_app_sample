class App
  DIRECTIVES = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }

  def initialize
    @status = nil
    @headers = {}
    @body =[]
  end

  def call(env)
    if correct_request(env) && formats(env).any?
      @headers['Content-Type'] = 'text/plain'

      if incorrect_formats(env).empty?
        @status = 200
        @body = [formatted_time(formats(env))]
      else
        @status = 400
        @body = ["Unknown time format [#{incorrect_formats(env).join(',')}]"]
      end
    else
      @status = 404
      @headers = {}
      @body =[]
    end

    [@status, @headers, @body]
  end

  private

  def correct_request(env)
    env['REQUEST_METHOD'] == 'GET' && env['REQUEST_PATH'] == '/time' && env['QUERY_STRING'].match?(/\Aformat=/)
  end

  def formats(env)
    delimiters = Regexp.union(',', '%2C')
    env['QUERY_STRING'].delete_prefix('format=').split(delimiters)
  end

  def incorrect_formats(env)
    formats(env).reject{ |f| DIRECTIVES.keys.include?(f) }
  end

  def formatted_time(formats)
    Time.now.strftime(formats.join('-').gsub(Regexp.union(DIRECTIVES.keys), DIRECTIVES))
  end
end
