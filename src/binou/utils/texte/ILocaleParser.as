package binou.utils.texte
{
	import flash.events.IEventDispatcher;

	public interface ILocaleParser extends IEventDispatcher
	{
		function get url():String;
		function getVar( name:String ):String;
		function loadLocale( urlOrRequest:* ):void;
		function getString( name:String ):LocaleString;
	}
}