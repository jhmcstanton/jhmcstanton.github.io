\version "2.20.0"
\header {
  title = "Horizontal Harmony"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

pieceh = \relative {
  \key g \major
  \time 4/4
  <b d> <g d>8 <b d fis>~ <b d fis> d g b8 g~ <g d>~ <d b fis'>4 <d b fis'> b'8 d
  <e g>4 <c g>8 <e g b>~ <e g b> e c e8 c~ <c g>~ <g e b'>4 <g e b'> e'8 g
  <b,, d>4 <g d>8 <b d fis>~ <b d fis> d g b8 g~ <g d>~ <d b fis'>4 <d b fis'> b'8 d
  <e g>4 <c g>8 <e g b>~ <e g b> e c e8 c~ <c g>~ <g e b'>4 <g e b'> e'8 g
  <fis a>4 <d fis>8 <fis a c>~ <fis a c> fis d fis8 d~ <d a>~ <a fis c'>4 <a fis c'> c8 fis
 
  <b,, d>4 <g d>8 <b d fis>~ <b d fis> d g b8 g~ <g d>~ <d b fis'>4 <d b fis'> b'8 d
  <e g>4 <c g>8 <e g b>~ <e g b> e c e8 c~ <c g>~ <g e b'>4 <g e b'> e'8 g
  <b,, d>4 <g d>8 <b d fis>~ <b d fis> d g b8 g~ <g d>~ <d b fis'>4 <d b fis'> b'8 d
  <cis e>4 <a e>8 <cis e g>~ <cis e g> cis a cis8 a~ <a e>~ <e cis g'>4 <e cis g'> g8 cis
  <fis a>4 <d fis>8 <fis a c>~ <fis a c> fis d fis8 d~ <d a>~ <a fis c'>4 <a fis c'> c8 fis
 
  <b,, d>4 <g d>8 <b d fis>~ <b d fis> d g b8 g~ <g d>~ <d b fis'>4 <d b fis'> b'8 d
  <e g>4 <c g>8 <e g b>~ <e g b> e c e8 c~ <c g>~ <g e b'>4 <g e b'> e'8 g
  <b,, d>4 <g d>8 <b d fis>~ <b d fis> d g b8 g~ <g d>~ <d b fis'>4 <d b fis'> b'8 d
  <gis, b>4 <e b>8 <gis b d>~ <gis b d> gis e gis8 a~ <a e>~ <e cis g'>4 <e cis g'> g8 cis
  <fis a>4 <d fis>8 <fis a c>~ <fis a c> fis d fis8 d~ <d a>~ <a fis c'>4 <a fis c'> c8 fis
 
  <b,, d>4 <g d>8 <b d fis>~ <b d fis> d g b8 g~ <g d>~ <d b fis'>4 <d b fis'> b'8 d
  <e g>4 <c g>8 <e g b>~ <e g b> e c e8 c~ <c g>~ <g e b'>4 <g e b'> e'8 g
  <b,, d>4 <g d>8 <b d fis>~ <b d fis> d g b8    b~ <b fis>~ <b fis' a>4 <b fis' a> dis8 a'
  <gis, b>4 <e b>8 <gis b d>~ <gis b d> gis e gis8 a~ <a e>~ <e cis g'>4 <e cis g'> g8 cis
  <fis a>4 <d fis>8 <fis a c>~ <fis a c> fis d fis8 d~ <d a>~ <a fis c'>4 <a fis c'> c8 fis
 
  <b,, d>4 <g d>8 <b d fis>~ <b d fis> d g b8 g~ <g d>~ <d b fis'>4 <d b fis'> b'8 d
  <e g>4 <c g>8 <e g b>~ <e g b> e c e8 c~ <c g>~ <g e b'>4 <g e b'> e'8 g
  <ais, cis>4 <fis cis>8 <ais cis e>~ <ais cis e> ais fis ais8    b~ <b fis>~ <b fis' a>4 <b fis' a> dis8 a'
  <gis, b>4 <e b>8 <gis b d>~ <gis b d> gis e gis8 a~ <a e>~ <e cis g'>4 <e cis g'> g8 cis
  <fis a>4 <d fis>8 <fis a c>~ <fis a c> fis d fis8 d~ <d a>~ <a fis c'>4 <a fis c'> c8 fis
 
 
  % Repeat first section
  <b,, d>4 <g d>8 <b d fis>~ <b d fis> d g b8 g~ <g d>~ <d b fis'>4 <d b fis'> b'8 d
  <e g>4 <c g>8 <e g b>~ <e g b> e c e8 c~ <c g>~ <g e b'>4 <g e b'> e'8 g
  <b,, d>4 <g d>8 <b d fis>~ <b d fis> d g b8 g~ <g d>~ <d b fis'>4 <d b fis'> b'8 d
  <e g>4 <c g>8 <e g b>~ <e g b> e c e8 c~ <c g>~ <g e b'>4 <g e b'> e'8 g
  <fis a>4 <d fis>8 <fis a c>~ <fis a c> fis d fis8 d~ <d a>~ <a fis c'>4 <a fis c'> c8 fis
 
  <b,, d>4 <g d>8 <b d fis>~ <b d fis> d g b8 g~ <g d>~ <d b fis'>4 <d b fis'> b'8 d
  b fis'~ fis b, a b~ <b fis a>4 c8 a fis b~ <b d>~ <b d fis>~ <b d fis a> b'~
  <b d, fis>1
}

piecel = \relative {
  \key g \major
  \time 4/4
  \clef bass
  g,4^"I" b8 g~ g4 d' d^"I" b8 g~ g g b4
  c4^"IV" e8 c~ c4 g' g^"IV" e8 c~ c c e4
  g,4^"I" b8 g~ g4 d' d^"I" b8 g~ g g b4
  c4^"IV" e8 c~ c4 g' g^"IV" e8 c~ c c e4
  d4^"V" fis8 d~ d4 a' a^"V" fis8 d~ d d fis4
 
  g,4^"I" b8 g~ g4 d' d^"I" b8 g~ g g b4
  c4^"IV" e8 c~ c4 g' g^"IV" e8 c~ c c e4
  g,4^"I" b8 g~ g4 d' d^"I" b8 g~ g g b4
  a4^"V/V" cis8 a~ a4 g' g^"V/V" cis8 a~ a a cis4
  d,4^"V" fis8 d~ d4 a' a^"V" fis8 d~ d d fis4
 
  g,4^"I" b8 g~ g4 d' d^"I" b8 g~ g g b4
  c4^"IV" e8 c~ c4 g' g^"IV" e8 c~ c c e4
  g,4^"I" b8 g~ g4 d' d^"I" b8 g~ g g b4
  e4^"V/V/V" gis8 e~ e4 gis gis^"V/V" cis8 a~ a a cis4
  d,4^"V" fis8 d~ d4 a' a^"V" fis8 d~ d d fis4
 
  g,4^"I" b8 g~ g4 d' d^"I" b8 g~ g g b4
  c4^"IV" e8 c~ c4 g' g^"IV" e8 c~ c c e4
  g,4^"I" b8 g~ g4 d' d^"V/V/V/V" dis8 fis~ fis fis dis4
  e4^"V/V/V" gis8 e~ e4 gis gis^"V/V" cis8 a~ a a cis4
  d,4^"V" fis8 d~ d4 a' a^"V" fis8 d~ d d fis4
 
  g,4^"I" b8 g~ g4 d' d^"I" b8 g~ g g b4
  c4^"IV" e8 c~ c4 g' g^"IV" e8 c~ c c e4
  fis,4^"V/V/V/V/V" ais8 fis~ fis4 cis' d^"V/V/V/V" dis8 fis~ fis fis dis4
  e4^"V/V/V" gis8 e~ e4 gis gis^"V/V" cis8 a~ a a cis4
  d,4^"V" fis8 d~ d4 a' a^"V" fis8 d~ d d fis4
 
  g,4^"I" b8 g~ g4 d' d^"I" b8 g~ g g b4
  c4^"IV" e8 c~ c4 g' g^"IV" e8 c~ c c e4
  g,4^"I" b8 g~ g4 d' d^"I" b8 g~ g g b4
  c4^"IV" e8 c~ c4 g' g^"IV" e8 c~ c c e4
  d4^"V" fis8 d~ d4 a' a^"V" fis8 d~ d d fis4
 
  g,4^"I" b8 g~ g4 d' d^"I" b8 g~ g g b4
  <g d>4^"I" b8 d b4 <g d'>~ <g b d>1 <g b d>1
 
}

\score {
  \new PianoStaff <<
    \new Staff = "upper" \pieceh
    \new Staff = "lower" \piecel
  >>

  \layout {}
  \midi { \tempo 4 = 100 }
}