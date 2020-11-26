| list area morph extent |
"Delete all windows but the taskbar"
list _ UISupervisor ui submorphs reject: [:aMorph | aMorph is: #TaskbarMorph].
list do: [:each | each delete].
"Change to Dark theme"
Feature require: #'Theme-Themes'.
DarkTheme beCurrent.
"Adjust font size"
Preferences smallFonts.
"Adjust taskbar size"
morph _ UISupervisor ui submorphs first.
morph scale: 1/2.
"Compute the available free space for windows placement"
area _ RealEstateAgent maximumUsableArea extendBy: 0 @ morph morphHeight negated.
extent _ area extent // 2.
"Open a few System Browsers"
BrowserWindow openBrowser morphBounds: (0 @ 0 extent: extent).
BrowserWindow openBrowser morphBounds: (area width // 2 @ 0 extent: extent).
"Open a System Browser on a specific class"
morph _ BrowserWindow openBrowser morphBounds: (area extent // 2 extent: extent).
morph model setClass: Integer selector: nil.
"Open a Workspace with some default contents"
Workspace openWorkspace.
"dirty hack because of Workspace inconsistency"
morph _ UISupervisor ui submorphs detect: [:aMorph | aMorph class = WorkspaceWindow].
morph model actualContents: '"Some code"
1 + 2.
"Other code"
5 * 3.'.
morph morphBounds: (0 @ (area height // 2) extent: extent x @ (2 / 3 * extent y)).
"Open a transcript for logs"
TranscriptWindow openTranscript morphBounds: 
	(0 @ (area height // 2 + (2 / 3 * extent y)) 
		extent: extent x @ (1 / 3 * extent y )).