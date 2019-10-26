# Crystal Ball

A super simple crystal version manager for MacOS

## Installation

clone this repository and run:

`shards install && shards build --release --no-debug`

Then copy the binary onto your path e.g.

`cp bin/ball /usr/local/bin`

For this app to work you must have `/usr/local/bin` on your path.

[![asciicast](https://asciinema.org/a/277155.svg)](https://asciinema.org/a/277155)

## Usage

```bash

ball --show             # shows a list of install versions
ball --install 0.30.1   # installs and uses the specified version
ball --clean            # removes all installs and symlinks

```

## Contributing

1. Fork it (<https://github.com/your-github-user/ball/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Kingsley Hendrickse](https://github.com/kingsleyh) - creator and maintainer
