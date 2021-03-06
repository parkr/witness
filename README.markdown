# witness

Log chat messages from any chat room and display them neatly

**If you're interested in an API-only version of this, I have one called [gossip, written in Go](https://github.com/parkr/gossip).**

## Installation

    $ git clone git://github.com/parkr/witness.git
    $ cd witness
    $ # write configuration files based on samples in config/
    $ mkdir public; mkdir tmp # if they don't exist
    $ bundle install
    $ touch tmp/restart.txt

You're rearing to go!

## Usage

Send HTTP POST requests to `/api/messages/log` with the following JSON-encoded data:

    {
        room: <room-name>,
        author: <author>,
        message: <message>,
        time: <time-message-was-sent>
    }

To fetch the latest messages in JSON, send an HTTP GET request to `/api/messages/latest`.
You can optionally provide a `limit` value in the GET query string.

All requests to the API must be sent with an `access_token`, which must be included in
`config/auth.yml` on the server. If the access token is not there, the requesting service
will receive a 403 Forbidden response.

## Hubot as Stenographer

Hubot is an amazing thing, and is particularly well-suited for use with this project.
Hubot can "listen" to what it hears and act based on what it hears. Luckily for us,
this hearing is not tied to any term or terms, so we can instruct Hubot to take everything
it hears and do something with the message.

I created [a stripped-down Hubot](https://github.com/parkr/stenographer), lovingly nick-named
"stenographer", which sends the appropriate HTTP POST request to Witness's `/api/messages/log`
endpoint with each message it hears. Clone it, set a couple environment variables and push
it up to Heroku and voilà!

## Contribute

    $ # fork on github
    $ git clone git@github.com:<your-username>/witness.git
    $ bundle install
    $ git checkout -b <my-new-feature-name>
    $ bundle exec rake preview
    $ # edit you files, making sure to restart the server every time you edit a Ruby file
    $ git add <files-you-edited>
    $ git commit -m "<a-short-commit-message>"
    $ git push origin <my-new-feature-name>
    $ # submit a pull request on GitHub to https://github.com/parkr/witness

## License

    The MIT License (MIT)

    Copyright (c) 2013 [Parker Moore](http://parkermoore.de)

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
