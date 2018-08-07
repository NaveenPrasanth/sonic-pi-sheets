#########################################
## Sonic Pi Drum Machine Template
## Modified from Darin Wilson's version
## https://gist.github.com/darinwilson/a3e5909db339838a67fe
## Goals:
## 1. Input pattern similar to real drum sheet notation
##  
use_bpm 95

x = 2 # Closed hi-hat
o = 4 # Open hi-hat
Q = 5
b = 2 # Normal bass drum kick

in_thread(name: :drum_machine) do

  # program your pattern here - each item in the list represents 1/4 of a beat
  hat   [x, 0, x, 0,  x, 0, x, 0,  x, 0, x, 0,  x, 0, 0, o]
  snare [0, 0, 0, 0,  Q, 0, 0, Q,  0, o, 0, 0,  Q, 0, 0, 0]
  kick  [b, 0, b, 0,  0, 0, 0, 0,  b, 0, 0, b,  0, 0, 0, b]
  tom1  [0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, Q, 0, 0]
  tom2  [0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, Q, 0]
  tom3  [0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0]

end



##################################################################
##
## The gory details - you don't need to change anything down here,
## unless you're curious :)
##

current_drum_kit = {
    hat:   :drum_cymbal_closed,
    kick:  :drum_bass_hard,
    snare: :drum_snare_hard,
    tom1: :drum_tom_hi_hard,
    tom2: :drum_tom_mid_hard,
    tom3: :drum_tom_lo_hard,
}

live_loop :pulse do
  sleep 4
end

define :run_pattern do |name, pattern|
  live_loop name do
    sync :pulse
    pattern.each do |p|
      sample current_drum_kit[name], amp: p/3.0
      sleep 0.25
    end
  end
end

define :hat do |pattern|
  live_loop :hat_loop do
    sync :pulse
    pattern.each do |p|
      if (p == x)
        sample :drum_cymbal_closed, amp: p/3.0
      elsif (p == o) # emulate half-open hi-hat by tuning the envelope
        sample :drum_cymbal_open, attack: 0.01, sustain:0.24
      else
        sample :drum_cymbal_open, amp: p/3.0
      end      
      sleep 0.25
    end
  end
end

define :kick do |pattern|
  run_pattern :kick, pattern
end

define :snare do |pattern|
  run_pattern :snare, pattern
end

define :tom1 do |pattern|
  run_pattern :tom1, pattern
end

define :tom2 do |pattern|
  run_pattern :tom2, pattern
end

define :tom3 do |pattern|
  run_pattern :tom3, pattern
end
