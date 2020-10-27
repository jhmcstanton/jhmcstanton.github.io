\version "2.20.0"
\header {
  title = "Melody in E Harmonic Minor"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piece = \relative {
  \key e \minor
  \time 4/4
  e'8. g16 a b c8 d16 c b8 c16 dis e8 d c b a4
  e8. fis16 g a b8 c16 b a8 b16 dis e8 d c b fis4 g fis dis
 
  e8 fis fis a a c b c
  g a a c c dis c dis
  e c a4 d8 b g4
  fis fis8 g b4 b8 c8 dis4 e8 dis, e2  %e e, e
}

\score {
 
  \new Staff \with {
    midiInstrument = "acoustic grand"
  }  { \clef treble \piece }

  \layout {}
  \midi { \tempo 4 = 120 }
}