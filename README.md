# Cranium

An awesome ETL tool.

## Installation

Add this line to your application's Gemfile:

    gem 'cranium'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cranium

## Development

start up the db

    docker-compose create && docker-compose start
    
find out what's the ip is (in case you're using native docker)

    docker-compose ps 
    
(if using docker-machine use the machine's ip)
setup the DATABASE_HOST enviroment variable to this IP (192.168.64.4 in my case)
    
    export DATABASE_HOST=192.168.64.4
    
Now, your ready to run the integration tests :)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
