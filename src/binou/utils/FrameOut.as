package binou.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author Benjamin BOUFFIER
	 */
	internal class FrameOut extends Sprite
	{
		
		internal var _handlers	:Array 	= [];
		internal var _length	:uint 	= 0;
		internal var _alength	:uint 	= 0;
		
		internal static var _instance	:FrameOut = new FrameOut();
		
		internal static function getInstance():FrameOut
		{
			return _instance;
		}
		
		internal function addFrameOut( fonction:Function, nbFrames:uint, params:Array = null ):uint
		{
			_handlers[_length++] = {func:fonction, frames:nbFrames, params:params} ;
			
			if( _alength == 0 )	
				this.addEventListener( Event.ENTER_FRAME, _onEnterFrame );
			
			_alength++;
			
			return _length-1;
		}
		
		internal function clearFrameout(id:uint):void
		{
			if( _handlers.length > id && _handlers[id] )	
			{
				if( _handlers[id].frames > 0 ) _alength--;
				_handlers[id] = null;
			}
		}
		
		private function _onEnterFrame(e:Event):void
		{
			for( var i:int = 0; i<_length; i++ )
			{
				if( _handlers[i] && --_handlers[i].frames <= 0 && _handlers[i].func != null )
				{
					_handlers[i].func.apply(null, _handlers[i].params);
					_handlers[i] = null;
					_alength--;
				}
			}
			if( _alength <= 0 )	
			{
				this.removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
			}
		}
	}
}