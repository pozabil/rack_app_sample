require_relative 'time_formatter'

class App
  def call(env)
    formats = formats(env)

    if correct_request(env) && formats.any?
      response_body = TimeFormatter.new(formats).call

      Rack::Response.new(
        [response_body],
        response_body.match?(/\AUnknown/) ? 400 : 200,
        {'Content-Type' => 'text/plain'}
        ).finish
    else
      Rack::Response.new([],404,{}).finish
    end
  end

  private

  def correct_request(env)
    env['REQUEST_METHOD'] == 'GET' && env['REQUEST_PATH'] == '/time' && env['QUERY_STRING'].match?(/\Aformat=/)
  end

  def formats(env)
    delimiters = Regexp.union(',', '%2C')
    env['QUERY_STRING'].delete_prefix('format=').split(delimiters)
  end
end
