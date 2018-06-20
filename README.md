# README

This is the Membership Management System ("the system") used by the San Francisco Civic Music Association. It is a fairly basic Rails app, with a few standard gems on top of it. It is made to run on a single Heroku dyno, plus database.

Note that there is no current JS pre-processing that occurs.

## Purpose

The system is used for several key areas of SFCMA's activities:

1. Having a central repository for all member contact information
2. Recording which members are playing in which groups, and having that be accessible to all relevant parties
3. Being able to contact current lists of members in each group through email
4. Allowing members to opt into playing
5. Allowing members to record their absences, and for the musical leadership to know these absences in advance
6. Collecting data to be used in reporting to the Board, membership, and for grants/funding.

Here is a basic overview of the data model:

![Data Model](https://user-images.githubusercontent.com/3664475/30000971-c3951742-9033-11e7-8709-fdc3e3703e5c.png)

## Key Models:

*Members* is the core model, representing the players.

*Users* are the login accounts. While there is a large overlap with members, we have chosen to not link the two

*Ensembles* represent each of the ensembles in SFCMA, such as the Civic Symphony.

*PerformanceSets* represent a single set of rehersals and concerts where an ensemble plays the same music with the same group of musicians. Most Performance Sets in SFCMA ensembles have a eight rehearsals and a single concert, but that is not always the case.

*MemberSet* is the join table between members and the performance sets that they participate in. Additional data about the player's participation is stored in this table, except the instrument.

*SetMemberInstrument* is an additional table that records the instruments played by the member for a given performance set, since there can be more than one.

## Setup

1. Install Ruby 2.3.x or 2.4.x using RVM or rbenv
2. Install heroku cli, sqlite3, postgres, and imagemagick
3. `git clone https://github.com/sfcma/members.git .`
3. In that folder, run `ruby -v` and make sure it matches the correct version
3. `gem install bundler`
3. `bundle install`
3. Run `heroku git:remote -a limitless-sierra-92168` to set up correct remote repo
3. Output from `git remote -v` should look like this:
  heroku	https://git.heroku.com/limitless-sierra-92168.git (fetch)
  heroku	https://git.heroku.com/limitless-sierra-92168.git (push)
  origin	https://github.com/sfcma/members.git (fetch)
  origin	https://github.com/sfcma/members.git (push)
3. `ruby db:setup`
3. `ruby db:seed`
3. `rails s` to start server
3. Visit `http://locahost:3000`

