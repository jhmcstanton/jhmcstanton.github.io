\version "2.20.0"
\header {
  title = "Something in G Minor"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

top = \relative {
  \time 4/4
  \key g \minor
  bes'1    r4   a4~     a2 r4   a4~     a2 r4   a4~     <a c>2~
  <c bes>4~ bes2.    r4   a4~     a2 r4   a4~     a2 r4   a4~     <a c>2~
  <c bes>4~ bes2.    r4   a4~     a2 r4   a4~     a2 r4   a4~     <a c>2~
  <c bes>4~ bes2.    r4   a4~     a2 r4   a4~     a2 r4   a4    c8 f fis4
 
  d2 f4 d   c4 d16 ees f8~ f d bes4    c2 bes4 g    d2 a'4 c   d4 d c8 a f4  <d f>  f a d
  d2 f4 d   c4 d16 ees f8~ f d bes4    c2 bes4 g    d2 a'4 c   d4 d c8 a f4  <d f>  f a d
  d2 f4 d   c4 d16 ees f8~ f d bes4    c2 bes4 g    d2 a'16 bes a8 c cis  d4 d c8 a fis4  <d f>  f a d
  d2 f4 d   c4 d16 ees f8~ f d bes4    c2 bes4 g    d2 a'4 c   d4 d c8 a f4  <d f>  f a d
  d~ <d f>~ <d f a>~ <d f a c>~ <d f a c>1
}

bot = \relative {
  \clef bass
  \time 4/4
  \key g \minor
  <ees g>1 d4~ <d f>4~ <d f>2 d4~ <d f>4~ <d f>2 d4~ <d f>4~ <d f>2
  <ees g>1 d4~ <d f>4~ <d f>2 d4~ <d f>4~ <d f>2 d4~ <d f>4~ <d f>2
  <ees g>1 d4~ <d f>4~ <d f>2 d4~ <d f>4~ <d f>2 d4~ <d f>4~ <d f>2
  <ees g>1 d4~ <d f>4~ <d f>2 d4~ <d f>4~ <d f>2 d4~ <d f>4~ <d f>2
 
  <bes g'>1 <ees g>1 <ees g>1 <f a>1 <f a>1 <bes, g'>
  <bes g'>1 <ees g>1 <ees g>1 <f a>1 <f a>1 <bes, g'>
  <bes g'>1 <ees g>1 <ees g>1 <f a>1 <f a>1 <bes, g'>
  <bes g'>1 <ees g>1 <ees g>1 <f a>1 <f a>1 <bes, g'> <bes g'>~ <bes g'>
}

\score {
 
  \new PianoStaff <<
    \set PianoStaff.instrumentName = "Piano"
    \set PianoStaff.midiInstrument = "acoustic grand"
    \new Staff = "upper" \top
    \new Staff = "lower" \bot

   
  >>
  \layout {}
  \midi { \tempo 4 = 120 }
}