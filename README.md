#Mini Chatter

Minimalistic real-time chat application (merely 100 lines of code) using only [Ruby](https://www.ruby-lang.org/en/), [Rack](http://rack.github.io/) and [Faye](http://faye.jcoglan.com/). Not for use, just as a basic concept. There is also an exact same application using [Websocket-Rack](https://github.com/imanel/websocket-rack) over [here](https://github.com/DamirSvrtan/mini-chatter).

#Screenshot:
![alt text](http://oi60.tinypic.com/2n7mn15.jpg "Chatter index")

#Usage:

```ruby
git clone git@github.com:DamirSvrtan/mini-chatter-faye.git
cd mini-chatter-faye
bundle install
rackup -s thin -E production config.ru
```
