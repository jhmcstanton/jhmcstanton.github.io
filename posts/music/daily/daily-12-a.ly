\version "2.20.0"
\header {
  title = "Melody in G Major"
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
  fis'8 g d' c e, fis c' b g d'4. b2
  fis8 g d' c e, fis c' b fis g d'4 a2
  \tuplet 3/2 { e8 e e } \tuplet 3/2 { g g g } \tuplet 3/2 { b b b } e4
  b8 fis'4 e8 c4 a8 e'~ e d8 a4 fis'8 b, d a
  \tuplet 3/2 { e8 e e } \tuplet 3/2 { g g g } \tuplet 3/2 { b b b } fis'4
  b,8 fis'4 e8 c4 a8 e'~ e d8 a4 fis'8 b, d fis
 
  b,2 des4 a  b8 c fis, e c' d g, fis
  b2 des4 g,
  \tuplet 3/2 { e8 e e } \tuplet 3/2 { g g g } \tuplet 3/2 { b b b } g'4
  b,2 des4 g,
  b8 c fis, e c' d fis, g g1
}

\score {
 
  \new Staff \with {
    midiInstrument = "acoustic grand"
  }  { \clef treble \piece }

  \layout {}
  \midi { \tempo 4 = 120 }
}
