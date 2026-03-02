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

* **Ruby 3.1+** (managed via rbenv, rvm, or your system package manager).
* **Bundler** (`gem install bundler`).
* **PostgreSQL** (or another supported database) – ensure a running server and
  a user with create privileges.
* **Yarn** / **Node.js** (optional, only required if you modify JS assets).
* **Docker** (optional) – the project includes a `Dockerfile` and `docker-compose`
  setup for containerized development.

> Rails and system dependencies are defined in `Gemfile` and `package.json`.

### Configuration

Copy the example environment file and fill in required secrets:

```sh
cp .env.example .env
# edit .env and set DATABASE_URL, SECRET_KEY_BASE, GOOGLE_CLIENT_ID, etc.
```

You may also use Rails credentials for sensitive values; see
`config/credentials.yml.enc`.

### Database Setup

Create and migrate the database, then seed initial data:

```sh
bundle exec rails db:create db:migrate db:seed
```

The seed file generates a default ideathon year and admin account if you need one.

### Installing Dependencies

```sh
bundle install
# optional JS build
yarn install
```

### Running the Server

Use the standard Rails dev server:

```sh
bundle exec rails server
```

or via Docker:

```sh
docker-compose build
docker-compose up
```

Browse to `http://localhost:3000` to view the landing page.

### Running Tests

RSpec is used for model/request/system specs. To execute the suite:

```sh
bundle exec rspec
```

There are also occasional system tests under `spec/system` which require
Chrome/Chromedriver and may be run with `bundle exec rails test:system`.

### Linting and Formatting

* RuboCop for Ruby (`bundle exec rubocop`).
* Tailwind classes are auto-purged during asset compilation.

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