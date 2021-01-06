\version "2.20.0"
\header {
  title = "Lydian Taps"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piece = \relative {
  \key d \lydian
  \time 4/4
  \chordmode {
    d4:maj7 d8:maj7 d8:maj7~ d8:maj7 d8:maj7 d8:maj7 d8:maj7~ d8:maj7
    a:maj7 a4:maj7 a:maj7 a8:maj7 a:maj7
    d4:maj7 d8:maj7 d8:maj7~ d8:maj7 d8:maj7 d8:maj7 d8:maj7~ d8:maj7
    e e4 e8 e:7 e4:7
  }
  d'8 fis a e' <d fis a e'> <d fis a e'>\staccato <d fis a cis> <d fis a cis>\staccato
 
  \chordmode {
    d4:maj7 d8:maj7 d8:maj7~ d8:maj7 d8:maj7 d8:maj7 d8:maj7~ d8:maj7
    a:maj7 a4:maj7 a:maj7 a8:maj7 a:maj7
  }
  fis'8 a, \glissando fis4 cis'8 \glissando e a,4
  \chordmode {
    e8 e8 e4 e8 e:7 e4:7
  }
  d,,8 fis a e' <d fis a e'> <d fis a e'>\staccato <d fis a cis> <d fis a cis>\staccato
 
  r1
  \time 6/8
  \repeat unfold 4 {
    fis8 d, a' cis \glissando fis a,
    e''16 a, gis'8 \glissando a cis,16 e a,8 \glissando e'8
  }
 
 
  \time 4/4
  \chordmode {
    d4:maj7 d8:maj7 d8:maj7~ d8:maj7 d8:maj7 d8:maj7 d8:maj7 d4:maj7
  }
  e16 a, gis'8 \glissando a cis,16 e a,8 \glissando e'8
  \chordmode {
    d4:maj7 d8:maj7 d8:maj7~ d8:maj7 d8:maj7 d8:maj7 d8:maj7~ d8:maj7
    e e4 e8 e:7 e4:7
  }
  d,,8 fis a e' <d fis a e'> <d fis a e'>\staccato <d fis a cis> <d fis a cis>\staccato
 
  fis8 d, a' cis \glissando fis a,
  e''16 a, gis'8 \glissando a cis,16 e a,8 \glissando e'8
  fis,8 d, a' cis \glissando fis a,
  \chordmode {
    d8:maj7 d8:maj7~ d8:maj7 d8:maj7 d8:maj7 d8:maj7~ d8:maj7
    a:maj7 a4:maj7 a:maj7 a8:maj7 a:maj7
  }
  fis'8 a, \glissando fis4 cis'8 \glissando e a,4
  \chordmode {
    e8 e8 e4 e8 e:7 e4:7
  }
  d,,8 fis a e' <d fis a e'> <d fis a e'>\staccato <d fis a cis> <d fis a cis>\staccato
}

\score {
  \new Staff \with {
    midiInstrument = "electric guitar (clean)"
  }  { \clef treble \piece }
  \layout {}
  \midi { \tempo 4 = 120 }
}