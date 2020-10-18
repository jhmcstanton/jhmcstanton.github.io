\version "2.20.0"
\header {
  title = "20201016"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}
\include "gregorian.ly"
\score {
    \new VaticanaVoice {
      {
        g g g g g a        \[ \cavum g2 \]
        f4 g g g a g       \[ \cavum f2 \]
        f4 f f f f a f ees \[ \cavum g2 \]
        }
    }
  \layout {#(layout-set-staff-size 30) }
  \midi {}
}