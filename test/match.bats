#!/usr/bin/env bats

load ../bats-assertion

@test "assert_match <expected>, using \$output as <actual> - return 0 exit code" {
  run bash -c 'echo "abc"'
  run assert_match "ab"

  [ "$status" -eq 0 ]

}

@test "assert_match <expected>, using \$output as <actual> - return 1 exit code" {
  run bash -c 'echo "abc"'
  run assert_match "cb"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: cb
Actual  : abc
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_match <expected> <actual> - return 0 exit code" {
  run bash -c 'echo "abc"'
  run assert_match "ab" "abc"

  [ "$status" -eq 0 ]

}

@test "assert_match <expected> <actual> - return 1 exit code" {
  run bash -c 'echo "abc"'
  run assert_match "cb" "abc"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: cb
Actual  : abc
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_match <expected>, using \$output as <actual> - multi-line format - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'

  run assert_match "$(cat <<EXPECTED
abc
def
EXPECTED
)"

  [ "$status" -eq 0 ]

}

@test "assert_match <expected>, using \$output as <actual> - multi-line format - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'

  run assert_match "$(cat <<EXPECTED
ihg
fed
EXPECTED
)"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ihg
fed
Actual  : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_match <expected> <actual> - multi-line format - return 0 exit code" {
  local actual="$(cat <<ACTUAL
abc
def
ghi
ACTUAL
)"

  run bash -c 'echo -e "$actual"'

  local expected="$(cat <<EXPECTED
abc
def
EXPECTED
)"

  run assert_match "$expected" "$actual"

  [ "$status" -eq 0 ]

}

@test "assert_match <expected> <actual> - multi-line format - return 1 exit code" {
  local actual="$(cat <<ACTUAL
abc
def
ghi
ACTUAL
)"

  run bash -c 'echo -e "$actual"'

  local expected="$(cat <<EXPECTED
ihg
fed
EXPECTED
)"

  run assert_match "$expected" "$actual"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ihg
fed
Actual  : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_match <expected>, using \$output as <actual> - return 0 exit code" {
  run bash -c 'echo "abc"'
  run assert_fail_match "cb"

  [ "$status" -eq 0 ]

}

@test "assert_fail_match <expected>, using \$output as <actual> - return 1 exit code" {
  run bash -c 'echo "abc"'
  run assert_fail_match "ab"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ab
Actual    : abc
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_match <expected> <actual> - return 0 exit code" {
  run bash -c 'echo "abc"'
  run assert_fail_match "cb" "abc"

  [ "$status" -eq 0 ]

}

@test "assert_fail_match <expected> <actual> - return 1 exit code" {
  run bash -c 'echo "abc"'
  run assert_fail_match "ab" "abc"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ab
Actual    : abc
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_match <expected>, using \$output as <actual> - multi-line format - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'

  local expected="$(cat <<EXPECTED
ihg
fed
EXPECTED
)"

  run assert_fail_match "$expected"

  [ "$status" -eq 0 ]

}

@test "assert_fail_match <expected>, using \$output as <actual> - multi-line format - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'

  local expected="$(cat <<EXPECTED
abc
def
EXPECTED
)"

  run assert_fail_match "$expected"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: abc
def
Actual    : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_match <expected> <actual> - multi-line format - return 0 exit code" {
  local actual="$(cat <<ACTUAL
ihg
fed
cba
ACTUAL
)"

  run bash -c 'echo -e "$actual"'

  local expected="$(cat <<EXPECTED
abc
def
EXPECTED
)"

  run assert_fail_match "$expected" "$actual"

  [ "$status" -eq 0 ]

}

@test "assert_fail_match <expected> <actual> - multi-line format - return 1 exit code" {
  local actual="$(cat <<ACTUAL
abc
def
ghi
ACTUAL
)"

  run bash -c 'echo -e "$actual"'

  local expected="$(cat <<EXPECTED
abc
def
EXPECTED
)"

  run assert_fail_match "$expected" "$actual"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: abc
def
Actual    : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_match <expected>, using regex match and \$output as <actual> - return 0 exit code" {
  run bash -c 'echo "abc"'
  run assert_match "^ab"

  [ "$status" -eq 0 ]

  run bash -c 'echo "abc"'
  run assert_match "bc$"

  [ "$status" -eq 0 ]

}

@test "assert_match <expected>, using regex match and \$output as <actual> - return 1 exit code" {
  run bash -c 'echo "abc"'
  run assert_match "cb$"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: cb$
Actual  : abc
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_match <expected> <actual>, using regex match - return 0 exit code" {
  run bash -c 'echo "abc"'
  run assert_match "^ab" "abc"

  [ "$status" -eq 0 ]

  run bash -c 'echo "abc"'
  run assert_match "bc$" "abc"

  [ "$status" -eq 0 ]

}

@test "assert_match <expected> <actual>, using regex match - return 1 exit code" {
  run bash -c 'echo "abc"'
  run assert_match "cb$" "abc"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: cb$
Actual  : abc
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_match <expected>, using regex match and \$output as <actual> - return 0 exit code" {
  run bash -c 'echo "abc"'
  run assert_fail_match "^cb"

  [ "$status" -eq 0 ]

}

@test "assert_fail_match <expected>, using regex match and \$output as <actual> - return 1 exit code" {
  run bash -c 'echo "abc"'
  run assert_fail_match "^ab"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ^ab
Actual    : abc
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_match <expected> <actual>, using regex match - return 0 exit code" {
  run bash -c 'echo "abc"'
  run assert_fail_match "^cb" "abc"

  [ "$status" -eq 0 ]

}

@test "assert_fail_match <expected> <actual>, using regex match - return 1 exit code" {
  run bash -c 'echo "abc"'
  run assert_fail_match "^ab" "abc"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ^ab
Actual    : abc
EXPECTED
)"

  [ "$output" = "$expected" ]

}
