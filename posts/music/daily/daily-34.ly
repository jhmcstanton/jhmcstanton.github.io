\version "2.20.0"
\header {
  title = "Chug Idea"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piece = \relative {
  \key c \minor
  \repeat unfold 2 {
  \time 6/8
  c16 c c c'' ees g c,,, c c g' b d
  f' d bes g, g g d'' c aes f, f f
  c c c c'' ees g c,,, c c g' b d
  \time 4/4
  ees g b d c' aes f c' aes f aes f d g ees c
  }
  f,8 <aes c> <aes c> ees' <ees g>4 b8 aes
  <d, f aes>8 <d f aes> f ees <c ees g> <c ees g> b d
  f8 <aes c> <aes c> ees' <ees g>4 b8 aes
  <d, f aes>8 <d f aes> f ees <c ees g> r <c ees g> r
  f8 <aes c> <aes c> ees' <ees g>4 b8 aes
  <d, f aes>8 <d f aes> f ees <c ees g> <c ees g> b d
  f8 <aes c> <aes c> ees' <ees g>4 b8 aes
  <d, f aes>8 <d f aes> f ees <c ees g> r <c ees g> r
}


\score {
 
  <<
  \new Staff \with {
    midiInstrument = "overdriven guitar"
  }  { \clef treble \piece }
  >>
  \layout {}
  \midi { \tempo 4 = 142 }
}