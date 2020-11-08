\version "2.20.0"
\header {
  title = "Something in D Dorian"
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
  \key d \dorian
  \repeat unfold 2 {
  f'8~ <d f a> <d f a> c d2
  d'4 b8 g f4 e
  f8~ <d f a> <d f a> c d2
  c8 <c e g> <c e g> b'~ \tuplet 3/2 { b g e } c8 b
  c4 d e8 e f d
  d4 e f8 <d f a> <f a c> d
  f8 e d4 b8 c d4
  b8 c d4~ <d e'>2
  }
  \repeat unfold 2 {
  e8 e b c d d~ 4
  e8 e b c d d~ 4
  e8 e c d e4 c8 d
  e4 c8 d e' d d4
  }
  e8 e b c d d~ d4
  e8 e b c d d~ d4
  e8 e b c d d~ d4
  b8 c d f f2
  d4 g~ <g e> f~
  <f a> d d2
  d4 <d c a f>~ <d c a f> <d a f>
  <d a> d d2
  d4 <d c a f>~ <d c a f> <d a f>
  d2 <d c a f>4 <d a f>4~
  <d a f> <d c a f> c
  d <d a> d d2
  d d
  d1
 
}

\score {
  \new Staff \with {
    midiInstrument = "electric guitar (jazz)"
  } { \piece }
  \layout {}
  \midi { \tempo 4 = 120 }
}

