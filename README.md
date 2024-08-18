# Cron Field Expander

## Overview

The Cron Field Expander is a Ruby application designed to handle and expand cron field expressions. It supports various formats such as wildcards, lists, ranges, and steps. This tool is useful for interpreting and validating cron job schedules.

## Features

- **Wildcard Expansion**: Handles `*` to represent all values within the range.
- **List Expansion**: Processes comma-separated values.
- **Range Expansion**: Expands ranges (e.g., `1-5`).
- **Step Expansion**: Manages stepping within ranges and single values (e.g., `0-20/2`).

## Installation

To get started with the Cron Field Expander, follow these steps:

1. **Clone the Repository**

   ```bash
   git clone https://github.com/georges1996/cron_field_expander.git
   cd cron_field_expander
   ```
2. **Install Ruby**

   Ensure you have Ruby 3.3.1 installed. You can use a version manager like [rbenv](https://github.com/rbenv/rbenv) or [RVM](https://rvm.io/) to install the specific version.

   **Using rbenv**:
   ```bash
   rbenv install 3.3.1
   rbenv local 3.3.1
   ```

3. **Install packages **
- Run `bundle` (All tests should pass)

4. **Run the app **
- An example valid command: `./cron_runner.rb "*/15 0 1,15 MAY 1-5 /usr/bin/find"`
- Example CRON format
 ```bash
	|------------------------------- Minute (0-59)
	|     |------------------------- Hour (0-23)
	|     |     |------------------- Day of the month (1-31)
	|     |     |     |------------- Month (1-12; or JAN to DEC)
	|     |     |     |     |------- Day of the week (0-6; or SUN to SAT)
	|     |     |     |     |
	|     |     |     |     |
	*     *     *     *     *
   ```

5. **Run tests **
- run `bundle exec rspec` to run all tests

