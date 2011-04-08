###Demo

http://chirp.cantl.in (will chug a bit if Passenger hasn't loaded the environment or I forgot to start memcached)

###Notes

There are a lot of things wrong with this app. The pagination is lazy, it doesn't allow for being rate limited, it doesn't request anything asynchronously, it (probably) doesn't work in IE (or with Javascript off), it has no test coverage, and it contains only limited support for locale=pirate. That said, it is written in the spirit of the prior Javascript challenge, i.e. that the main idea is to put code in the right places, not to supplant Twitter via its own API and _sheer blazing performance_.

I welcome any feedback at all, especially on Ruby syntax. Please forgive the vomit-inducing hack for "dismissed" notifications. It was a blast getting into Rails, and I certainly won't stop here.

Cheers,

Cantlin