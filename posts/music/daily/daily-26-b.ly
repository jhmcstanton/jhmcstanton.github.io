\version "2.20.0"
\header {
  title = "D Dorian 9/8 Arpeggios"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piece = \relative {
  \clef treble
  \time 9/8
  \key d \dorian
  \repeat unfold 2 {
    d'8^"D" f a f a c a f d   f^"F" a c a c e c a f   g^"G" b d b d f d b d  g, b d b d f d b g
    d^"D"   f a f a c a f d   c'^"C" e g e g b g e c  d,^"D" f a f a c a f c
  }
  d g d' g d' e d c g      f,  b f' b f' g f e b   g, c g' c g' a g f c
  d,, g d' g d' e d c g    c,, f c' f c' d c f, c  d, g d' g d' e d c g
  g d b d b g f a c    d g, d g d g, b c d
  g' d b d b g f a c   d g, d g d g, b c d
  g' d b d b g f a c   d g, d g d g, b c d
  d' g, d g d g, b c d   d' g, d g d g, b c d   d4. d~ d
}

pieceO = \relative {
  \clef treble
  \time 9/8
  \key d \dorian
  d'8 d4 d4.
}

\score {
  <<
  \new Staff \with {
    midiInstrument = "electric guitar (clean)"
  } { \piece }
  >>
  \layout {}
  \midi { \tempo 4 = 150 }
}