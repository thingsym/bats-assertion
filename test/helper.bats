#!/usr/bin/env bats

load ../bats-assertion

@test "_get_actual_output" {
  run bash -c 'echo "abc"'
  run _get_actual_output

  [ "$status" -eq 0 ]

  run _get_actual_output "abc"

  [ "$status" -eq 0 ]

}

@test "_get_actual_line_output" {
  run bash -c 'echo -e "abc\ndef\nghi"'
  run _get_actual_line_output 0

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run _get_actual_line_output 1

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run _get_actual_line_output "first"

  [ "$status" -eq 0 ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run _get_actual_line_output "last"

  [ "$status" -eq 0 ]

}

@test "_dump" {
  run bash -c 'echo "abc"'
  run _dump "abc"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
---- Dumper START ----
abc
---- Dumper END ----
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo "abc"'
  run _dump

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
---- Dumper START ----
abc
status : 0
---- Dumper END ----
EXPECTED
)"

  [ "$output" = "$expected" ]

}

@test "_dump - multi-line format" {
  run _dump "$(cat <<ACTUAL
abc
def
ghi
ACTUAL
)"

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
---- Dumper START ----
abc
def
ghi
---- Dumper END ----
EXPECTED
)"

  [ "$output" = "$expected" ]

  run bash -c 'echo -e "abc\ndef\nghi"'
  run _dump

  [ "$status" -eq 1 ]

  local expected="$(cat <<EXPECTED
---- Dumper START ----
abc
def
ghi
status : 0
---- Dumper END ----
EXPECTED
)"

  [ "$output" = "$expected" ]

}
