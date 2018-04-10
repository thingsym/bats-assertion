#!/usr/bin/env bats

load ../bats-assertion

@test "assert_equal <expected>, using \$output as <actual> - return 0 exit code" {
  run bash -c 'echo "abc"'
  run assert_equal "abc"

  [ "$status" -eq 0 ]

}

@test "assert_equal <expected>, using \$output as <actual> - return 1 exit code" {
  run bash -c 'echo "abc"'
  run assert_equal "cba"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: cba
Actual  : abc
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_equal <expected> <actual> - return 0 exit code" {
  run bash -c 'echo "abc"'
  run assert_equal "abc" "abc"

  [ "$status" -eq 0 ]

}

@test "assert_equal <expected> <actual> - return 1 exit code" {
  run bash -c 'echo "abc"'
  run assert_equal "cba" "abc"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: cba
Actual  : abc
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_equal <expected>, using \$output as <actual> - multi-line format - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'

  local expected="$(cat <<EXPECTED
abc
def
ghi
EXPECTED
)"

  run assert_equal "$expected"

  [ "$status" -eq 0 ]

}

@test "assert_equal <expected>, using \$output as <actual> - multi-line format - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'

  local expected="$(cat <<EXPECTED
ihg
fed
cba
EXPECTED
)"

  run assert_equal "$expected"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ihg
fed
cba
Actual  : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_equal <expected> <actual> - multi-line format - return 0 exit code" {
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
ghi
EXPECTED
)"

  run assert_equal "$expected" "$actual"

  [ "$status" -eq 0 ]

}

@test "assert_equal <expected> <actual> - multi-line format - return 1 exit code" {
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
cba
EXPECTED
)"

  run assert_equal "$expected" "$actual"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ihg
fed
cba
Actual  : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_equal <expected>, using \$output as <actual> - return 0 exit code" {
  run bash -c 'echo "abc"'
  run assert_fail_equal "cba"

  [ "$status" -eq 0 ]

}

@test "assert_fail_equal <expected>, using \$output as <actual> - return 1 exit code" {
  run bash -c 'echo "abc"'
  run assert_fail_equal "abc"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: abc
Actual    : abc
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_equal <expected> <actual> - return 0 exit code" {
  run bash -c 'echo "abc"'
  run assert_fail_equal "cba" "abc"

  [ "$status" -eq 0 ]

}

@test "assert_fail_equal <expected> <actual> - return 1 exit code" {
  run bash -c 'echo "abc"'
  run assert_fail_equal "abc" "abc"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: abc
Actual    : abc
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_equal <expected>, using \$output as <actual> - multi-line format - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'

  local expected="$(cat <<EXPECTED
ihg
fed
cba
EXPECTED
)"

  run assert_fail_equal "$expected"

  [ "$status" -eq 0 ]

}

@test "assert_fail_equal <expected>, using \$output as <actual> - multi-line format - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'

  local expected="$(cat <<EXPECTED
abc
def
ghi
EXPECTED
)"

  run assert_fail_equal "$expected"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: abc
def
ghi
Actual    : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_equal <expected> <actual> - multi-line format - return 0 exit code" {
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
ghi
EXPECTED
)"

  run assert_fail_equal "$expected" "$actual"

  [ "$status" -eq 0 ]

}

@test "assert_fail_equal <expected> <actual> - multi-line format - return 1 exit code" {
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
ghi
EXPECTED
)"

  run assert_fail_equal "$expected" "$actual"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: abc
def
ghi
Actual    : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "out of \$output" {
  run assert_equal ""

  [ "$status" -eq 0 ]

  local expected="$(cat <<EXPECTED

EXPECTED
)"

  [ "$output" = "$expected" ]

}
