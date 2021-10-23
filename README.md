# Crystal Ball

[![macOS CI](https://github.com/kingsleyh/ball/actions/workflows/macos-ci.yml/badge.svg)](https://github.com/kingsleyh/ball/actions/workflows/macos-ci.yml)

A super simple crystal version manager for MacOS

**NOTE** The latest version only works for the universal packages which are crystal releases after 1.1.1

## Requirements

You will need openssl 1.1 - the easiest way is to:

```bash
brew update
brew install openssl@1.1
echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"' >> ~/.bash_profile
# Verify 
openssl version
```

## Installation

#### Quick Version

download the `ball` binary

`curl -fsSL https://github.com/kingsleyh/ball/releases/download/v0.1.3/ball-v0.1.3 > ball`

set executable permissions and put on your path

`chmod +x ./ball && cp ./ball /usr/local/bin`

#### Longer Version

clone this repository and run:

`shards install && shards build --release --no-debug`

Then copy the binary onto your path e.g.

`cp bin/ball /usr/local/bin`

For this app to work you must have `/usr/local/bin` on your path. The native crystal installer uses this path so it's convenient to follow the same pattern. 

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
