\version "2.20.0"
\header {
  title = "Cough, Mid to Late 20th Century Piece"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}
% "key" f g a b c# d# no e
piece =
\relative {
  \time 1/1
  f''1 g b b \break
  r dis,2 cis b \break
  r2 f'1 g b b b2 \break
  dis,1 dis2 cis b \break
  r2 f'1 g b b b2 \break
  dis,1 dis2 cis b b1 \break
  f'1 g b b \break
  r dis,2 cis b a1 \break
  f'~ f
  % \time 6/8
  %cis'4. <b f'>8~ <b g'>~ <b a'>  cis4. <b a'>8~ <b f>4 cis4. b cis b
  %b a b a b a b a
  %a g a g a g a g
  %g f g f g f g f
 
 
 
  %f'4. dis16 dis cis4~ cis4. r
  %b8 cis dis g4. dis~ dis r
  %dis'16 dis f8 g c, c4 b4. r
}

\score {

  \new Staff \with {
   
    midiInstrument = "acoustic grand"
  }  { \clef treble \piece }
  \layout {
     \context {
      \Staff
      whichBar = ""
      \remove Time_signature_engraver
    }
  }
  \midi { \tempo 4 = 120 }
}