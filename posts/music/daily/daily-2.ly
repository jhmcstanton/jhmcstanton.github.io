\version "2.20.0"
\header {
  title = "20201016"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}
melody = \relative {
  \key cis \major
  \time 7/8
  cis''8 gis' cis gis eis cis'4     cis8 bis cis ais cis gis bis,
  cis gis' eis cis gis fis bis     cis1
}
lowerchords = \chordmode {
  \clef bass
  \key cis \major
  cis,2 ais,,2:min  ais,,4:min dis,4:min cis,2   dis,4:min gis,,4.:7 cis,1  
 }
\score {
    \new PianoStaff <<
    \set PianoStaff.instrumentName = "Piano"
    \set PianoStaff.midiInstrument = "acoustic grand"
    \new Staff = "upper" \melody
    \new Staff = "lower" \lowerchords
    >>
  \layout {}
  \midi {}
}