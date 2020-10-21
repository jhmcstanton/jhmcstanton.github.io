\version "2.20.0"
\header {
  title = "Melody / Lead over 12 Bar Blues"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}


backing = \chordmode {
  \powerChords {
  \key bes \major
  \time 4/4
  \repeat unfold 2 {
    bes,:5 bes,:5 <bes g'> <bes g'>
    bes,:5 bes,:5 <bes g'> <bes g'>
    bes,:5 bes,:5 <bes g'> <bes g'>
    bes,:5 bes,:5 <bes g'> <bes g'> \break
    ees,:5 ees,:5 <ees c'> <ees c'>
    ees,:5 ees,:5 <ees c'> <ees c'>
    bes,:5 bes,:5 <bes g'> <bes g'>
    bes,:5 bes,:5 <bes g'> <bes g'> \break
    f,:5 f,:5 <f d'> <f d'>
    ees,:5 ees,:5 <ees c'> <ees c'>
    bes,:5 bes,:5 <bes g'> <bes g'>
    f,:5 f,:5 <f d'> <f d'>
  }
  bes,1:5
  }
}

piece = \relative {
  \key bes \major
  \time 4/4
  \chordmode {
    \tuplet 3/2 { <aes'' d'' f''>4 <aes'' d'' f''> <aes'' d'' f''> }
    \tuplet 3/2 { <g'' des'' e''> <g'' des'' e''>  <g'' des'' e''> }
    \tuplet 3/2 { <ges'' c'' ees''> <ges'' c'' ees''> <ges'' c'' ees''> }
    <f'' ces'' e''>2
  }
  bes''2 des8 d4. bes des8 d4 g,
  f2 r \tuplet 3/2 { d4 c d } f8 \glissando g4.   bes2 des8 d4. bes des8 d4 g,
  f2 r \tuplet 3/2 { ees4 bes ees } ees8 d des c bes2 bes4 d bes des8 d4 f4.
 
  bes8 \glissando d c bes bes g g c, des d d d4 r4. bes'2 des8 d4. bes des8 d4 g,
  d8 f g \glissando bes' bes bes d,,8 f g \glissando bes' bes bes g f d des c c bes~ bes4 r4.
       bes,4 g8 bes4 g8 bes4
  f r f bes g bes8 g g4 r c8 des d d4 r g,8 f f4 d8 d4 des8 c bes1
}

\score {
  <<
  \new Staff \with {
    midiInstrument = "electric guitar (jazz)"
  }  { \clef treble \piece }
  \new ChordNames { \clef treble \backing }
  \new Staff \with {
    midiInstrument = "electric guitar (muted)"
  }  { \clef treble \backing }
  >>
  \layout {}
  \midi { \tempo 4 = 120 }
}