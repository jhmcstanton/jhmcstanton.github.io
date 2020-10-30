\version "2.20.0"
\header {
  title = "Little Dugs"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

verse = \relative {
  \repeat unfold 2 {
    b'4 a8 a g2 a4 d8 cis b4 a~
    a8 cis8 cis b4 a g8   cis2. r4
  }
}

chorus = \relative {
  \repeat unfold 2 {
    a'8 a a a a a a a cis cis cis cis cis cis cis cis g2 g2
  }
  cis8 cis cis cis cis cis cis cis
  fis fis fis fis fis fis fis fis g2 g
}
versechords = \chordmode {
  \repeat unfold 2 {
    g'1 a a g
  }
}
choruschords = \chordmode {
  \repeat unfold 2 {
    a2:maj7 a2:maj7 cis:dim cis:dim g1:maj
  }
  a2:maj7 a2:maj7 b:m7 b:m7  g1:maj
}
allchords = {
  \versechords
  \choruschords
  \versechords
  \choruschords
  \versechords
  \repeat unfold 2 { \chordmode {
    a2:maj7 a2:maj7 cis:dim cis:dim g1:maj
  }}
  \choruschords
}

piece = <<
  \relative {
  \key g \lydian
  \time 4/4
  \verse
  \chorus
  \verse
  \chorus
  \verse
  \repeat unfold 2 {
    a'8 a a a a a a a cis cis cis cis cis cis cis cis g2 g2
  }
  \chorus
  }
  \addlyrics {
    Hi litt- le dugs, we love you so much.
    Snack- ing on some bones today.
    Hi litt- le dugs, we love you so much.
    Splay- ing in the hall- way.
    Ooo _ _ _ _ _ _ _ Aaah _ _ _ _ _ _ _ little doggos
    Ooo _ _ _ _ _ _ _ Aaah _ _ _ _ _ _ _ little doggos
    Aaah _ _ _ _ _ _ _ aaah  _ _ _ _ _ _ _       ah _
   
    Our litt- le dugs, we love you so much.
    Chas ing those buns a- way.
    Our litt- le dugs, we love you so much.
    Bork- in at the blue jay.
    Ooo _ _ _ _ _ _ _ Aaah _ _ _ _ _ _ _ little doggos
    Ooo _ _ _ _ _ _ _ Aaah _ _ _ _ _ _ _ little doggos
    Aaah _ _ _ _ _ _ _ aaah  _ _ _ _ _ _ _       ah _
   
    Our litt- le dugs, we love you so much.
    Screamin' to the tune of flay. % wtf
    Our litt- le dugs, we love you so much.
    Danc- in' like a caba- ret
    Ooo _ _ _ _ _ _ _ Aaah _ _ _ _ _ _ _ little doggos
    Ooo _ _ _ _ _ _ _ Aaah _ _ _ _ _ _ _ little doggos
    Ooo _ _ _ _ _ _ _ Aaah _ _ _ _ _ _ _ little doggos
    Ooo _ _ _ _ _ _ _ Aaah _ _ _ _ _ _ _ little doggos
    Ooo _ _ _ _ _ _ _ Aaah _ _ _ _ _ _ _ little doggos
    Ooo _ _ _ _ _ _ _ Aaah _ _ _ _ _ _ _ little doggos
    Aaah _ _ _ _ _ _ _ aaah  _ _ _ _ _ _ _       ah _
  }
  >>

\score {
  <<
  \new ChordNames \allchords
  \new Staff \with {
    midiInstrument = "acoustic guitar (steel)"
  }  { \clef treble \piece }
  >>
  \layout {}
  \midi { \tempo 4 = 120 }
}