class OpsController < ApplicationController

  http_basic_authenticate_with name: 'ops', password: ENV['OPS_PASSWORD']

end