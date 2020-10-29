\version "2.20.0"
\header {
  title = "Rain, Early 20th Century Melody"
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
  d'2\ff
  f'16\mf c8 e16 b8 ees16 bes8 g'8 ges a,8~ a16
  f'32 (e ees d des c b bes a aes g ges f e ees d)
  b16~ b8 aes'' a ces,8 f16 des8 ges16 d8 g16
 
  a8 aes d,2. b'8 bes c,2.
  e8 ees16 ees8 f8 e16 e g b,4.
  bes16 des16 d8 e16 ges f8 g g, ges4
  bes8 a4 des8 c4 c8 e
 
  a8 aes d,2. b'8 bes c,2.
  e8 ees16 ees8 f8 e16 e g b,4.
  f'32 (e ees d des c b bes) c,2.\fff
  des2\> c b bes a1\!
}

\score {
 
  \new Staff \with {
    instrumentName = "piano"
    midiInstrument = "acoustic grand"
  }  { \clef treble \piece }

  \layout {}
  \midi { \tempo 4 = 120 }
}