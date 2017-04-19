## To Run

    $ cp .env.example .env # update values as needed
    $ bundle install
    $ bundle exec foreman start

## SSH Tunnel

    $ ssh -N deploy@venkman -R 9292:0.0.0.0:3000
