test_log() {
  echo ">>> $*" >&3
}

test_pause() {
  echo ">>> $BATS_TEST_TMPDIR" >&3
  read -er
}
