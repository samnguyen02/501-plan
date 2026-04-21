# TAMU Ideathon Technical Documentation

This document summarizes core architecture for the merged `501-plan` codebase.

## Stack

- Ruby on Rails
- PostgreSQL
- Devise + OmniAuth (Google OAuth2)
- Turbo/Hotwire

## Primary Areas

- Public site: `ideathon#index`
- Manager dashboard: `manager#index`
- Admin modules under `/dashboard/*`

## Authentication and Authorization

- Model: `Admin`
- Roles: `admin`, `editor`, `unauthorized`
- Global guards in `ApplicationController`
- Dashboard-specific guard in `ClubDashboardController`

## Key Domain Tables

- `ideathon_years`
- `registered_attendees`
- `teams`
- `sponsors_partners`
- `mentors_judges`
- `faqs`
- `rules`
- `activity_logs`
- `manager_action_logs`

## Data Flow Notes

- Public home page content is selected by `ActiveIdeathonYear`.
- Dashboard content models belong to ideathon years and update parent freshness timestamps.
- CSV exports are generated in manager/content controllers.

## Local Verification

```bash
bundle install
bin/rails db:prepare
bundle exec rubocop
bundle exec brakeman -q
bundle exec rspec
```

## Deployment Notes

- Provide OAuth environment variables (`GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` or `GOOGLE_OAUTH_CLIENT_ID` / `GOOGLE_OAUTH_CLIENT_SECRET`).
- Run migrations on deploy.
- Verify `/up` health endpoint.
