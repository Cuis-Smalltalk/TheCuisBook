| list area morph extent |
Preferences smallFonts .
morph _ Object runningWorld submorphs detect: [:aMorph | aMorph is: #TaskbarMorph].
morph scale: 1/2.
list _ Object runningWorld submorphs reject: [:aMorph | aMorph is: #TaskbarMorph].
list do: [:each | each delete].
area _ RealEstateAgent maximumUsableArea extendBy: 0 @ morph morphHeight negated.
extent _ area extent // 2.
BrowserWindow openBrowser morphBounds: (0 @ 0 extent: extent).
BrowserWindow openBrowser morphBounds: (area width // 2 @ 0 extent: extent).
BrowserWindow openBrowser morphBounds: (area extent // 2 extent: extent).
Workspace openWorkspace.
"dirty hack because of Workspace inconsistency"
morph _ Object runningWorld submorphs detect: [:aMorph | aMorph class = WorkspaceWindow].
morph morphBounds: (0 @ (area height // 2) extent: extent x @ (2 / 3 * extent y)).
TranscriptWindow openTranscript morphBounds: 
	(0 @ (area height // 2 + (2 / 3 * extent y)) 
		extent: extent x @ (1 / 3 * extent y )).