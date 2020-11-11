\version "2.20.0"
\header {
  title = "Melody in D Dorian "
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
  d'8 d4 d4. d'8 c d~ d4. d,8 d4 d4. d'8 c d~ d4. d,8 d4 d4. d'8 c d~ d4. d b g
  d8 d4 d4. d'8 c d~ d4. d,8 d4 d4. d'8 c d~ d4. d,8 d4 d4. d'8 c d~ d4. d b g
 
  d8 <d f a>4 f16 a f8 f4 d8 a' a b16 c b8 b8 <a c e>8 <a c e>
  d,8 <d f a>4 f16 a f8 f4 d8 a' a b16 c b8 b8 <a c e>8 <a c e>
  %f <f a c>4 a16 c a8 a4 f8 c' c d16 e d8 d <c e g>8 <c e g>
  g <g b d>4 b16 d b8 b4 g8 d' d e16 f e8 e <d f a>8 <d f a>
  d4. b g
  d8 <d f a>4 f16 a f8 f4 d8 a' a b16 c b8 b8 <a c e>8 <a c e>
  d,8 <d f a>4 f16 a f8 f4 d8 a' a b16 c b8 b8 <a c e>8 <a c e>
  %f <f a c>4 a16 c a8 a4 f8 c' c d16 e d8 d <c e g>8 <c e g>
  g <g b d>4 b16 d b8 b4 g8 d' d e16 f e8 e <d f a>8 <d f a>
  d4. b g
  d8 d4 d4. d'8 c d~ d4. b g d8 <d f a>8 <d f a>8~ <d f a>4.~ <d f a>
}

\score {
  <<
  \new Staff \with {
    midiInstrument = "electric guitar (clean)"
  } { \piece }
  >>
  \layout {}
  \midi { \tempo 4 = 90 }
}


