\version "2.20.0"
\header {
  title = "Melody in D Minor"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piece = \relative {
  \key d \minor
  \time 3/4
  f''8 d f d4. c8 d e d a d d4 f,8 a c4 c8 d4 f,8 a c8~
  c8 c8 d8 e4. f4 d8 bes c a
  c g bes g e4 g' g8 e c a e' c a g c4
  f8 d f d4.  f8 d f d4.  f8 d f d4.
  \chordmode { c'2.:7 }
}

lowerchords = \chordmode {
  \key d \minor
  \clef bass
  \time 3/4
  d,,1:min7 d,,1:min7 d,,1:min7
  f,,2.:maj7 f,,:maj7
  a,,:min7 a,,:min7 a,,:min7
  d,,:min7 d,,:min7 d,,:min7 d,,:min7
}

\score {
  \new PianoStaff <<
    \set PianoStaff.instrumentName = "Piano"
    \set PianoStaff.midiInstrument = "acoustic grand"
    \new Staff = "upper" \piece
    \new Staff = "lower" \lowerchords
  >>
  \layout {}
  \midi { \tempo 4 = 120 }
}
