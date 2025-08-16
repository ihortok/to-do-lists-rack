# frozen_string_literal: true

require 'json'
require 'sqlite3'

class App
  def call(env)
    db = SQLite3::Database.new('db/development.sqlite3')
    db.results_as_hash = true
    todos = db.execute('SELECT * FROM todos')

    [200, { 'Content-Type' => 'application/json' }, [todos.to_json]]
  end
end
