# sentry-inst_jobs

---

[![Gem Version](https://img.shields.io/gem/v/sentry-inst_jobs.svg)](https://rubygems.org/gems/sentry-inst_jobs)
[![Gem](https://img.shields.io/gem/dt/sentry-inst_jobs.svg)](https://rubygems.org/gems/sentry-inst_jobs/)

An [Instructure Delayed Jobs](https://github.com/instructure/inst-jobs) integration for Sentry's Ruby client.

This repository was forked from [sentry-ruby](https://github.com/getsentry/sentry-ruby). Very minor changes were made to
make `sentry-delayed_job` compatible with `inst-jobs`. This integration is not affiliated with Sentry.

## Getting Started

### Install

```ruby
gem "sentry-inst_jobs"
```

Then you're all set! `sentry-inst_jobs` will automatically insert a custom middleware and error handler to capture exceptions from your workers!
