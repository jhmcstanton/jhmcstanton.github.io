\version "2.20.0"
\header {
  title = "Melody in A Minor"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piece = \relative {
  \key a \minor
  \time 6/8
  b8 g'4 a8 c,4 b8 b'4 c8 g,4
  g'8 c, a g'8 c, a g'8 c, a g'8 c, a
 
  b8 g'4 a8 c,4 b8 b'4 c8 g,4
  g'8 c, a g'8 c, a g'8 c, a g'8 c, a
 
  b8 f'4 b,8 f'4 b,8 g'4~ g8 b,8 e~ e b8 e4 f8 a,~
 
  a4  a8 f'4 g8 b,4 a8 a'4 b8
  g4
  g8 c, a g'8 c, a  b'8 e, c  b'8 e, c g'8 c, a g'8 c, a <a  e g b' d>2~
  <a  e g b' d>2.
}

\score {
 
  \new Staff \with {
    midiInstrument = "acoustic guitar (nylon)"
  }  { \clef treble \piece }

  \layout {}
  \midi { \tempo 4 = 120 }
}