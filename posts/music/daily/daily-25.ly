\version "2.20.0"
\header {
  title = "Phyrgian Intro Riff"
  composer = "Jim McStanton"
  tagline = \markup {
    Engraved at
    \simple #(strftime "%Y-%m-%d" (localtime (current-time)))
    with \with-url #"http://lilypond.org/"
    \line { LilyPond \simple #(lilypond-version) (http://lilypond.org/) }
  }
}

fstacoustic = \relative {
  \time 4/4
  \key e \phrygian
  \chordmode {
    \repeat unfold 2 {
    e2:min \palmMuteOn e4:min e:min e:min e:min \palmMuteOff
    e2:min \palmMuteOn e4:min e:min e:min e:min \palmMuteOff
    a,2:min \palmMuteOn a,4:min a,:min a,:min a,:min \palmMuteOff
    a,2:min \palmMuteOn a,4:min a,:min a,:min a,:min \palmMuteOff
    e,2:min \palmMuteOn e,4:min e,:min e,:min e,:min \palmMuteOff
    f,2 \palmMuteOn f,4 f, f, f, \palmMuteOff
    e2:min \palmMute e4:min \palmMute e4:min e2:min \palmMute e4:min \palmMute e4:min
    }
    \repeat unfold 4 {
      e2:min \palmMuteOn e4:min e:min e:min e:min \palmMuteOff
      e2:min \palmMuteOn e4:min e:min e:min e:min \palmMuteOff
      a,2:min \palmMuteOn a,4:min a,:min a,:min a,:min \palmMuteOff
      a,2:min \palmMuteOn a,4:min a,:min a,:min a,:min \palmMuteOff
      e2:min \palmMute e4:min \palmMute e4:min e2:min \palmMute e4:min \palmMute e4:min
      r1 r r r2
    }
    e2:min e2:min
  }
}

fstdistorted = \relative {
  \time 4/4
  \key e \phrygian
  \repeat unfold 22 r1
  \repeat unfold 4 {
    \repeat unfold 8 r
     
      \chordmode {
        f,2 \palmMuteOn f,4 f, f, f, \palmMuteOff
        e2:min \palmMute e4:min \palmMute e4:min e2:min \palmMute e4:min \palmMute e4:min
      }
  }
}

overdriven = \relative {
  \time 4/4
  \key e \phrygian
  \repeat unfold 45 r1
  \repeat unfold 2 {
  b' \glissando b' b4 b16 \glissando c \glissando b8 a4 a16 \glissando b \glissando a8 a4
  g16 \glissando a \glissando g8 f4 e4 e2 r
  a,8 c e b d f e g b1
  b4 b16 \glissando c \glissando b8 a4 a16 \glissando b \glissando a8 a4
  g16 \glissando a \glissando g8 f4 e4 e2 r
  \palmMuteOn f8 f f f \palmMuteOff \tuplet 3/2 { f4 e c } \tuplet 3/2 { e c a} a2
  }
}


\score {
  <<
  \new Staff \with {
    midiInstrument = "electric guitar (clean)"
  } { \fstacoustic }
  \new Staff \with {
    midiInstrument = "distorted guitar"
  } { \fstdistorted }
  \new Staff \with {
    midiInstrument = "overdriven guitar"
  } { \overdriven }
  >>
  \layout {}
  \midi { \tempo 4 = 150 }
}
