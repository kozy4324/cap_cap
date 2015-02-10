# CapCap

(Cap)ture web pages by using (Cap)ybara and Poltergeist.

## Installing PhantomJS

You need PhantomJS. Please see [installation guide](https://github.com/teampoltergeist/poltergeist/blob/master/README.md#installing-phantomjs) on README of Poltergeist.

## Installation

```
$ gem install cap_cap
```

## Usage

```
$ capcap 
Usage: capcap [options] <url> [<url>...]
    -o, --output=VAL                 Output capturing image to specific path. If ommited, output to tempfile.
    -s, --selector=VAL               Capture only element specified by css selector. If ommited, capture entire page.
    -H, --header=VAL                 Add extra HTTP-header to use when getting a web page.
        --size=VAL                   Specify rendering page size. If ommited, it may be default size. e.g., `--size 320x480`
        --open                       If specified, invoke `open` command to preview captured image.
```

## Dependency gems

- [Capybara](https://github.com/jnicklas/capybara)
- [Poltergeist](https://github.com/teampoltergeist/poltergeist)

## Contributing

1. Fork it ( https://github.com/kozy4324/cap_cap/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
