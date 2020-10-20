\version "2.20.0"
\header {
  title = "Simple Drone Effect"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

common = \relative {
  d' a' d, a' d, a' d, g
}

piece = \relative {
  \key c \major
  \time 4/4
  \repeat volta 2 { \mark "Let ring"  \common }
  d' b' d, c' d, f' d, e' d, f' d, g' d, g'
  d, g' d, f' d, e' d, f' d, e'
  \repeat volta 2 \common
  d, <e' e> d, <f' e> d, <e' e> d, <f' e>
  d, <g' g> d, <a'' g> d,, <e' e> d, <f' f>
  \repeat volta 2 \common
}

\score {
  \new Staff \with {
    midiInstrument = "acoustic guitar (steel)"
  }  { \clef treble \piece }
  \layout {}
  \midi { \tempo 4 = 120 }
}