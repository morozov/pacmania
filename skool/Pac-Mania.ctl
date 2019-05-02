i $4000 Loading screen
c $5EEC Loader
  $5EED LD A,0
  $5EEE BORDER 0
  $5EF0 Disable cursor
  $5EF3, Move stack out of the data range
  $5EF6,12 Fill screen with black
  $5F02,10 Load screen data in #8000
  $5F0C,11 Display screen
  $5F17,10 Load game data
  $5F26 Detect if there's 128K
  $5F47 Tape loading routine
  $5F56 Detects if there's 128K
i $5F77
