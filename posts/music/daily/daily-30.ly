\version "2.20.0"
\header {
  title = "Minor Melody"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

pieceh = \relative {
  \key ees \minor
  \clef treble
  \time 6/8
 
  ees'8 ges bes ees, ges ges ees ges bes ees, ges ges ees ges bes ees, ges ges
  ees ges bes ces bes ces~ ces aes4 bes4.  ces8 bes ces~ ces aes4 bes4. bes8 bes bes ges8 f4 ges8 aes4
  ges8 f4~ f4. r bes8 ges f
  ees8 ges bes ees, ges ges ees ges bes ees, ges ges
}

\score {
  <<
  \new Staff \with {
    midiInstrument = "electric guitar (clean)"
  } { \pieceh }
  >>
  \layout {}
  \midi { \tempo 4 = 90 }
}