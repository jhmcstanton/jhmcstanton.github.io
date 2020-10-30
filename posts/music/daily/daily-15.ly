\version "2.20.0"
\header {
  title = "Earworm Assignment"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piece = <<
\relative {
  \time 4/4
  \repeat volta 100 {
  \repeat unfold 2 {
      d''8 d16 d8 d16 d8 d16 d8 d16 e8 d8 \break
  }
  d8 d16 d8 d16 d16 d e8 d8 c4
  }
}
\addlyrics {
  Do da Do da Do da Do _ DO Do
  Do da Do da Do da Do _ DO Do
  Do da Do da da do DO DO do
}
>>

\score {

  \new Staff \with {
    midiInstrument = "lead 1 (square)"
  }  { \clef treble \piece }
  \layout {}
  \midi { \tempo 4 = 120 }
}