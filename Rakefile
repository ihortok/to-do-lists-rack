# frozen_string_literal: true

require 'sqlite3'

MIGRATIONS_DIR = 'db/migrations'
DB_PATH = 'db/development.sqlite3'

def with_db
  db = SQLite3::Database.new(DB_PATH)
  db.busy_timeout = 2000 # 2s to avoid SQLITE_BUSY
  yield db
ensure
  db&.close
end

namespace :db do
  desc 'Create the SQLite database'
  task :create do
    if File.exist?(DB_PATH)
      puts "Database already exists at #{DB_PATH}"
    else
      with_db {} # touching/creating the file
      puts "Created database at #{DB_PATH}"
      # enable WAL for better read concurrency
      with_db { |db| db.execute 'PRAGMA journal_mode=WAL;' }
    end
  end

  desc 'Generate a new migration (usage: rake "db:new_migration[add_users_table]")'
  task :new_migration, [:name] do |_, args|
    abort 'Usage: rake db:new_migration[snake_case_name]' unless args[:name]
    version = Time.now.to_i
    path = File.join(MIGRATIONS_DIR, "#{version}_#{args[:name]}.sql")
    File.write path, <<~SQL
      -- Migration: #{args[:name]}
      -- Write SQL here (no BEGIN/COMMIT; rake wraps the whole file in a tx)
      -- Example:
      -- CREATE TABLE IF NOT EXISTS todos (
      --   id INTEGER PRIMARY KEY,
      --   title TEXT NOT NULL,
      --   done INTEGER NOT NULL DEFAULT 0,
      --   created_at TEXT DEFAULT CURRENT_TIMESTAMP
      -- );
    SQL
    puts "Created migration: #{path}"
  end

  desc 'Run all pending migrations'
  task migrate: :create do
    with_db do |db|
      db.execute <<~SQL
        CREATE TABLE IF NOT EXISTS schema_migrations (
          version TEXT PRIMARY KEY,
          applied_at TEXT NOT NULL DEFAULT (datetime('now'))
        );
      SQL

      applied = db.execute('SELECT version FROM schema_migrations').flatten

      Dir.glob("#{MIGRATIONS_DIR}/*.sql").sort.each do |file|
        version = File.basename(file).split('_', 2).first
        next if applied.include?(version)

        puts ">> Applying #{file}"
        sql = File.read(file)
        db.transaction
        begin
          db.execute_batch(sql)
          db.execute('INSERT INTO schema_migrations(version) VALUES (?)', [version])
          db.commit
        rescue SQLite3::Exception => e
          db.rollback
          abort "!! Failed to apply #{file}: #{e.message}"
        end
      end
    end
    puts 'All migrations up to date.'
  end

  desc 'Seed the database with 10 dummy todos'
  task seed: :migrate do
    with_db do |db|
      10.times do |i|
        db.execute(
          'INSERT INTO todos (title, done, created_at) VALUES (?, 0, ?)',
          ["Todo ##{i + 1}", Time.now.utc.strftime('%Y-%m-%d %H:%M:%S')]
        )
      end
    end
    puts 'Seeded 10 dummy todos.'
  end

  desc 'Drop the SQLite database'
  task :drop do
    if File.exist?(DB_PATH)
      # remove WAL/SHM if present
      %w[-wal -shm].each do |suffix|
        path = "#{DB_PATH}#{suffix}"
        File.delete(path) if File.exist?(path)
      end
      File.delete(DB_PATH)
      puts "Dropped database at #{DB_PATH}"
    else
      puts "No database found at #{DB_PATH}"
    end
  end

  desc 'Setup the database (create, migrate, seed)'
  task setup: %i[create migrate seed]

  desc 'Reset the database (drop, create, migrate, seed)'
  task reset: %i[drop setup]
end
