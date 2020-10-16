\version "2.20.0"
\header {
  title = "20201015"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}
melody = \relative {
  \key e \phrygian
  e'4 g8 e g4 f8 a c b g4 b8 a f4 f a8 f a4 g8 b d d e e g d e d e1
}
lowerchords = \chordmode {
  \clef bass
  \key e \phrygian
  e,2:min e,2:min e,2:min g,2  g,2 b,2:dim e,2:min e,2:min e,1:min
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

