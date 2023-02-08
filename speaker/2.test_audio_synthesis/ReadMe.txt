=====            Quick'n'Dirty Phoneme Extractor  v1.20            =====
=====  Copyright © 2008  James Anderson  email: jad@ccir.ed.ac.uk  =====
=====       web: http://www.ccir.ed.ac.uk/~jad/phonemes.html       =====

Quick'n'Dirty Phoneme Extractor is a little Win32 command-line app
(32KB) which uses the Microsoft SAPI speech recognition engine (in
dictation mode) to try to estimate phoneme and timing information from
standard PCM wave audio files (*.wav) containing recorded speech.  The
output data can then be used for rough lipsync animations in synthetic
agents (by a simple mapping of phonemes to visemes).  The recognition
accuracy is not particularly high (as you'll discover if you use the
'show transcription text' option), but because the resultant phoneme
sequences sound very similar to the original speech, whether or not
the word recognition is exactly correct, so the resultant viseme
sequences look very similar to what one would expect.  In fact, I've
found that the results can be suprisingly effective.

As an alternative to using the dictation grammar, a 'hints' file can be
supplied which provides accurate transcriptions for some or all of the
prompts.  For each of the prompts specified in the hints file, the
app will compile a command grammar with a single rule which corresponds
word-for-word to the transcription and will use this grammar instead of
the dictation grammar.  (Note that the recognition engine will sometimes
fail to recognize the prompt against this grammar, in which case the
hint may have to be abandoned.  In such cases, the command-line option
-u can help to determine at which word the recognition is failing.  The
hints feature works better with shorter prompts than longer ones.  As
a workaround, try breaking up longer prompts into shorter ones.)

The hints file is simply a text file, each line of which specifies a
prompt filename and a transcription of that prompt, separated with a
colon, e.g.:

  Confirm.wav:is that correct
  Silence.wav:I'm sorry I didn't hear anything
  Sorry.wav:I'm sorry there seems to be a problem
  Thanks.wav:thank you

You will need to have the Microsoft U.S. English speech recognition
engine installed in order to run this app.  You can either install
this via Microsoft Office XP (so I'm told) or by downloading and
installing the Microsoft Speech SDK 5.1.  The SDK is available here:

    http://www.microsoft.com/speech/download/sdk51/

Run phonemes.exe without arguments for a summary of the command-line
options.

The output file consists of a list of phonemes (one per line) along
with the time offset (in ms) of each phoneme from the start of the
audio file.  Alternatively, use the -x command-line option to output
the phoneme sequence in the XML format used by CryENGINE2.

Wildcards are permissible in the specification of input files.

This software is provided free of charge and with absolutely no support
and no warranty.  If it breaks your computer -- I'm sorry, but that's
too bad.  If it breaks your client's computer, and they sue you, and
you go bankrupt, and your spouse leaves you, taking the children, the
dog, and the TV -- I'm very sorry, but that's still too bad.

The software may be freely copied and distributed, so long as it is
accompanied by this text file.  Feel free to email me with comments,
suggestions, and bug reports (though I make no promises about replying).

========================================================================
