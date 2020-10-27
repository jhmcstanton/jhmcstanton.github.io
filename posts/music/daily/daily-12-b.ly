\version "2.20.0"
\header {
  title = "Harmonizing in A Minor"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piece = \relative {
  \key a \minor
  \time 6/8
  b''8 b b g g g e g e c c4
  g' e8 d c4 a' f8 d b4
  d8 b4 d16 b g8 c
 
  b'8 b b g g g e g e c c4
  b'8 b16 d b8  g f e
  c' a c16 e c8 b a
  d,16 e f8 d'16 b g8 e c
 
  b'8 b b g g g e g e c c4
  e16 g16 e8 c16 e c8 a f
  f'16 d b8 d c b g
  d'16 b g8 f' e c g~ g4
 
 
  e'8~ <e g>~ <e g b>~ <e g b d>~ <e g b d>2.
  %<e' g b>2
}

lowerchords = \relative {
  \key a \minor
  \clef bass
  \time 6/8
  \repeat unfold 3 \chordmode {
    a,,4:m a,,:m a,,:m a,,:m a,,:m a,,:m
    f,,2. g,, c,,4 a,,2:m
  }
  \chordmode { a,,2.:m~ a,,2.:m }
}


\score {
 
  \new PianoStaff <<
    \set PianoStaff.instrumentName = "Piano"
    \set PianoStaff.midiInstrument = "acoustic grand"
    \new Staff = "upper" \piece
    <<
      \new ChordNames \lowerchords
    \new Staff = "lower" \lowerchords
    >>
  >>
  \layout {}
  \midi { \tempo 4 = 120 }
}