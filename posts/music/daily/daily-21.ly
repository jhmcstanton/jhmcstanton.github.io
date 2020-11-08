\version "2.20.0"
\header {
  title = "Syncopation"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piece = \relative {
  \time 4/4
  \key f \major
  % First time through, no syncopation
  g4 bes8 c d4 f  d8 bes d4 f~ f   c e8 f bes4 e,   f a8 c a4 g
  g,4 bes8 c d4 f  d8 bes d4 f~ f   c e8 f bes4 e,   f a8 c a4 g
  % Second time, start adding it at end of each measure
  g,4 bes8 c d4 e8 f~ f   d8 bes d~ d f4 c8~ c4 e8 f bes4 e,~ e8 f a8 c a4 g8 g,~
  g4 bes8 c d4 e8 f~ f   d8 bes d~ d f4 c8~ c4 e8 f bes4 e,~ e8 f a8 c a4 g
  % Third time on the third beat
  g,4 bes8 c~ c d e8 f   d8 bes d8 f~ f4 f   c e8 f~ f bes8 e,4   f a8 c~ c a g4
  g,4 bes8 c~ c d e8 f   d8 bes d8 f~ f4 f   c e8 f~ f bes8 e,4   f a8 c~ c a g4
  % Fourth time on the second beat
  g,8 bes~ bes c d4 f   d8 bes~ bes d8 f4~ f  c8 e~ e f~ f bes8 e,4   f8 a~ a c a4 g
  g,8 bes~ bes c d4 f   d8 bes~ bes d8 f4~ f  c8 e~ e f~ f bes8 e,4   f8 a~ a c a4 g
  % Return to normal
  g,4 bes8 c d4 f  d8 bes d4 f~ f   c e8 f bes4 e,   f a8 c a4 g
  g,4 bes8 c d4 f  d8 bes d4 f~ f   c e8 f bes4 e,   f a8 c e,4 f
}

\score {
  \new Staff \with {
    midiInstrument = "electric guitar (jazz)"
  } { \piece }

  \layout {}
  \midi { \tempo 4 = 120 }
}