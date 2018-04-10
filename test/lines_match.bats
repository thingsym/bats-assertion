#!/usr/bin/env bats

load ../bats-assertion

@test "assert_lines_match <expected> <line> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "ab" 0

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "de" 1

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "gh" 2

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "gh" -1

  [ "$status" -eq 0 ]

}

@test "assert_lines_match <expected> <line> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "cb" 0

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: cb
Actual  : abc
Index   : 0
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "fe" 1

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: fe
Actual  : def
Index   : 1
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "ig" 2

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ig
Actual  : ghi
Index   : 2
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "ig" -1

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ig
Actual  : ghi
Index   : -1
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_lines_match <expected> <reserved word> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "ab" "first"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "gh" "last"

  [ "$status" -eq 0 ]

}

@test "assert_lines_match <expected> <reserved word> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "cb" "first"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: cb
Actual  : abc
Index   : 0
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "ig" "last"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ig
Actual  : ghi
Index   : 2
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_lines_match <expected> <line> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "cb" 0

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "fe" 1

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "ih" 2

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "ih" -1

  [ "$status" -eq 0 ]

}

@test "assert_fail_lines_match <expected> <line> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "ab" 0

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ab
Actual    : abc
Index     : 0
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "de" 1

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: de
Actual    : def
Index     : 1
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "gh" 2

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: gh
Actual    : ghi
Index     : 2
EXPECTED
)"

  [ "$output" = "$expected" ]


  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "gh" -1

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: gh
Actual    : ghi
Index     : -1
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_lines_match <expected> <reserved word> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "cb" "first"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "ih" "last"

  [ "$status" -eq 0 ]

}

@test "assert_fail_lines_match <expected> <reserved word> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "ab" "first"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ab
Actual    : abc
Index     : 0
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "gh" "last"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: gh
Actual    : ghi
Index     : 2
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_lines_match <expected>, using \$lines as <actual> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "ab"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "de"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "gh"

  [ "$status" -eq 0 ]

}

@test "assert_lines_match <expected>, using \$lines as <actual> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "cb"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: cb
Actual  : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "fe"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: fe
Actual  : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "ig"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ig
Actual  : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_lines_match <expected>, using \$lines as <actual> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "cb"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "fe"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "ih"

  [ "$status" -eq 0 ]

}

@test "assert_fail_lines_match <expected>, using \$lines as <actual> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "ab"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ab
Actual    : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "de"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: de
Actual    : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "gh"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: gh
Actual    : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_lines_match <expected> <line>, using regex match - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "^ab" 0

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "hi$" 2

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "^[sfd][aec][emf]$" 1

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "^[sfd][aec][emf]$" -2

  [ "$status" -eq 0 ]

}

@test "assert_lines_match <expected> <line>, using regex match - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "^cb" 0

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ^cb
Actual  : abc
Index   : 0
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "ig$" 2

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ig$
Actual  : ghi
Index   : 2
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "^[sfa][aqc][emn]$" 1

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ^[sfa][aqc][emn]$
Actual  : def
Index   : 1
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "^[sfa][aqc][emn]$" -2

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ^[sfa][aqc][emn]$
Actual  : def
Index   : -2
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_lines_match <expected> <line>, using regex match - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "^cb" 0

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "ih$" 2

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "^[sfa][aqc][emn]$" 1

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "^[sfa][aqc][emn]$" -2

  [ "$status" -eq 0 ]

}

@test "assert_fail_lines_match <expected> <line>, using regex match - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "^ab" 0

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ^ab
Actual    : abc
Index     : 0
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "hi$" 2

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: hi$
Actual    : ghi
Index     : 2
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "^[sfd][aec][emf]$" 1

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ^[sfd][aec][emf]$
Actual    : def
Index     : 1
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "^[sfd][aec][emf]$" -2

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ^[sfd][aec][emf]$
Actual    : def
Index     : -2
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_lines_match <expected>, using regex match and \$lines as <actual> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "^ab"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "hi$"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "^[sfd][aec][emf]$"

  [ "$status" -eq 0 ]

}

@test "assert_lines_match <expected>, using regex match and \$lines as <actual> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "^cb"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ^cb
Actual  : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "ig$"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ig$
Actual  : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_lines_match "^[sfa][aqc][emn]$"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: ^[sfa][aqc][emn]$
Actual  : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_fail_lines_match <expected>, using regex match and \$lines as <actual> - return 0 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "^cb"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "ih$"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "^[sfa][aqc][emn]$"

  [ "$status" -eq 0 ]

}

@test "assert_fail_lines_match <expected>, using regex match and \$lines as <actual> - return 1 exit code" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "^ab"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ^ab
Actual    : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "hi$"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: hi$
Actual    : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run assert_fail_lines_match "^[sfd][aec][emf]$"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Unexpected: ^[sfd][aec][emf]$
Actual    : abc
def
ghi
EXPECTED
)"

  [ "$output" = "$expected" ]

}
