# To-Do Lists Rack App

Simple To-Do list application built with Rack.

## Getting Started

### Prerequisites
- Ruby (>= 3.4 recommended)
- Bundler

### Installation
1. Clone the repository:
   ```zsh
   git clone https://github.com/ihortok/to-do-lists-rack.git
   cd to-do-lists-rack
   ```
2. Install dependencies:
   ```zsh
   bundle install
   ```
3. Run database migrations (if needed):
   ```zsh
   rake db:migrate
   ```

### Running the App
Start the Rack server:
```zsh
rackup
```
The app will be available at [http://localhost:9292](http://localhost:9292).

## Project Structure
- `app.rb` - Main application logic
- `config.ru` - Rack configuration
- `db/` - Database files and migrations
- `Gemfile` - Ruby gem dependencies
- `Rakefile` - Rake tasks
