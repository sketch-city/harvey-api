The Harvey Needs API
====================

* We serve JSON data here, open and fresh
* We help client applications help those affeceted by Hurricane Harvey

Example Clients:

* https://sketch-city.github.io/harvey-needs/
* https://www.texasrescuemap.com/muckmap
* https://www.texasrescuemap.com
* SMS Shelter Finder at http://harveyneeds.org/
* http://oneclickrelief.com/

Developer Links
-----

* [API DOCUMENTATION](https://api.harveyneeds.org/api-docs)
* [CONTRIBUTORS](https://api.harveyneeds.org/contributors.html)
* [LICENSE](#license)
* [CODE OF CONDUCT](CODE_OF_CONDUCT.md)


API
----

### Overall

* URI: https://api.harveyneeds.org
* Namespaced and versioned: `/api/v1`

* Sample API for list of all shelters: https://api.harveyneeds.org/api/v1/shelters
* Sample API for list of all shelters accepting people: https://api.harveyneeds.org/api/v1/shelters?accepting=true

### Speeding up results

You can use the `If-Modified-Since` header to check if there are any new results since that timestamp. If there are no new results, you'll receive a `304 NOT MODIFIED`.

```
GET /api/v1/shelters HTTP/1.1
Host: api.harveyneeds.org
If-Modified-Since: Mon, 11 Sep 2017 21:23:03 -0000
```

The format for the date timestamp is rfc2822, though you can use any HTTP approved format.

* With Moment.js: `moment.utc().format("ddd, MM MMM YYYY HH:mm:ss [GMT]");`
* With Rails: `Time.now.utc.rfc2822`

###  Documentation

* https://api.harveyneeds.org/api-docs


Getting Started (Dev)
-------
#### Prequisites
* Ruby 2.4.1
* Rails 5.1.

#### User Administration
In `rails console` you'll want to create an admin user:

```
User.create! email: "youremail@example.com", password: "yourpassword", admin: true
```

#### Fork Repository and clone to local machine
##### Fork Repository
* Prequisites
  * A github account and a repository into which to fork other repositories
* Steps
  1. Navigate in a browser to https://github.com/sketch-city/harvey-api
  2. Click the Fork button in the upper right of the screenshot_create-service-account-key
  3. If prompted choose into where you want to form (e.g., if you are a member of multiple github repositories)
  4. You'll now have a forked version - your own version - of the repository.
  5. Go to "Clone or download" button on right of screen and copy that URL. It will be of the format `git clone git@github.com:<YOUR OWN GITHUB REPOSITORY>/harvey-api.git`

##### Clone Fork to local box
* In the directory on your local box in which you plan to work run: `git clone git@github.com:<YOUR OWN GITHUB REPOSITORY>/harvey-api.git`

#### Setting up your .env file

* GOOGLE_GEOCODER_API_KEY = Geocoding with Google Maps API, get
  [one](https://console.developers.google.com/flows/enableapi?apiid=geocoding_backend&keyType=SERVER_SIDE)
* AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY = Product Advertising API, see
  below

Note: this is optional; currently only needed to fetch new Amazon products from
the Amazon Product Advertising API

You'll need to set the following ENV variables in a .env file

1. Make a working copy of .env by runng this command at the terminal: `cp .env.sample .env`
2. Get Amazon AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY from Amazon's IAM. You'll need to create a PolicyName. You can name it "ProductAdvertisingAPI" with the following policy:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ProductAdvertisingAPI:*",
            "Resource": "*"
        }
    ]
}
```

#### Creating a local database
* Prerequisites
  * PostgreSQL is installed and running on your local machine
* Method 1: Automatic
  * Run `rails db:setup`
* Method 2: Manual
  * Create a postgres users
    It's recommended though optional that you use a distinct user for the harvey-api database
    * Example `createuser harvey-api_development -P`
    The `-P` flag will prompt you to create a password for the new user
  * Create the database (with the owner of the database set to user just created in the last step)
    * Example `createdb -O harvey-api_development harvey-api_development`
* Run rails migrate to create schema
  * `rails db:migrate`
* Import needs and shelters data from the production API:
  * `rails api:import`
  Sample output if successful
  ```
    Starting ImportSheltersJob 2017-09-03 18:33:03 +0000
    ImportSheltersJob Complete - {285}
    Starting ImportNeedsJob 2017-09-03 18:33:05 +0000
    ImportNeedsJob Complete - {92}
  ```

* Test the API itself (Run API locally)
  * Example `rails server `
  Screenshot of Success:
  ![Screenshot](/public/images/readme/screenshot_rails_server_run_test.png)

#### About the data import job
* You can load Amazon Products by seeding your database: `rails db:seed` (or doing a full import `rails amazon:import`)
The `ActiveJob`s and associated Rake task `rails api:import`, which imports data for shelters and needs from the production API into the application database, is intended for use in development and test environments only.

**DO NOT RUN THIS JOB IN PRODUCTION.** Since this job pulls data from the production API, running it in production can only be counter-productive, and would likely be destructive.

Development Process
-------
#### Tests and Testing
Code should have tests, and any pull requests should be made only after you've made sure passes the test suite

#### Git and Github use
We force pull-requests from feature branches to master. Once something lands in master, it goes live instantly

##### Keeping your fork in sync
* `git remote add upstream git@github.com:sketch-city/harvey-api.git`
* `git fetch upstream`

#### Branching
Within your own forked repo create branches for each logical unit for work you do. One benefit of doing this is you'll be able to periodically sync your forked repo with upstream repo into the master branch without conflicting with work you may be doing.

#### Pull Requests
When you believe your code is ready to be merged into the upstream repository (sketch-city/harvey-api) by creating a pull request. Do this by
* In github click the "Compare & pull request" button that github will present to you once you've committed changes to local repo
* Describe what you changed and why; reference the issue(s) if any that your work addresses

##### More Information and Further Reading
* More information about keeping your fork in sync with the upstream repository may be found at https://help.github.com/articles/syncing-a-fork/
* More information about branching can be found at https://git-scm.com/book/id/v2/Git-Branching-Branches-in-a-Nutshell


Documentation Standards
-------
### Inline Comment Style
(Coming Soon)

### Markdown
Documentation such as READMEs (e.g., this document) are written in markdown per the [Github standard] (https://guides.github.com/features/mastering-markdown/)


Design Choices
-------------

* Hosted on Heroku with PostGres
* Uses ActiveJob (currently with sucker_punch)
* MiniTest with Rails system tests

Thanks To:
---------

Source Code Collaborators can be viewed: https://api.harveyneeds.org/contributors.html

But the API wouldn't mean anything without our volunteers:

* [Entire Sketch-City organization](http://sketchcity.org/)
* [Code for America](https://www.codeforamerica.org/)


Appendix
---------
### Developer Resources
* [Mastering Markdown](https://guides.github.com/features/mastering-markdown)


### Errors you may get and what they mean

* "PG::ConnectionBad"
Looks like:
```rails aborted!
PG::ConnectionBad: could not connect to server: No such file or directory
	Is the server running locally and accepting
	connections on Unix domain socket "/tmp/.s.PGSQL.5432"?
```
Postgres is not running OR there is a connection problem to the database.


# LICENSE

### Software Code

This system's software code is licensed under the GPLv3.

Full license availabe in [LICENSE](LICENSE)

### Data and Content

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img
alt="Creative Commons License" style="border-width:0"
src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This
work is licensed under a <a rel="license"
href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons
Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
