wolmps - WOL Magic Packet Sender
================================

Requirements
------------

  * Ruby

Quick Start
-----------

Install app and dependencies

    # cd /path/to/wolmps
    # git clone https://github.com/kteru/wolmps .
    # gem install bundler --no-rdoc --no-ri
    # bundle install --path vendor/bundle

Create SQLite db file

    # bundle exec rake

Start

    # bundle exec ruby app.rb -p 10000 -o 0.0.0.0

Remarks
-------

This contains Twitter Boostrap library.

