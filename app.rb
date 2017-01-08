require 'sinatra'
require 'haml'

set :bind, '0.0.0.0'
set :port, 4444
set :logging, true

get '/' do
  haml :hello
end

