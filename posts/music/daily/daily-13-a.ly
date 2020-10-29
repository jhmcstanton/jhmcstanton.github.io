\version "2.20.0"
\header {
  title = "Romantic Melody in D Major"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piece = \relative {
  \key d \major
  \time 3/4
  e''8 d e f16 fis g gis a8 a,4. e'8 d b d16 cis d8 b a4 cis8
  e8 d b d16 cis d8 b a  e'8 d b d16 cis d8
  cis,16 d e8 d16 e fis8 e16 fis g8
  cis16 d e f e8 cis e4
  e8 d e f16 fis g gis a8 a,4. e'8 d b
 
 
  d16 cis d b a8  e'8 d b d16 cis d8
  cis,16 d e8 d16 e fis8 e16 fis g8
 
  fis16 g e'8 d e f16 fis g gis a8 a,4 c8 cis4
  d16 fis g a d8 d,
}

\score {
 
  \new Staff \with {
    midiInstrument = "acoustic grand"
  }  { \clef treble \piece }

  \layout {}
  \midi { \tempo 4 = 120 }
}