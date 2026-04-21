# Admin Dashboard Merge Notes

## Scope

This branch integrates admin dashboard modules from `501-club-staging` into `501-plan` while preserving `501-plan` as the primary website/auth codebase.

## Integrated Areas

- Dashboard route group under `/dashboard` for:
  - `users`
  - `activity_logs`
  - `ideathons`
  - `sponsors_partners`
  - `mentors_judges`
  - `faqs`
  - `rules`
- New dashboard controllers and views for the modules above.
- New models/services for:
  - ideathon-year aliasing (`Ideathon`)
  - sponsors/partners
  - mentors/judges
  - FAQs
  - rules
  - activity logging
  - CSV import support
  - active year resolution
- Role-based admin access on `Admin` (`admin`, `editor`, `unauthorized`) to support dashboard authorization.

## Migrations Added

- `db/migrate/20260420110000_add_role_to_admins.rb`
- `db/migrate/20260420120000_add_dashboard_fields_to_ideathon_years.rb`
- `db/migrate/20260420120100_create_sponsors_partners.rb`
- `db/migrate/20260420120200_create_mentors_judges.rb`
- `db/migrate/20260420120300_create_faqs.rb`
- `db/migrate/20260420120400_create_rules.rb`
- `db/migrate/20260420120500_create_activity_logs.rb`

## Validation Run

- `bundle install` (pass)
- `bundle exec rails runner "puts 'boot_ok'"` (pass)
- `bundle exec rails routes` (pass)
- Ruby syntax check for changed `.rb` files (pass)
- `bundle exec rails db:migrate` (blocked: PostgreSQL not running on local machine)
- `bundle exec rspec spec/models/admin_spec.rb` (blocked: PostgreSQL not running on local machine)

## Follow-up Required Locally

1. Start PostgreSQL on this machine.
2. Run `bundle exec rails db:migrate`.
3. Run full test suite (`bundle exec rspec` and/or `bin/rails test`).
4. Manually smoke test:
   - public homepage
   - registration flow
   - manager dashboard
   - new `/dashboard/*` modules.
