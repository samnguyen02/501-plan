# TAMU Ideathon Web Application

This repository contains the source code for the **TAMU Ideathon 2026** web
application – a Ruby on Rails service used to advertise the event, collect
registrations from students, and allow administrators to manage participants,
teams, and ideathon events.
Developer Emails:
samnguyen02@tamu.edu
joyceluo04@tamu.edu
oscarbravo@tamu.edu
lilly_seeley@tamu.edu

## Purpose

The goal of this project is to provide a full-featured landing site and
enrollment system for the ideathon. It includes:

* Public-facing landing page with event details, schedule, rules, and FAQs.
* Registration workflow for attendees (Google OAuth & email).
* Admin interface (Devise/Omniauth) to manage registrations, teams, and export
  data.
* Static asset pipeline powered by TailwindCSS and importmap.
* Basic health check endpoint (`/up`) for deployment monitoring.

## Getting Started

These instructions will help you set up a copy of the project on your local
development machine for development and testing purposes.

### Prerequisites

* **Ruby 3.4.6** (matches `.ruby-version`; managed via rbenv, rvm, or your system package manager).
* **Bundler** (`gem install bundler`).
* **PostgreSQL** server running locally (default config expects `localhost:5432`,
  user `postgres`, password `postgres` unless you override env vars).
* **Node.js** (recommended for Tailwind watcher support in local dev workflows).
* **Bash shell** for helper scripts under `script/` (Git Bash/WSL on Windows).

> Ruby dependencies are defined in `Gemfile`.

### Configuration

Copy the example environment file and fill in required values:

```sh
cp .env.example .env
# edit .env and set Google OAuth values and ALLOWED_ADMIN_EMAILS as needed
```

Google OAuth env compatibility:

- `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` (same naming as `501-club-staging`)
- `GOOGLE_OAUTH_CLIENT_ID` / `GOOGLE_OAUTH_CLIENT_SECRET` (also supported)

`501-plan` will use either pair, so local `.env` and deployed environment variables can use either naming convention.

Database connection values are read from `config/database.yml` and can be
overridden with:
- `DATABASE_HOST`
- `DATABASE_USER`
- `DATABASE_PASSWORD`

You may also use Rails credentials for sensitive values; see
`config/credentials.yml.enc`.

### First-Time Setup (after clone)

Start PostgreSQL first, then run setup:

```sh
bash script/start-db
ruby bin/setup --skip-server
```

`bin/setup` is idempotent and will:
- verify/install gems
- run `db:prepare`
- clear logs/tmp files

Then start development services:

```sh
bin/dev
```

Open `http://localhost:3000`.

For Windows (Git Bash/WSL), use:

```sh
bash script/start-db
ruby bin/setup --skip-server
TAILWIND_WATCH=0 bash script/app-start
```

If `bin/setup` fails with `ActiveRecord::ConnectionNotEstablished` or
`PG::ConnectionBad` and mentions `localhost:5432 refused`, PostgreSQL is not
running yet. Run `bash script/start-db` (or start your local Postgres service),
then run `ruby bin/setup --skip-server` again.

### Database Setup

Prepare (create + migrate) the database:

```sh
bundle exec rails db:prepare
```

Optionally seed initial data:

```sh
bundle exec rails db:seed
```

### Installing Dependencies

```sh
bundle install
```

### Running the Server

Use the standard Rails dev server:

```sh
bundle exec rails server
```

Browse to `http://localhost:3000` to view the landing page.

### Running Tests

RSpec is used for model/request/system specs. To execute the suite:

```sh
bundle exec rspec
```

SimpleCov is enabled in `spec/spec_helper.rb` and writes output to `coverage/`.
The test run will fail if coverage drops below the configured minimum.

There are also occasional system tests under `spec/system` which require
Chrome/Chromedriver and may be run with `bundle exec rails test:system`.

### Linting and Formatting

* RuboCop for Ruby (`bundle exec rubocop`).
* Brakeman security scan (`bundle exec brakeman -q`).
* Tailwind classes are auto-purged during asset compilation.

## Local DB Helper Scripts (Git Bash / WSL bash)

For local development on Windows, helper scripts are available in `script/`:

```sh
bash script/start-db
bash script/stop-db
bash script/app-start
```

`script/app-start` will:
- start local PostgreSQL
- ensure gems are installed
- run `bin/rails db:prepare`
- start Rails on `http://localhost:3000`
- start Tailwind watcher unless `TAILWIND_WATCH=0`

Example:

```sh
TAILWIND_WATCH=0 bash script/app-start
```

## Deployment

The application can be deployed to any Rack-compatible host (Heroku, AWS
Elastic Beanstalk, DigitalOcean, etc.). A typical workflow:

1. Ensure environment variables (DATABASE_URL, REDIS_URL, SECRET_KEY_BASE,
   etc.) are set.
2. Run `bundle exec rails db:migrate` on the server.
3. Precompile assets: `RAILS_ENV=production bundle exec rails assets:precompile`.
4. Restart the web server (e.g. Puma).
5. Configure a process manager (systemd, Procfile, etc.) and optionally a
   background job processor if you add Sidekiq or similar.

A `Dockerfile` and `Procfile.dev` are included for containerized deployments.

### Deploying to Heroku

You can deploy this Rails app to [Heroku](https://heroku.com) with the following steps:

1. **Create a Heroku app** (if you haven't already):
   ```sh
   heroku create your-app-name
   ```
2. **Set required environment variables** (replace values as needed):
   ```sh
   heroku config:set SECRET_KEY_BASE=... DATABASE_URL=... GOOGLE_CLIENT_ID=... GOOGLE_CLIENT_SECRET=...
   ```
3. **Provision a database** (if not auto-created):
   ```sh
   heroku addons:create heroku-postgresql:hobby-dev
   ```
4. **Deploy your code:**
   ```sh
   git push heroku main
   # or, if using 'master' branch:
   # git push heroku master
   ```
5. **Run database migrations:**
   ```sh
   heroku run bundle exec rails db:migrate
   ```
6. **(Optional) Seed initial data:**
   ```sh
   heroku run bundle exec rails db:seed
   ```
7. **Open your app:**
   ```sh
   heroku open
   ```

For more details, see the [Heroku Ruby on Rails guide](https://devcenter.heroku.com/articles/getting-started-with-rails6).

### Health and Monitoring

The `/up` endpoint returns `200` when the app boots successfully. Use this in
load balancer health checks or uptime monitors.

## Useful Commands

* `rails console` – open interactive session
* `rails db:reset` – drop, recreate, migrate, and seed the database
* `rails routes | grep ideathon` – view route list

## Contribution

Fork the repository, create a feature branch, and open a Pull Request. Run
`bundle exec rspec` locally to ensure tests pass. Code style follows
[Rails defaults](https://guides.rubyonrails.org/).

## License

This project is licensed under the MIT License – see `LICENSE` for details.


---
Updated as of 3/1/2026