package com.lagoon.utils.texte
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	/**
	 * Utils pour charger un fichier texte, le parser et enregistrer des combinaisons clé/valeurs.
	 * 
	 * LocaleParsers est à utiliser si le projet contient plusieurs fichier à charger.
	 * Si votre projet n'a qu'un seul fichier texte à charger, utiliser plutôt LocaleParser qui est une classe en Singleton
	 * et avec un accesseur statique aux variables chargées. 
	 * 
	 * <ul>
	 *  <li>vous pouvez définir le ou les caracteres de début de ligne qui définissent si la ligne sera un commentaire ou  une variable
	 * avec les variables startKey et commentKey</li>
	 * 	<li>Utilisez la fonction loadLocale( urlOrRequest ) pour charger le fichier texte -> un évènement LOCALE_CHANGED sera diffusé 
	 * lorsque le fichier aura été chargé et parsé, et que les variables seront accessibles.</li>
	 * 	<li>Utilisez la fonction getVar( name ) pour récuperer la chaine correspondante à la clé name</li>
	 * </ul>
	 * 
	 * <p><strong><em>Note: Si une ligne du texte ne commence ni par $startKey ni par $commentKey, 
	 * alors elle sera concaténé à la ligne précédente, 
	 * si elle est avant la premiere ligne de variable elle sera ignorée</em></strong></p>
	 * 
	 * @see com.lagoon.utils.LocaleParser
	 * @author Benjamin BOUFFIER
	 * */
	public class LocaleParsers extends EventDispatcher implements ILocaleParser
	{
		/** l'évenement lorsque la locale change **/
		public static const	LOCALE_CHANGED			:String			= "localeChanged";
		/** la clé de début de ligne **/
		public var	startKey						:String			= "<|>";
		/** la clé de commentaire **/
		public var	commentKey						:String			= "#";
		
		/**@private **/
		private var _url							:String			= "";
		/** @private **/
		private var _vars							:Object;
		/** @private **/
		private var _loader							:URLLoader;
		/** @private **/
		private var _req							:URLRequest;
		/** @private **/
		//private var _eventLocaleReady				:Event			= new Event( LOCALE_READY );
		/** @private **/
		private var _eventLocaleChanged				:Event			= new Event( LOCALE_CHANGED );
		
		/** 
		 * Constructeur du parseur 
		 * Si le projet n'a qu'un seul fichier de locale utiliser LocaleParser plutot.
		 * 
		 * @see com.lagoon.utils.LocaleParser
		 * **/ 
		public function LocaleParsers( urlOrRequest:* = null )
		{
			if( urlOrRequest )	loadLocale( urlOrRequest );
		}
		
		/** @private **/
		private function _parseLocale( evt:Event ):void
		{
			_loader.removeEventListener( Event.COMPLETE, _parseLocale );
			
			_vars = {};
			
			var str			:String 	= _loader.data+'\r\n#';
			var newStr		:String 	= str;
			var lines		:Array 		= []
			var actualPos	:int 		= 0;
			var newPos		:int 		= newStr.search( '\r\n' );
			
			// variables pour la boucle
			var line		:String;
			var cle			:String;
			var valeur		:String;
			
			while( newPos != -1 )
			{
				line 		= newStr.substr( 0, newPos );
				actualPos 	= newPos + 1;
				newStr 		= newStr.substr( actualPos );
				newPos 		= newStr.search( '\r\n' );
				
				if( !_lineIsComment(line) )		
				{
					// si nouvelle variable on l'ajoute sinon on ajoute la ligne à la suite de la ligne précédente
					if( _lineIsValue(line) )	lines.push( line );
					else						lines[lines.length-1] = String(lines[lines.length-1]).concat( line );
				}
			}
			
			var i:int = 0;
			var l:int = lines.length;
			for( i=0; i<l; i++ )
			{
				if( lines[i].search('=') != -1 )
				{
					cle 		= lines[i].substr( 0, lines[i].search('=') );
					cle 		= cle.replace('\n', '' ).replace('\r', '').replace( startKey, '' );
					valeur 		= lines[i].substr( lines[i].search('=')+1 );
					
					_vars[cle] 	= valeur;
					
					continue;
				}
			}
			
			//dispatchEvent( _eventLocaleReady );
			
			_url = _req.url;
			dispatchEvent( _eventLocaleChanged );	 
		}
		
		/** @private **/
		protected function _lineIsComment( line:String ):Boolean
		{
			if( line.search(commentKey) > -1 && line.search(commentKey) < 2 ) 
				return true;
			
			return false;
		}
		/** @private **/
		protected function _lineIsValue( line:String ):Boolean
		{
			if( line.search(startKey) > -1 && line.search(startKey) < 2 ) 
				return true;
			
			return false;
		}
		
		/** charger un fichier de locale **/
		public function loadLocale( urlOrRequest:* ):void
		{
			/*_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE, _parseLocale, false, 0, true );
			
			if( urlOrRequest is String )	
				_loader.load( new URLRequest( String(urlOrRequest) ) );
				
			else if( urlOrRequest is URLRequest )
				_loader.load( URLRequest(urlOrRequest) );*/
			if( urlOrRequest is String )	
			{
				if( _req && _req.url == String(urlOrRequest) )	
					return;
				_req = new URLRequest( String(urlOrRequest) );
			}
			else if( urlOrRequest is URLRequest )
			{ 
				if( _req && _req.url == URLRequest(urlOrRequest).url )
					return;
				_req = URLRequest(urlOrRequest);
			}
			
			if( _req )	
			{
				if(!_loader)	_loader = new URLLoader();
				_loader.addEventListener( Event.COMPLETE, _parseLocale, false, 0, true );
				
				_loader.load( _req );
			}
		}
		
		private function search(str:String, pattern:String):int
		{
			var i:int = 0;
			var l:int = str.length;
			for( i=0; i<l; i++ )
			{
				if( str.charAt(i) == pattern ) return i;
			}
			return -1;
		}
		
		/** récuperer le texte corresondant au nom de liaison <code>name</code>**/
		public function getVar( name:String ):String
		{
			if( name.substr(0,5) == '<<|>>' )	return getConcatVar(name);
			if( name == 'toto_test' )			return 'toto';
			if( name == 'html_toto_test' )		return '<b>toto</b>';
			if( !_vars )						return '';
			if( _vars[name] )					return _vars[name];
			else								return '';
		}
		
		/** récuperer le texte corresondant au nom de liaison <code>name</code>**/
		protected function getConcatVar( name:String ):String
		{
			name = name.substr( 5 );
			
			var s:String = '';
			var newpos:int = search(name,'|');
			var isString:Boolean = true;
			var i:int = 0;
			var str:String;
			
			while( newpos != -1 && i<100 )
			{
				if( isString )	str = getVar( name.substring( 0, newpos++ ) );
				else			str = name.substring( 0, newpos++ );
				
				s += str;
				name = name.substring( newpos );
				
				if( isString )
					newpos = search(name, '~');
				else
					newpos = search(name, '|');
				
				isString = !isString;
				
				++i;
			}
			
			return s;
		}
		
		/** renvoi le fichier de locale au complet **/
		override public function toString():String
		{
			var s:String = "Locales: \n";
			for( var key:String in _vars )
			{
				s += key + '-> ' + _vars[key] + '\n';
			}
			
			return s;
		}
		
		/** l'url du fichier chargé **/
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * récupérer la localeString correspondant au nom de liaison <code>name</code>
		 * */
		public function getString( name:String ):LocaleString
		{
			return new LocaleString( this, name );
		}
		
		/**
		 * récupérer la localeStringConcat: <br />
		 * usage:
		 * la fonction récupere un tableau de localeVars et un tableau de séparateurs.
		 * retournera une chaine de type : strings[0]separators[0]strings[1]separators[1]...
		 * si aucun séparateur n'est définit alors il sear remplacé par la chaine vide ''. 
		 * */
		public function getConcatString( strings:Array, separators:Array ):LocaleString
		{
			var s:String = '<<|>>';
			var ls:int = strings.length;
			var lsep:int = separators.length;
			for( var i:int = 0; i<strings.length; i++ )
			{
				s += strings[i]+'|';
				if( separators && separators.length > i )
					s += separators[i]+'~';
				else
					s += '~';
			}
			
			return new LocaleString( this, s );
		}
	}
}