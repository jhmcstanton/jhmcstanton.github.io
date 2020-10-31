\version "2.20.0"
\header {
  title = "Vocal Pairing in B flat"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piecel =
\relative {
  \key bes \major
  \time 4/4
  bes4 bes8 bes bes bes c bes c bes ees bes bes4 r
  bes4 bes8 bes bes bes c bes c bes ees bes bes4 r
  f'8 g f4 d8 d ees4 bes8 bes c4 \glissando bes8 c4 \glissando bes8~ bes4 r2.
  g'4 c,8 bes  g'4 c,8 bes
  bes8 bes c4 \glissando bes8 c4 \glissando bes8~ bes4 r2.
}

piecer =
\relative {
  \key bes \major
  \time 4/4
  r1 c'4 ees bes f'~ f bes,2. c4 ees f2
  r1 c4 ees bes f'~ f bes,2. c4 ees f2
  c4 ees bes f'~ f bes,2.
}


\score {
<<
  \new Staff \with {
    midiInstrument = "electric guitar (clean)"
  }  { \clef treble \piecel }
  \new Staff \with {
    midiInstrument = "electric guitar (muted)"
  }  { \clef treble \piecer }
>>
  \layout {}
  \midi { \tempo 4 = 120 }
}