#!/usr/bin/env bats

load ../bats-assertion

@test "assert_status - return 0 exit code" {
  run bash -c 'exit 0'
  run assert_status 0

  [ "$status" -eq 0 ]

  run bash -c 'exit 1'
  run assert_status 1

  [ "$status" -eq 0 ]

  run bash -c 'exit 123'
  run assert_status 123

  [ "$status" -eq 0 ]

}

@test "assert_status - return 1 exit code" {
  run bash -c 'exit 1'
  run assert_status 0

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: 0
Actual  : 1
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'exit 123'
  run assert_status 0

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: 0
Actual  : 123
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_success - return 0 exit code" {
  run bash -c 'exit 0'
  run assert_success

  [ "$status" -eq 0 ]

}

@test "assert_success - return 1 exit code" {
  run bash -c 'exit 1'
  run assert_success

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: 0
Actual  : 1
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "assert_failure - return 0 exit code" {
  run bash -c 'exit 1'
  run assert_failure

  [ "$status" -eq 0 ]

}

@test "assert_failure - return 1 exit code" {
  run bash -c 'exit 0'
  run assert_failure

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
Expected: non-zero exit code
Actual  : 0
EXPECTED
)"

  [ "$output" = "$expected" ]

}
