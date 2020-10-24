\version "2.20.0"
\header {
  title = "Melody in F Lydian"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

piece = \relative {
  \key f \lydian
  \time 4/4
  e'8 f a e f a r e  f a e f a r c a
  g r d' b g b d f  g r4 f8 g f d b
  e, f a e f a r e  f a e f a r c a
  g r d' b g b d f  g r4 f8 g f d b
 
  c e f r b, e f r c b e f r f g, c
  d e f f r d e f f r a f d r d g,
  c e f r b, e f r c b e f r f g, c
  d e f f r d e f f r a f d r d g,
 
  e f a e f a r e  f a e f a r c a
  e f a e f a r e  f a e f a r c a
  e' f a e f2
}

lowerchords = \chordmode {
  \key f \lydian
  \clef bass
  \time 4/4
  f,4:maj7 r8 f,:maj7 f,4:maj7 r8 f,:maj7 f,4:maj7 f,8:maj7 r f,4:maj7 f,8:maj7 f,:maj7
  g,4:7 r8 g,:7 g,4:7 r8 g,:7 g,4:7 g,8:7 r g,4:7 g,8:7 g,:7
  f,4:maj7 r8 f,:maj7 f,4:maj7 r8 f,:maj7 f,4:maj7 f,8:maj7 r f,4:maj7 f,8:maj7 f,:maj7
  g,4:7 r8 g,:7 g,4:7 r8 g,:7 g,4:7 g,8:7 r g,4:7 g,8:7 g,:7
 
  c,4:maj7 r8 c,:maj7 c,4:maj7 r8 c,:maj7 c,4:maj7 c,8:maj7 r c,4:maj7 c,8:maj7 c,:maj7
  d,4:min7 r8 d,:min7 d,4:min7 r8 d,:min7 d,4:min7 d,8:min7 r d,4:min7 d,8:min7 d,:min7
  c,4:maj7 r8 c,:maj7 c,4:maj7 r8 c,:maj7 c,4:maj7 c,8:maj7 r c,4:maj7 c,8:maj7 c,:maj7
  d,4:min7 r8 d,:min7 d,4:min7 r8 d,:min7 d,4:min7 d,8:min7 r d,4:min7 d,8:min7 d,:min7
 
  f,4:maj7 r8 f,:maj7 f,4:maj7 r8 f,:maj7 f,4:maj7 f,8:maj7 r f,4:maj7 f,8:maj7 f,:maj7
  f,4:maj7 r8 f,:maj7 f,4:maj7 r8 f,:maj7 f,4:maj7 f,8:maj7 r f,4:maj7 f,8:maj7 f,:maj7
  f,1:maj7
}

\score {
  \new PianoStaff <<
    \set PianoStaff.instrumentName = "Piano"
    \set PianoStaff.midiInstrument = "acoustic grand"
    \new Staff = "upper" \piece
    <<
      \new ChordNames \lowerchords

    \new Staff = "lower" \lowerchords
    >>
  >>
  \layout {}
  \midi { \tempo 4 = 120 }
}