\version "2.20.0"
\header {
  title = "Simple Folk"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piece = \relative {
  \key g \major
  \time 4/4
  g' g e8 e g4 a8 a d4 a2
  d4 b b8 d b4    b8 d b4 g2 \break
  g4 g e8 e g4 a8 a d4 a2
  b4 g g8 b g4    b8 d b b g2
}

\score {
  \new Staff \with {
    midiInstrument = "acoustic guitar (steel)"

  }  { \clef treble \piece }
  \layout {}
  \midi {}
}