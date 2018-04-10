# Bats Assertion

Bats Assertion is a helper script for [Bats](https://github.com/bats-core/bats-core/).

[![Build Status](https://travis-ci.org/thingsym/bats-assertion.svg?branch=master)](https://travis-ci.org/thingsym/bats-assertion)

## Example

```
#!/usr/bin/env bats

load bats-assertion

@test "assert_success" {
  run bash -c 'exit 0'
  assert_success
}

@test "assert_failure" {
  run bash -c 'exit 1'
  assert_failure

  run bash -c 'exit 123'
  assert_failure
}

@test "assert_status <status>" {
  run bash -c 'exit 0'
  assert_status 0

  run bash -c 'exit 1'
  assert_status 1

  run bash -c 'exit 123'
  assert_status 123
}

@test "assert_equal <expected> <actual>" {
  run bash -c 'echo "abc"'
  assert_equal "abc" "abc"
}

@test "assert_match <expected> <actual>" {
  run bash -c 'echo "abc"'
  assert_match "ab" "abc"

  # regular expression matching
  run assert_match "^ab" "abc"
  run assert_match "bc$" "abc"
}

@test "assert_lines_equal <expected> <line>" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  assert_lines_equal "abc" 0
  assert_lines_equal "def" 1
  assert_lines_equal "ghi" 2
  assert_lines_equal "ghi" -1
}

@test "assert_lines_match <expected> <line>" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  assert_lines_match "ab" 0
  assert_lines_match "de" 1
  assert_lines_match "gh" 2
  assert_lines_match "gh" -1

  # regular expression matching
  assert_lines_match "^ab" 0
  assert_lines_match "hi$" 2
  assert_lines_match "^[sfd][aec][emf]$" 1
  assert_lines_match "^[sfd][aec][emf]$" -2
}
```

### Failure output Example

```
✗ assert_status
  (from function `assert_status <status>' in file bats-assertion.bash, line 30,
  in test file sample.bats, line 7)
    `assert_status 1' failed
  Expected: 1
  Actual  : 0

✗ assert_equal <expected> <actual>
  (from function `assert_equal' in file bats-assertion.bash, line 40,
  in test file sample.bats, line 31)
    `assert_equal "cba" "abc"' failed
  Expected: cba
  Actual  : abc

✗ assert_lines_equal <expected> <line>
  (from function `assert_lines_equal' in file bats-assertion.bash, line 94,
  in test file sample.bats, line 45)
    `assert_lines_equal "abc" 1' failed
  Expected: abc
  Actual  : def
  Index   : 1
```

## Getting Started

### 1. Download Bats Assertion

```
git clone https://github.com/thingsym/bats-assertion
```

### 2. Import Bats Assertion in bats file

```
load bats-assertion/bats-assertion
```

### 3. Write tests using Bats Assertion

```
@test "assert_status" {
  run ./bin/foo
  assert_status 0
}
```

## Assertion Reference

### assert_success

Reports an error if `$status` is not 0.

```
assert_success
```

### assert_failure

Reports an error if `$status` is 0.

```
assert_failure
```

### assert_status

Reports an error if the two variables `<status>` and `$status` are not equal.

```
assert_status <status>
```

### assert_equal

Reports an error if the two variables `<expected>` and `<actual>` are not equal.

```
assert_equal <expected> <actual>
```

Using `$output` as `<actual>`

```
assert_equal <expected>
```


### assert_fail_equal

Reports an error if the two variables `<expected>` and `<actual>` are equal.

```
assert_fail_equal <expected> <actual>
```

Using `$output` as `<actual>`

```
assert_fail_equal <expected>
```

### assert_match

Reports an error if the two variables `<expected>` and `<actual>` are not match.

```
assert_match <expected> <actual>
```

Using `$output` as `<actual>`

```
assert_match <expected>
```

### assert_fail_match

Reports an error if the two variables `<expected>` and `<actual>` are match.

```
assert_fail_match <expected> <actual>
```

Using `$output` as `<actual>`

```
assert_fail_match <expected>
```

### assert_lines_equal

Reports an error if the two variables `<expected>` and the line of output in the `$lines` array passing the number of lines as a variable `<line>` are not equal.

```
assert_lines_equal <expected> <line>
```

### assert_fail_lines_equal

Reports an error if the two variables `<expected>` and the line of output in the `$lines` array passing the number of lines as a variable `<line>` are equal.

```
assert_fail_lines_equal <expected> <line>
```

Using reserved word, `first` and `last`

Assert the `first` line of `$lines` array.

```
assert_fail_lines_equal <expected> "first"
```

Assert the `last` line of `$lines` array.

```
assert_fail_lines_equal <expected> "last"
```

Assert all elements of `$lines` array.

```
assert_fail_lines_equal <expected>
```

### assert_lines_match

Reports an error if the two variables `<expected>` and the line of output in the `$lines` array passing the number of lines as a variable `<line>` are not match.

```
assert_lines_match <expected> <line>
```


Using reserved word, `first` and `last`

Assert the `first` line of `$lines` array.

```
assert_lines_match <expected> "first"
```

Assert the `last` line of `$lines` array.

```
assert_lines_match <expected> "last"
```

Assert all elements of `$lines` array.

```
assert_lines_match <expected>
```

### assert_fail_lines_match

Reports an error if the two variables `<expected>` and the line of output in the `$lines` array passing the number of lines as a variable `<line>` are match.

```
assert_fail_lines_match <expected> <line>
```

Using reserved word, `first` and `last`

Assert the `first` line of `$lines` array.

```
assert_fail_lines_match <expected> "first"
```

Assert the `last` line of `$lines` array.

```
assert_fail_lines_match <expected> "last"
```

Assert all elements of `$lines` array.

```
assert_fail_lines_match <expected>
```

## Helper

### _dump

Dumps information about a variable.

```
_dump <variable>
```

Using `$output` as `<variable>`

```
_dump
```

## Contribution

### Patches and Bug Fixes

Small patches and bug reports can be submitted a issue tracker in Github. Forking on Github is another good way. You can send a pull request.

1. Fork [Bats Assertion](https://github.com/thingsym/bats-assertion) from GitHub repository
2. Create a feature branch: git checkout -b my-new-feature
3. Commit your changes: git commit -am 'Add some feature'
4. Push to the branch: git push origin my-new-feature
5. Create new Pull Request

## Changelog

* Version 0.1.0
  * Initial release.

## License

Licensed under the MIT License.

## Author

[thingsym](https://github.com/thingsym)

Copyright (c) 2018 thingsym
