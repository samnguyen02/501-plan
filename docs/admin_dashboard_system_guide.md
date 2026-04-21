# 501-plan Admin Dashboard System Guide

This document summarizes how the dashboard and public site share data in `501-plan`.

## High-Level Architecture

- Public site: `app/controllers/ideathon_controller.rb`, `app/views/ideathon/index.html.erb`
- Manager dashboard: `app/controllers/manager_controller.rb`, `app/views/manager/index.html.erb`
- Admin content dashboard (`/dashboard/*`): ideathons, sponsors/partners, mentors/judges, FAQs, rules, activity logs, and admin-role management.

## Auth and Roles

- Authentication uses Devise `Admin` with Google OAuth.
- Roles on `Admin`: `admin`, `editor`, `unauthorized`.
- Shared authorization helpers live in `app/controllers/application_controller.rb`.
- Dashboard base guard is `app/controllers/club_dashboard_controller.rb`.

## Key Routes

- Public: `/`
- Manager: `/manager`
- Dashboard modules: `/dashboard/ideathons`, `/dashboard/sponsors_partners`, `/dashboard/mentors_judges`, `/dashboard/faqs`, `/dashboard/rules`, `/dashboard/activity_logs`, `/dashboard/users`

## Data Model Highlights

- Parent year table: `ideathon_years` (with alias model `Ideathon`)
- Registration: `registered_attendees`, `teams`
- Public-content modules: `sponsors_partners`, `mentors_judges`, `faqs`, `rules`
- Logging: `manager_action_logs`, `activity_logs`

## Local Verification Commands

```bash
bundle install
bash script/start-db
bin/rails db:prepare
bin/rails runner "puts 'BOOT_OK'"
bundle exec rubocop
bundle exec brakeman -q
bundle exec rspec
```

To stop local Postgres:

```bash
bash script/stop-db
```
