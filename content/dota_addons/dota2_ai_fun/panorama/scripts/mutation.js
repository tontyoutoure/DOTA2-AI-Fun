
function OnMapFlip() {
	GameUI.SetCameraYaw(180)
	$.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("minimap").style.transform='rotateZ(180deg)'
}


function GetMutationToday() {
	var aMutation = CustomNettable
}