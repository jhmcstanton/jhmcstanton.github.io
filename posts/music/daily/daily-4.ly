\version "2.20.0"
\header {
  title = "Slow Jazz"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piece = \relative {
  \key fis \major
  \time 4/4
  gis''4 ais,2. fis'4 gis,2. gis'8 fis gis a eis4 fis4 gis,1
  gis'4 ais,2. fis'4 gis,2.   dis8 cisis dis eis fis eis8 fis4~
  fis1
  %fis g fis eis fis4 dis fis
}

\score {
  \new Staff \with {
    midiInstrument = "electric guitar (jazz)"
  }  { \clef treble \piece }
  \layout {}
  \midi {}
}