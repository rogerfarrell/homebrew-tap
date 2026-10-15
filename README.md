# rogerfarrell/homebrew-tap

Homebrew formulae for my own tools.

## Install

```sh
brew install rogerfarrell/tap/book-mockup
```

`brew install` adds the tap automatically. Homebrew asks you to trust
formulae from third-party taps; to trust this one explicitly:

```sh
brew trust --formula rogerfarrell/tap/book-mockup
```

To build the latest commit instead of the last release:

```sh
brew install --HEAD rogerfarrell/tap/book-mockup
```

## Formulae

| Formula | Description |
|---|---|
| [`book-mockup`](Formula/book-mockup.rb) | Render photographic mockups of upright books from flat cover artwork |
