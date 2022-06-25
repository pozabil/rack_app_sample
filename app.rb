require_relative 'time_formatter'

class App
  def call(env)
    formats = formats(env)

    if correct_request(env) && formats.any?
      time_formatter = TimeFormatter.new(formats)

      make_response(time_formatter.success? ? 200 : 400, [time_formatter.body])
    else
      make_response(404)
    end
  end

  private

  def make_response(status, body = [])
    headers = status == 404 ? {} : {'Content-Type' => 'text/plain'}
    puts body.inspect
    Rack::Response.new(body, status, headers).finish
  end

  def correct_request(env)
    env['REQUEST_METHOD'] == 'GET' && env['REQUEST_PATH'] == '/time' && env['QUERY_STRING'].match?(/\Aformat=/)
  end

  def formats(env)
    delimiters = Regexp.union(',', '%2C')
    env['QUERY_STRING'].delete_prefix('format=').split(delimiters)
  end
end
