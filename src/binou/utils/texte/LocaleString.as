package binou.utils.texte
{
	/**
	 * localeString, dans les composant lagoonSoftware il y aura la possibilité de mettre des String ou des LocaleString
	 * au endroit ou on doit mettre du texte. En mettant un localeString alors les textes se mettront automatiquement à jour
	 * lors des changement de langue.
	 * 
	 * @author Benjamin BOUFFIER
	 * */
	public class LocaleString
	{
		/** @private **/
		protected var _localeParser:ILocaleParser;
		/** @private **/
		protected var _localeVar:String;
		
		public function LocaleString( localeParser:ILocaleParser, localeVar:String )
		{
		 	_localeParser 	= localeParser;
			_localeVar		= localeVar;
		}
		
		/** le locale parser associé à cette string **/
		public function get localeParser():ILocaleParser
		{
			return _localeParser;
		}
		
		/** la variable du localeParser associée à cette string **/
		public function get localeVar():String
		{
			return _localeVar;
		}
	}
}