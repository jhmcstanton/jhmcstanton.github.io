\version "2.20.0"
\header {
  title = "Phrygian Progression"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

rpiece = \relative {
  \key g \phrygian
  \time 6/8
  \chordmode {
    c'8:min d':dim b:dim aes4.
    c'8:min d':dim b:dim g4.~ g4 r8 r4.
    \repeat unfold 3 {
    ees16:aug ees:aug ees:aug r
    c:min c:min c:min  r
    d:dim d:dim d:dim r
    aes, aes, aes, r
    g, g, g, r
    b,:dim b,:dim b,:dim r
    c:min c:min c:min r
    aes,:min aes,:min aes,:min r
    }
    c,8:min c,:min c,:min c,:min~ c,4:min
  }
  r4 r r
}

lead = \relative {
  \key g \phrygian
  \time 6/8
  \repeat unfold 5 {
    r2.
  }
  r4 ees'''4 \glissando d,8 f16 aes
  d b g ees  f aes c ees b' g ees c
  aes' f d b   aes c ees g d b g ees
  d f ees g  b d f8 f4~
  f   g,16 aes~ aes c          f,16 g16~ g aes
  aes4 f16 f d b g' g ees c
  g8 d' b f'~ f4
  r c' r
}

\score {
 
  <<
  \new Staff \with {
    midiInstrument = "overdriven guitar"
  }  { \clef treble \rpiece }
  \new Staff \with {
    midiInstrument = "distorted guitar"
  }  { \clef treble \lead }
  >>
  \layout {}
  \midi { \tempo 4 = 160 }
}