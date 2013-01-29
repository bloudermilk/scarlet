# Scarlet

Scarlet is a JavaScript library written in CoffeeScript that attempts to
determine whether a user has visited a website by loading the favicon
for the website's domain and checking if the favicon was returned from the
browser's cache. In this way, the favicon acts as a sort of [Scarlet
Letter][book].

[book]: http://en.wikipedia.org/wiki/The_Scarlet_Letter

## Table of Contents

* [Basic usage](#basic-usage)
* [How it works](#how-it-works)
* [Caveats](#caveats)

## Basic usage

Using Scarlet is as simple as loading the library in a webpage and calling
`Scarlet.check` with the domain in question.

```javascript
Scarlet.check("a-site-ive-been-to.com") // => true
Scarlet.check("news.ycombinator.com") // => false
Scarlet.check("an-unsupported-site.com") // => null
```

Scarlet returns `true` if it determines that the browser has previously
visited the domain, `false` if it determines that the browser has not, and
`null` if it can't tell.

## How it works

Scarlet exploits the fact that most browsers cache Favicons for recently
visited websites. To take advantage of this Scarlet loads the favicons of
*two* websites in parallel: the website being tested and the website running
Scarlet. The local favicon is loaded twice to ensure a cache hit (**this
requires caching to be properly configured on the server**) and the response
time of the cached request is recorded. The third party favicon loaded only
once at first. If the response time is within a certain threshold relative to
the known cache response time, Scarlet reports a positive test. If the
threshold is broken, Scarlet will then load the favicon again to ensure the
third party server supports caching before reporting a negative test.
