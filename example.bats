#!/usr/bin/env bats

load bats-assertion

@test "assert_status" {
  run bash -c 'exit 0'
  assert_status 0

  run bash -c 'exit 1'
  assert_status 1

  run bash -c 'exit 123'
  assert_status 123
}

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

@test "assert_equal <expected> <actual>" {
  run bash -c 'echo "abc"'
  assert_equal "abc" "abc"
}

@test "assert_match <expected> <actual>" {
  run bash -c 'echo "abc"'
  assert_match "ab" "abc"

  # regular expression matching
  run assert_match "^ab"
  run assert_match "bc$"
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
