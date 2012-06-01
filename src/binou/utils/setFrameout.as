package binou.utils
{
	/**
	 * @author Benjamin BOUFFIER
	 */
	public function setFrameout( fonction:Function, nbFrames:uint, params:Array = null ):uint
	{
		var f:FrameOut = FrameOut.getInstance();
		var id:uint = f.addFrameOut( fonction, nbFrames, params );
		
		return id;
	}
}

