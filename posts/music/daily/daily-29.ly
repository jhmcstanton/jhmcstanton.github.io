\version "2.20.0"
\header {
  title = "Tune in B Dorian"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

endintro  = \relative b' { d16 cis b cis b }
fastintro = \relative b { b16 b b fis' b b b e b b b \endintro }

pieceh = \relative {
  \clef treble
  \time 4/4
  \key b \dorian
  \repeat unfold 4 \fastintro
  \chordmode {
    b,4:min \palmMuteOn b,16:min b,16:min \palmMuteOff b,8:min
  } d''16 cis b cis b a b8
  \chordmode {
    b,4:min \palmMuteOn b,16:min b,16:min \palmMuteOff b,8:min
  } d16 cis b cis fis d b8
 
  \chordmode {
    d4 \palmMuteOn d16 d16 \palmMuteOff d8
  } fis16 e d e d cis d8
  \chordmode {
    d4 \palmMuteOn d16 d16 \palmMuteOff d8
  } fis16 e d e a fis d8
  \chordmode {
    e4 \palmMuteOn e16 e16 \palmMuteOff e8
    e4 \palmMuteOn e16 e16 \palmMuteOff e8
  }
  e16 gis b e gis b a a gis e b gis b gis e a,
  e'  gis b e gis b a a gis e b gis b gis e ais,
  \fastintro
  \chordmode {
    b,4:min \palmMuteOn b,16:min b,16:min \palmMuteOff b,8:min
  } d16 cis b cis b a b8~ b1
}

\score {
  <<
  \new Staff \with {
    midiInstrument = "distorted guitar"
  } { \pieceh }
  >>
  \layout {}
  \midi { \tempo 4 = 90 }
}