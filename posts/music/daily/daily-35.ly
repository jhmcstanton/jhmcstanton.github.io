\version "2.20.0"
\header {
  title = "Lydian Harmony Thing"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

lead = \relative {
  \key f \lydian
  \repeat unfold 4 r1
  \repeat unfold 4 {
  d''8 e e d r d g r
  d e e d r a' a g
  d e e d r d g r
  d' b a g a g a g
  }
  \repeat unfold 4 r1
}

leadtwo = \relative {
  \key f \lydian
  \repeat unfold 12 r1
  \repeat unfold 3 {
  a''8 b a a r c b r
  b g a g r4 e8 e
  a b a a r c b r
  d, e f a d4 c
  }
}


rpiece = \relative {
  \key f \lydian
  \repeat unfold 5 {
  f'4 <a c>8 <a c>~ <a c> <f a d>~ <f a d> <c' e>
  g4 <b d>8 <b d>~ <b d> <g b d a'> <g b d a'> e
  f4 <a c>8 <a c>~ <a c> <f a d>~ <f a d> <c' e>
  a4 <c e>8 <a c e d'>~ <a c e f> <g b d> <g b a'> <g b d>
  }
  \repeat unfold 4 r1
}

\score {
 
  <<
  \new Staff \with {
    midiInstrument = "electric guitar (jazz)"
  }  { \clef treble \lead }
   \new Staff \with {
    midiInstrument = "electric guitar (jazz)"
  }  { \clef treble \leadtwo }
  \new Staff \with {
    midiInstrument = "electric guitar (clean)"
  }  { \clef treble \rpiece }
  >>
  \layout {}
  \midi { \tempo 4 = 160 }
}