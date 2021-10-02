 ######################################################################
 ##                                                                  ##
 ## Finnish Hyphenation                                              ##
 ##                                                                  ##
 ## Matti J. Kärki <mjk@iki.fi>                                      ##
 ##                                                                  ##
 ## Created:  19.05.2004                                             ##
 ## Modified: 30.11.2004                                             ##
 ##                                                                  ##
 ## The following code is my personal experiment. I tried to find an ##
 ## easy way to hyphenate Finnish text. In theory, it is not an easy ##
 ## task (trust me). However, I did find a simple rule-set for       ##
 ## hyphenation. The following code is an implementation of my idea. ##
 ## I don't know, if this is already invented method or not. If it   ##
 ## is, then I have reinvented a wheel. If not, then, well... cool :)##
 ##                                                                  ##
 ######################################################################
 
 ##
 ## Tools:
 ##
 
 # Returns true if the character is a vowel. Otherwise returns false.
 proc vowel chr {
     if {$chr != {}} then {
         if {[regexp {[aeiouyäö]} [string tolower $chr]]} then {
             return true
         }
     }
 
     return false
 }
 
 # Returns true if the character is a consonant. Otherwise returns false.
 proc consonant chr {
     if {$chr != {}} then {
         if {[regexp {[bcdfghjklmnpqrstvwxz]} [string tolower $chr]]} then {
             return true
         }
     }
 
     return false
 }
 
 # Returns true if the character is a consonant or a vowel. Otherwise
 # returns false.
 proc alphabet chr {
     if {[vowel $chr] || [consonant $chr]} then {
         return true
     }
 
     return false
 }
 
 # Returns true only if the character is not vowel or consonant. Otherwise
 # returns false.
 proc nonalphabet chr {
     if {[vowel $chr] == false && [consonant $chr] == false} then {
         return true
     }
 
     return false
 }
 
 ##
 ## Hyphenation rules:
 ##
 ## c = expects a consonant
 ## v = expects a vowel
 ## x = expects a non-alphabet character (or no character, empty {})
 ## a = expects an alphabet character
 ##
 ## hyphen is placed before _current_ character ($cc in the engine code,
 ## capitalized character in a rule name)
 ##
 
 # pro-, pre beginning, for example pro-fes-so-ri, presi-dent-ti and
 # all foreign words with pro- or pre- prefix.
 proc rule-xccvA {a b c d e} {
     if {[nonalphabet $a] && [consonant $b] && [consonant $c] && \
             [vowel $d] && [alphabet $e]} then {
         return true
     }
 
     return false
 }
 
 # si-tä for example: si-tä, mi-tä
 proc rule-vCv {a b c} {
     if {[vowel $a] && [consonant $b] && [vowel $c]} then {
         return true
     }
 
     return false
 }
 
 # -no-in-, for example: pai-no-in-dek-si
 proc rule-acvVccvcc {a b c d e f g h i} {
     if {[alphabet $a] && [consonant $b] && [vowel $c] && [vowel $d] && \
             [consonant $e] && [consonant $f] && [vowel $g] && \
             [consonant $h] && [consonant $i] && ($c ne $d)} then {
         return true
     }
 
     return false
 }
 
 # al-la, for example: al-la, ak-tii-vi-nen
 proc rule-vcCv {a b c d} {
     if {[vowel $a] && [consonant $b] && [consonant $c] && [vowel $d]} then {
         return true
     }
 
     return false
 }
 
 # link-ki, eng-lan, for example: link-ki, eng-lan-ti
 proc rule-vccC {a b c d} {
     if {[vowel $a] && [consonant $b] && [consonant $c] && [consonant $d]} then {
         return true
     }
 
     return false
 }
 
 # -uli-, for example: tu-lin
 proc rule-cvCvv {a b c d e} {
     if {[consonant $a] && [vowel $b] && [consonant $c] && [vowel $d] && [vowel $e]} then {
         return true
     }
 
     return false
 }
 
 # pai-no, for example: pai-no
 proc rule-cvvCv {a b c d e} {
     if {[consonant $a] && [vowel $b] && [vowel $c] && [consonant $d] && [vowel $e]} then {
         return true
     }
 
     return false
 }
 
 # -si-oon, for example: pait-si-oon
 proc rule-cvVv {a b c d} {
     if {[consonant $a] && [vowel $b] && [vowel $c] && [vowel $d] && \
             ($c eq $d)} then {
         return true
     }
 
     return false
 }
 
 # nii-aus, for example: nii-aus
 proc rule-cvvVv {a b c d e} {
     if {[consonant $a] && [vowel $b] && [vowel $c] && [vowel $d] && \
             [vowel $e]} then {
         return true
     }
 
     return false
 }
 
 # -aa-il-, -toon, for example: maa-il-ma, tais-toon
 proc rule-vvVc {a b c d} {
     if {[vowel $a] && [vowel $b] && [vowel $c] && [consonant $d] && \
             ($b ne $c)} then {
         return true
     }
 
     return false
 }
 
 # -ku-oi-ke-, for example: kaut-ta-kul-ku-oi-ke-us
 proc rule-cvVvc {a b c d e} {
     if {[consonant $a] && [vowel $b] && [vowel $c] && [vowel $d] && \
             [consonant $e] && ($b ne $c)} then {
         return true
     }
     return false
 }
 
 # -aan, -ään, -ian, -uan ending, for example: ku-kaan, pi-an
 proc rule-vVcx {a b c d} {
     if {[vowel $a] && [vowel $b] && [consonant $c] && [nonalphabet $d] && \
             ($a ne $b)} then {
         return true
     }
 
     return false
 }
 
 # -ia, -aa ending, for example: vaa-li-a, tär-ke-ää
 # understands to not to hyphenate words like "ei" and "tai"
 proc rule-aavVx {a b c d e} {
     if {[alphabet $a] && [alphabet $b] && [vowel $c] && [vowel $d] && \
             [nonalphabet $e] && ($c ne $d)} then {
         return true
     }
 
     return false
 }
 
 # -lla ending, for example: si-vuil-la
 proc rule-cCvx {a b c d} {
     if {[consonant $a] && [consonant $b] && [vowel $c] && \
             [nonalphabet $d]} then {
         return true
     }
 
     return false
 }
 
 ##
 ## Hyphenation engine:
 ##
 
 # Hyphenates given text and returns list of characters, including hyphenation
 # marks.
 proc hyphenate text {
     set chars  [split $text ""]
     set len    [llength $chars]
     set hyphen false
     set result {}
 
     for {set i 0} {$i < $len} {incr i} {
         set cpppp  [lindex $chars [expr $i - 4]] ;# Character in the past
         set cppp   [lindex $chars [expr $i - 3]] ;# Character in the past+1
         set cpp    [lindex $chars [expr $i - 2]] ;# Character before previous
         set cp     [lindex $chars [expr $i - 1]] ;# Previous character
         set cc     [lindex $chars $i]            ;# <-- Current character !!!
         set cn     [lindex $chars [expr $i + 1]] ;# Next character
         set cnn    [lindex $chars [expr $i + 2]] ;# Character after next
         set cnnn   [lindex $chars [expr $i + 3]] ;# Character in the future
         set cnnnn  [lindex $chars [expr $i + 4]] ;# Character in the future+1
         set cnnnnn [lindex $chars [expr $i + 5]] ;# Character in the future+2
 
         if {$hyphen} then {
             set cp {}
         }
 
         if {![alphabet $cc]} then {
             set cp {}
         }
 
         if { \
                  [rule-xccvA $cpppp $cppp $cpp $cp $cc] || \
                  [rule-vCv $cp $cc $cn] || \
                  [rule-acvVccvcc $cppp $cpp $cp $cc $cn $cnn $cnnn $cnnnn $cnnnnn] || \
                  [rule-vcCv $cpp $cp $cc $cn] || \
                  [rule-vccC $cppp $cpp $cp $cc] || \
                  [rule-cvCvv $cpp $cp $cc $cn $cnn] || \
                  [rule-cvvCv $cppp $cpp $cp $cc $cn] || \
                  [rule-cvVv $cpp $cp $cc $cn] || \
                  [rule-cvvVv $cppp $cpp $cp $cc $cn] || \
                  [rule-vvVc $cpp $cp $cc $cn] || \
                  [rule-cvVvc $cpp $cp $cc $cn $cnn] || \
                  [rule-vVcx $cp $cc $cn $cnn] || \
                  [rule-aavVx $cppp $cpp $cp $cc $cn] || \
                  [rule-cCvx $cp $cc $cn $cnn] } then {
             lappend result "-"
             set hyphen true
         } else {
             set hyphen false
         }
 
         lappend result $cc
     }
 
     return $result
 }
 
 # Hyphenates a string from stdin. Hyphenated string is returned to stdout.
 puts [join [hyphenate [gets stdin]] ""]

