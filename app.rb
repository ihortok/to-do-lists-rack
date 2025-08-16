# frozen_string_literal: true

class App
  def call(env)
    [200, { 'Content-Type' => 'text/plain' }, ['Hello World']]
  end
end
