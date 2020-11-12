\version "2.20.0"
\header {
  title = "Melody in F Minor"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

fminor  = \relative f' { f g aes bes c des ees }
fhminor = \relative f' { f g aes bes c d   e   }
motifa   = \relative f' {
  f8 des'4 c8 bes f ees'4  des8 bes aes g~ g ees'4 des8 c aes bes aes f aes g4
}
motifb = \relative f {
  f4 g8 ees'4. ees f,4 g8 e'4. e  c8 e f d e f  d e f g'4 f8 des c f ees f4 ees8 c aes g f4
}

piece = \relative {
  \clef treble
  \time 6/8
  \key f \minor
  \motifa
  \motifb
  \modalTranspose f bes \fminor \motifa
  \modalTranspose f bes \fhminor \motifb
  \motifa
  \motifb
  a8 c c~ c d4 ees8 e f f4.
}


\score {
  <<
  \new Staff \with {
    midiInstrument = "electric guitar (jazz)"
  } { \piece }
  >>
  \layout {}
  \midi { \tempo 4 = 100 }
}