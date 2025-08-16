# frozen_string_literal: true

run ->(env) { [200, { 'Content-Type' => 'text/plain' }, ['Hello World']] }
