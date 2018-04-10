#!/usr/bin/env bats

load ../bats-assertion

@test "assert_lines_equal <expected> <line> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "abc" 0

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "def" 1

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "ghi" 2

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "ghi" -1

  [ "$status" -eq 0 ]

}

@test "assert_lines_equal <expected> <line> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "cba" 0

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: cba
Actual  : abc
Index   : 0
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "fed" 1

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: fed
Actual  : def
Index   : 1
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "igh" 2

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: igh
Actual  : ghi
Index   : 2
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "igh" -1

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: igh
Actual  : ghi
Index   : -1
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_lines_equal <expected> <reserved word> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "abc" "first"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "ghi" "last"

  [ "$status" -eq 0 ]

}

@test "assert_lines_equal <expected> <reserved word> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "cba" "first"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: cba
Actual  : abc
Index   : 0
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "igh" "last"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: igh
Actual  : ghi
Index   : 2
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_lines_equal <expected> <line> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "cba" 0

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "fed" 1

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "ihg" 2

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "ihg" -1

  [ "$status" -eq 0 ]

}

@test "assert_fail_lines_equal <expected> <line> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "abc" 0

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: abc
Actual    : abc
Index     : 0
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "def" 1

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: def
Actual    : def
Index     : 1
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "ghi" 2

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ghi
Actual    : ghi
Index     : 2
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "ghi" -1

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ghi
Actual    : ghi
Index     : -1
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_lines_equal <expected> <reserved word> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "cba" "first"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "ihg" "last"

  [ "$status" -eq 0 ]

}

@test "assert_fail_lines_equal <expected> <reserved word> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "abc" "first"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: abc
Actual    : abc
Index     : 0
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "ghi" "last"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ghi
Actual    : ghi
Index     : 2
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_lines_equal <expected>, using \$lines as <actual> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "abc"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "def"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "ghi"

  [ "$status" -eq 0 ]

}

@test "assert_lines_equal <expected>, using \$lines as <actual> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "cba"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: cba
Actual  : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "fed"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: fed
Actual  : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "igh"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: igh
Actual  : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_lines_equal <expected>, using \$lines as <actual> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "cba"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "fed"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "ihg"

  [ "$status" -eq 0 ]

}

@test "assert_fail_lines_equal <expected>, using \$lines as <actual> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "abc"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: abc
Actual    : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "def"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: def
Actual    : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_equal "ghi"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ghi
Actual    : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "out of \$lines" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_equal "" 3

  [ "$status" -eq 0 ]

  local expected="$(cat <<EXPECTED

EXPECTED
)"

  [ "$output" = "$expected" ]

}
