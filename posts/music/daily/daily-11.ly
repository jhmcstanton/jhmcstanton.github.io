\version "2.20.0"
\header {
  title = "Melody in B Mixolydian"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}
chug = \fixed c {\palmMute { \tuplet 3/2 {b8 b b } }}
chordsec = \relative {
  \time 4/4
  a'8 fis dis b fis' dis b a
  \repeat unfold 2 {
    \chordmode {
      \palmMute { \tuplet 3/2 { b,8:5 b,:5 b,:5 } } fis4:5 e8:5 dis:dim fis4:5
      \palmMute { \tuplet 3/2 { b,8:5 b,:5 b,:5 } } fis4:5 e8:5 dis:dim fis4:5
      \palmMute { \tuplet 3/2 { b,8:5 b,:5 b,:5 } } fis:5 e:5 dis:dim cis:5 cis4:5
      \palmMute { \tuplet 3/2 { b,8:5 b,:5 b,:5 } } fis:5 e:5 dis:dim cis:5 cis4:5
    }
  }
}
arpy = \relative {
  \time 3/4
  \chug b'8 a e dis  \chug b'8 a e dis
  \chug b''8 a e dis \chug b'8 a e dis
  \chug b8 a e dis \chug b'8 a e dis
  \chug cis' e gis a
  b gis e cis b dis e gis b fis dis b
  \chug cis e gis a
  b gis e cis b dis e gis b fis dis b
  \chug b8 a e dis  \chug b'8 a e dis
  \chug b''8 a e dis \chug b'8 a e dis
}

piece = \relative {
  \key b \mixolydian
  \time 4/4
  b2 b8 fis'4.  b,2 b8 fis'4. b,2 b8 fis'4.
  \chordsec
  \arpy
  \chordsec
  \arpy
  \chug b'8 a e dis \chug b'8 a e dis
}

\score {
 
  \new Staff \with {
    midiInstrument = "distorted guitar"
  }  { \clef treble \piece }

  \layout {}
  \midi { \tempo 4 = 120 }
}