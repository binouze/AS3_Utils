package binou.utils.assets
{
	import com.lagoon.display.bitmap.clips.slice9.Slice9Bitmap;
	import com.lagoon.display.bitmap.clips.std.BitmapClip;
	import com.lagoon.display.bitmap.movies.slice9.Slice9BitmapMovie;
	import com.lagoon.display.skinBase.ISkin;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * <p><strong>Classe statique pour la gestion des assets.</strong></p>
	 * 
	 * <b>Cette classe permet de gérer des <code>BitmapData</code>:</b>
	 * <ul>
	 * 	<li>Ajouter un <code>BitmapData</code> aux assets en l'associant à un nom</li>
	 *  <li>Recupérer un <code>BitmapData</code> par son nom</li>
	 *  <li>Recupérer un <code>Bitmap</code> à partir d'un <code>BitmapData</code></li>
	 * </ul>
	 * <p></p>
	 * <b>Cette classe permet de gérer des <code>Sound</code>:</b>
	 * <ul>
	 * 	<li>Ajouter un <code>Sound</code> aux assets en l'associant à un nom</li>
	 *  <li>Recupérer un <code>Sound</code> par son nom</li>
	 * </ul>
	 * <p></p>
	 * <b>Cette classe permet de gérer des <code>SWF</code>:</b>
	 * <ul>
	 * 	<li>Ajouter un <code>ApplicationDomain</code> aux assets en l'associant à un nom</li>
	 *  <li>Recupérer un <code>ApplicationDomain</code> par son nom</li>
	 *  <li>Récupérer un <code>Class</code> dans un <code>ApplicationDomain</code></li>
	 *  <li>Récupérer une instance de <code>Class</code> dans un <code>ApplicationDomain</code></li>
	 * </ul>
	 * <p></p>
	 * <b>Cette classe permet de gérer des <code>Fonts</code>:</b>
	 * <ul>
	 * 	<li>Ajouter une <code>Font</code> aux assets en l'associant à un nom</li>
	 *  <li>Recupérer un <code>Font</code> par son nom</li>
	 *  <li>Ajouter un <code>TextFormat</code> aux assets en l'associant à un nom</li>
	 *  <li>Récupérer un <code>TextFormat</code> par son nom</li>
	 * </ul>
	 * <b>Cette classe permet de gérer des <code>Skins</code>:</b>
	 * <ul>
	 * 	<li>Ajouter un <code>Skin</code> aux assets en l'associant à un nom</li>
	 *  <li>Recupérer un <code>Skin</code> par son nom</li>
	 * </ul>
	 * <b>Cette classe permet de gérer des <code>Slice9Bitmaps</code>:</b>
	 * <ul>
	 * 	<li>Ajouter un <code>Slice9Bitmap</code> aux assets en l'associant à un nom</li>
	 *  <li>Recupérer un <code>Slice9Bitmap</code> par son nom</li>
	 *  <li>Ajouter un <code>Slice9BitmapMovie</code> aux assets en l'associant à un nom</li>
	 *  <li>Recupérer un <code>Slice9BitmapMovie</code> par son nom</li>
	 * </ul>
	 * <strong>Exemple: </strong>
	 * 
	 * <listing>
public class _test_AssetsManager extends Sprite
{
	public var tf:TextField = new TextField();
	
	public function _test_AssetsManager()
	{
		addChild( tf );
		tf.autoSize = 'left';
		
		// loading du SWF qui contient les fonts
		var loader:SWFLoader = new SWFLoader('assets/fonts.swf', {onComplete:_onCompleteHandler});
		loader.load();
	}
	
	private function _onCompleteHandler( evt:LoaderEvent ):void
	{
		var vb:Class = SWFLoader(evt.target).getClass( 'FontVerdanaBold' );
		var vr:Class = SWFLoader(evt.target).getClass( 'FontVerdanaRegular' );
		var vbi:Class = SWFLoader(evt.target).getClass( 'FontVerdanaBoldItalic' );
		var vi:Class = SWFLoader(evt.target).getClass( 'FontVerdanaItalic' );
		
		//add font va faire Font.registerFont(xx) pour nous
		AssetsManager.addFont( 'verdanaBold', vb );
		AssetsManager.addFont( 'verdanaRegular', vr );
		AssetsManager.addFont( 'verdanaBoldItalic', vbi );
		AssetsManager.addFont( 'verdanaItalic', vi );
		
		drawText();
	}
	
	private function drawText():void
	{
		var f:TextFormat = new TextFormat();
		
		// on récupere juste le nom de la font, les font étant enregistrés, 
		// on peut utiliser du bold, du régular, de 'litalic...
		f.font = AssetsManager.getFontName( 'verdanaBold' ); 	
		f.bold = true;
		f.size = 12;
		
		tf.embedFonts = true;
		tf.defaultTextFormat = f;
		tf.text = 'azertyuiopqsdfghjklmwxcvbnéèçà';
		
		// ici on peut en profiter pour enregistrer le textFormat comme ca on aura plus à le recreer.
		AssetsManager.addTextFormat( 'TFButtons', f );	
	}
} 
</listing> 
	 * 
	 * @author Benjamin BOUFFIER
	 * **/
	public class AssetsManager
	{
		/** utilisé pour incrémenter les noms en cas de nom déjà existants **/
		private static var _$increment		: uint 			= 0;
		/** @private Le dico pour garder les <code>BitmapData</code> **/
		private static var _$bitmapDatas	: Dictionary 	= new Dictionary(true);
		/** @private Le dico pour garder les <code>Sound</code> **/
		private static var _$sounds			: Dictionary 	= new Dictionary(true);
		/** @private Le dico pour garder les <code>ApplicationDomain</code> **/
		private static var _$appDomains		: Dictionary 	= new Dictionary(true);
		/** @private Le dico pour les <code>DisplayObject</code> **/
		private static var _$clips			: Dictionary 	= new Dictionary(true);
		/** @private Le dico pour garder les <code>Font</code> **/
		private static var _$fonts			: Dictionary 	= new Dictionary(true);
		/** @private Le dico pour garder les <code>TextFormat</code> **/
		private static var _$tformats		: Dictionary 	= new Dictionary(true);
		/** @private Le dico pour garder les <code>Skins</code> **/
		private static var _$skins			: Dictionary 	= new Dictionary(true);
		/** @private Le dico pour garder les <code>Slice9Bitmap</code> **/
		private static var _$sliceClip		: Dictionary 	= new Dictionary(true);
		/** @private Le dico pour garder les <code>Slice9BitmapMovie</code> **/
		private static var _$sliceClipMovie	: Dictionary 	= new Dictionary(true);
		
//--------------//--------------------------------------------------------------------------------------------------------
// BITMAP_DATAS //--------------------------------------------------------------------------------------------------------
//--------------//--------------------------------------------------------------------------------------------------------
		
		/**
		 * <p>Ajoute un <code>BitmapData</code> au dictionnaire.</p>
		 * 
		 * @param name Le nom associé au <code>BitmapData</code> pour le récuperer par la suite. <br />
		 * (Si le nom est déja utilisé le nom sera changé en name1 ou name2 ...)
		 * @param value Le <code>BitmapData</code>.
		 * @param override si <code>true</code> et que le nom est déja dans le dico, la valeur sera remplacée.
		 * ( défaut <code>false</code> )
		 * <p></p>
		 * @return le nom associé au <code>BitmapData</code>. <br />
		 * ( Au cas ou le nom soit incrémenté c'est pratique de récuperer le bon nom ).
		 * */
		public static function addBitmapData( name:String, value:BitmapData, override:Boolean = false ):String
		{
			if( _$bitmapDatas[name] && !override ) 
			{
				if		( _$bitmapDatas[name] == value )	return name;
				else if	( _$bitmapDatas[name] != null )		return addBitmapData( name+(_$increment++), value );
			}
			
			_$increment = 0;
			_$bitmapDatas[name] = value;
			
			return name;
		}
		
		/**
		 * <p>Récuperer un <code>BitmapData</code> par son nom.</p>
		 * 
		 * @param name Le nom associé au <code>BitmapData</code> que l'on veut récuperer.
		 * <p></p>
		 * @return Le <code>BitmapData</code> demandé s'il est dans la liste, sinon retourne <code>null</code>
		 * */
		public static function getBitmapData( name:String ):BitmapData
		{
			if( _$bitmapDatas && _$bitmapDatas[name] )	return _$bitmapDatas[name];
			
			return null;
		}
		
		/**
		 * <p>Récuperer un <code>Bitmap</code> par le nom de son <code>BitmapData</code>. <br />
		 * Retourne <code> new Bitmap( getBitmapData(name) ); </code></p>
		 * 
		 * @param name Le nom associé au <code>BitmapData</code> que l'on veut récuperer.
		 * <p></p>
		 * @return Le <code>Bitmap</code> demandé s'il est dans la liste, sinon retourne <code>null</code>
		 * */
		public static function getBitmap( name:String ):Bitmap
		{
			if( _$bitmapDatas && _$bitmapDatas[name] )	return new Bitmap( _$bitmapDatas[name] );
			
			return null;
		}
		
//--------------//--------------------------------------------------------------------------------------------------------
//    SOUNDS    //--------------------------------------------------------------------------------------------------------
//--------------//--------------------------------------------------------------------------------------------------------
		
		/**
		 * <p>Ajoute un <code>Sound</code> au dictionnaire.</p>
		 * 
		 * @param name Le nom associé au <code>Sound</code> pour le récuperer par la suite. <br />
		 * (Si le nom est déja utilisé le nom sera changé en name1 ou name2 ...)
		 * @param value Le <code>Sound</code>.
		 * @param override si <code>true</code> et que le nom est déja dans le dico, la valeur sera remplacée.
		 * ( défaut <code>false</code> )
		 * <p></p>
		 * @return le nom associé au <code>Sound</code>. <br />
		 * ( Au cas ou le nom soit incrémenté c'est pratique de récuperer le bon nom ).
		 * */
		public static function addSound( name:String, value:Sound, override:Boolean = false ):String
		{
			if( _$sounds[name] && !override ) 
			{
				if		( _$sounds[name] == value )		return name;
				else if	( _$sounds[name] != null )		return addSound( name+(_$increment++), value );
			}
			
			_$increment = 0;
			_$sounds[name] = value;
			
			return name;
		}
		
		/**
		 * <p>Récuperer un <code>Sound</code> par son nom.</p>
		 * 
		 * @param name Le nom associé au <code>Sound</code> que l'on veut récuperer.
		 * <p></p>
		 * @return Le <code>Sound</code> demandé s'il est dans la liste, sinon retourne <code>null</code>
		 * */
		public static function getSound( name:String ):Sound
		{
			if( _$sounds && _$sounds[name] )	return _$sounds[name];
			
			return null;
		}
		
//--------------//--------------------------------------------------------------------------------------------------------
//     SWFS     //--------------------------------------------------------------------------------------------------------
//--------------//--------------------------------------------------------------------------------------------------------
		
		/**
		 * <p>Ajoute un <code>ApplicationDomain</code> au dictionnaire.<br />
		 * L'<code>ApplicationDomain</code> est le groupe de définition des classes d'un swf,
		 * on peut ainsi récuperer dedans toutes les classes du swf swf chargé.</p>
		 * 
		 * @param name Le nom associé au swf pour le récuperer par la suite. <br />
		 * (Si le nom est déja utilisé le nom sera changé en name1 ou name2 ...)
		 * @param value L'<code>ApplicationDomain</code>.
		 * @param override si <code>true</code> et que le nom est déja dans le dico, la valeur sera remplacée.
		 * ( défaut <code>false</code> )
		 * <p></p>
		 * @return le nom associé au swf. <br />
		 * ( Au cas ou le nom soit incrémenté c'est pratique de récuperer le bon nom ).
		 * */
		public static function addSWF( name:String, value:ApplicationDomain, override:Boolean = false ):String
		{
			if( _$appDomains[name] && !override ) 
			{
				if		( _$appDomains[name] == value )		return name;
				else if	( _$appDomains[name] != null )		return addSWF( name+(_$increment++), value );
			}
			
			_$increment = 0;
			_$appDomains[name] = value;
			
			return name;
		}
		
		/**
		 * <p>Récuperer un <code>ApplicationDomain</code> par son nom.</p>
		 * 
		 * @param name Le nom associé au <code>ApplicationDomain</code> que l'on veut récuperer.
		 * <p></p>
		 * @return Le <code>ApplicationDomain</code> demandé s'il est dans la liste, sinon retourne <code>null</code>
		 * */
		public static function getSWF( name:String ):ApplicationDomain
		{
			if( _$appDomains && _$appDomains[name] )	return _$appDomains[name];
			
			return null;
		}
		
		/**
		 * <p>Récuperer une <code>Class</code> par le nom de son swf et son nom.</p>
		 * 
		 * @param name Le nom associé au swf dans lequel on veut récuperer la classe.
		 * @param classe Le nom de la classe à récuperer.
		 * <p></p>
		 * @return La <code>Class</code> demandée si le swf est dans la liste et que cette classe existe, sinon retourne <code>null</code>
		 * */
		public static function getSWFClass( name:String, classe:String ):Class
		{
			if( _$appDomains && _$appDomains[name] )
			{
				return _$appDomains[name].getDefinition( classe );
			}
			
			return null;
		}
		
		/**
		 * <p>Récuperer une instance d'une <code>Class</code> par le nom de son swf et son nom.</p>
		 * 
		 * @param name Le nom associé au swf dans lequel on veut récuperer la classe.
		 * @param classe Le nom de l'instance de la classe à récuperer.
		 * <p></p>
		 * @return L'instance de la <code>Class</code> demandée si le swf est dans la liste et que cette classe existe, sinon retourne <code>null</code>
		 * */
		public static function getSWFObject( name:String, classe:String ):*
		{
			if( _$appDomains && _$appDomains[name] )
			{
				return new (_$appDomains[name].getDefinition( classe ))();
			}
			
			return null;
		}
		
//-----------------//--------------------------------------------------------------------------------------------------------
// DISPLAY OBJECTS //--------------------------------------------------------------------------------------------------------
//-----------------//--------------------------------------------------------------------------------------------------------
		
		/**
		 * <p>Ajoute un <code>DisplayObject</code> au dictionnaire.</p>
		 * 
		 * @param name Le nom associé au <code>DisplayObject</code> pour le récuperer par la suite. <br />
		 * (Si le nom est déja utilisé le nom sera changé en name1 ou name2 ...)
		 * @param value Le <code>DisplayObject</code>.
		 * @param override si <code>true</code> et que le nom est déja dans le dico, la valeur sera remplacée.
		 * ( défaut <code>false</code> )
		 * <p></p>
		 * @return le nom associé au <code>DisplayObject</code>. <br />
		 * ( Au cas ou le nom soit incrémenté c'est pratique de récuperer le bon nom ).
		 * */
		public static function addClip( name:String, value:DisplayObject, override:Boolean = false ):String
		{
			if( _$clips[name] && !override ) 
			{
				if		( _$clips[name] == value )		return name;
				else if	( _$clips[name] != null )		return addClip( name+(_$increment++), value );
			}
			
			_$increment = 0;
			_$clips[name] = value;
			
			return name;
		}
		
		/**
		 * <p>Récuperer un <code>DisplayObject</code> par son nom.</p>
		 * 
		 * @param name Le nom associé au <code>DisplayObject</code> que l'on veut récuperer.
		 * <p></p>
		 * @return Le <code>DisplayObject</code> demandé s'il est dans la liste, sinon retourne <code>null</code>
		 * */
		public static function getClip( name:String ):DisplayObject
		{
			if( _$clips && _$clips[name] )	return _$clips[name];
			return null;
		}
		
		
//--------------//--------------------------------------------------------------------------------------------------------
//    FONTS     //--------------------------------------------------------------------------------------------------------
//--------------//--------------------------------------------------------------------------------------------------------
	
		/**
		 * <p>Ajoute une <code>Font</code> au dictionnaire.</p>
		 * 
		 * @param name Le nom associé à la <code>Font</code> pour le récuperer par la suite. <br />
		 * (Si le nom est déja utilisé le nom sera changé en name1 ou name2 ...)
		 * @param value La <code>Class</code> de la font.
		 * @param override si <code>true</code> et que le nom est déja dans le dico, la valeur sera remplacée.
		 * ( défaut <code>false</code> )
		 * <p></p>
		 * @return le nom associé à la <code>Font</code>. <br />
		 * ( Au cas ou le nom soit incrémenté c'est pratique de récuperer le bon nom ).
		 * */
		public static function addFont( name:String, value:Class, override:Boolean = false ):String
		{
			if( _$fonts[name] && !override ) 
			{
				if		( _$fonts[name] == value )		return name;
				else if	( _$fonts[name] != null )		return addFont( name+(_$increment++), value );
			}
			
			_$increment 	= 0;
			_$fonts[name] 	= new value();
			
			Font.registerFont( value );
			
			return name;
		}
		
		/**
		 * <p>Récuperer une <code>Font</code> par son nom.</p>
		 * 
		 * @param name Le nom associé à la <code>Font</code> que l'on veut récuperer.
		 * <p></p>
		 * @return La <code>Font</code> demandé s'il est dans la liste, sinon retourne <code>null</code>
		 * */
		public static function getFont( name:String ):Font
		{
			if( _$fonts && _$fonts[name] )	return _$fonts[name];
			return null;
		}
		
		/**
		 * <p>Récuperer le nom de la <code>Font</code> par son nom.</p>
		 * 
		 * @param name Le nom associé à la <code>Font</code> que l'on veut récuperer.
		 * <p></p>
		 * @return La <code>Font</code> demandé s'il est dans la liste, sinon retourne <code>null</code>
		 * */
		public static function getFontName( name:String ):String
		{
			if( _$fonts && _$fonts[name] )	return Font(_$fonts[name]).fontName;
			return null;
		}
		
//--------------//--------------------------------------------------------------------------------------------------------
//    FONTS     //--------------------------------------------------------------------------------------------------------
//--------------//--------------------------------------------------------------------------------------------------------
		
		/**
		 * <p>Ajoute un <code>TextFormat</code> au dictionnaire.</p>
		 * 
		 * @param name Le nom associé au <code>TextFormat</code> pour le récuperer par la suite. <br />
		 * (Si le nom est déja utilisé le nom sera changé en name1 ou name2 ...)
		 * @param value Le <code>TextFormat</code>.
		 * @param override si <code>true</code> et que le nom est déja dans le dico, la valeur sera remplacée.
		 * ( défaut <code>false</code> )
		 * <p></p>
		 * @return le nom associé au <code>TextFormat</code>. <br />
		 * ( Au cas ou le nom soit incrémenté c'est pratique de récuperer le bon nom ).
		 * */
		public static function addTextFormat( name:String, value:TextFormat, override:Boolean = false ):String
		{
			if( _$tformats[name] && !override ) 
			{
				if		( _$tformats[name] == value )		return name;
				else if	( _$tformats[name] != null )		return addTextFormat( name+(_$increment++), value );
			}
			
			_$increment 		= 0;
			_$tformats[name] 	= value;
			
			return name;
		}
		
		/**
		 * <p>Récuperer un <code>TextFormat</code> par son nom.</p>
		 * 
		 * @param name Le nom associé au <code>TextFormat</code> que l'on veut récuperer.
		 * <p></p>
		 * @return Le <code>TextFormat</code> demandé s'il est dans la liste, sinon retourne <code>null</code>
		 * */
		public static function getTextFormat( name:String ):TextFormat
		{
			if( _$tformats && _$tformats[name] )	return _$tformats[name];
			return null;
		}
		
//--------------//--------------------------------------------------------------------------------------------------------
//    SKINS     //--------------------------------------------------------------------------------------------------------
//--------------//--------------------------------------------------------------------------------------------------------
		
		/**
		 * <p>Ajoute un <code>Skin</code> au dictionnaire.</p>
		 * 
		 * @param name Le nom associé au <code>Skin</code> pour le récuperer par la suite. <br />
		 * (Si le nom est déja utilisé le nom sera changé en name1 ou name2 ...)
		 * @param value Le <code>Skin</code>, un Object.
		 * @param override si <code>true</code> et que le nom est déja dans le dico, la valeur sera remplacée.
		 * ( défaut <code>false</code> )
		 * <p></p>
		 * @return le nom associé au <code>Skin</code>. <br />
		 * ( Au cas ou le nom soit incrémenté c'est pratique de récuperer le bon nom ).
		 * */
		public static function addSkin( name:String, value:Object, override:Boolean = false ):String
		{
			if( _$skins[name] && !override ) 
			{
				if		( _$skins[name] == value )		return name;
				else if	( _$skins[name] != null )		return addSkin( name+(_$increment++), value );
			}
			
			_$increment 	= 0;
			_$skins[name] 	= value;
			
			return name;
		}
		
		/**
		 * <p>Récuperer un <code>Skin</code> par son nom.</p>
		 * 
		 * @param name Le nom associé au <code>Skin</code> que l'on veut récuperer.
		 * <p></p>
		 * @return Le <code>Skin</code> demandé s'il est dans la liste, sinon retourne <code>null</code>
		 * */
		public static function getSkin( name:String ):Object
		{
			if( _$skins && _$skins[name] )	return _$skins[name];
			return null;
		}
		
//---------------------//--------------------------------------------------------------------------------------------------------
//    Slice9Bitmap     //--------------------------------------------------------------------------------------------------------
//---------------------//--------------------------------------------------------------------------------------------------------
		
		/**
		 * <p>Ajoute un <code>Slice9Bitmap</code> au dictionnaire.</p>
		 * 
		 * @param name Le nom associé au <code>Slice9Bitmap</code> pour le récuperer par la suite. <br />
		 * (Si le nom est déja utilisé le nom sera changé en name1 ou name2 ...)
		 * @param value Le <code>Slice9Bitmap</code>, un Object.
		 * @param override si <code>true</code> et que le nom est déja dans le dico, la valeur sera remplacée.
		 * ( défaut <code>false</code> )
		 * <p></p>
		 * @return le nom associé au <code>Slice9Bitmap</code>. <br />
		 * ( Au cas ou le nom soit incrémenté c'est pratique de récuperer le bon nom ).
		 * */
		public static function addSlice9Bitmap( name:String, value:Slice9Bitmap, override:Boolean = false ):String
		{
			if( _$sliceClip[name] && !override ) 
			{
				if		( _$sliceClip[name] == value )		return name;
				else if	( _$sliceClip[name] != null )		return addSlice9Bitmap( name+(_$increment++), value );
			}
			
			_$increment 		= 0;
			_$sliceClip[name] 	= value;
			
			return name;
		}
		
		/**
		 * <p>Ajoute un <code>Slice9Bitmap</code> au dictionnaire.</p>
		 * 
		 * @param name Le nom associé au <code>Slice9Bitmap</code> pour le récuperer par la suite. <br />
		 * (Si le nom est déja utilisé le nom sera changé en name1 ou name2 ...)
		 * @param value Le <code>Slice9Bitmap</code>, un Object.
		 * @param override si <code>true</code> et que le nom est déja dans le dico, la valeur sera remplacée.
		 * ( défaut <code>false</code> )
		 * <p></p>
		 * @return le nom associé au <code>Slice9Bitmap</code>. <br />
		 * ( Au cas ou le nom soit incrémenté c'est pratique de récuperer le bon nom ).
		 * */
		public static function addSlice9BitmapMovie( name:String, value:Slice9BitmapMovie, override:Boolean = false ):String
		{
			if( _$sliceClipMovie[name] && !override ) 
			{
				if		( _$sliceClipMovie[name] == value )		return name;
				else if	( _$sliceClipMovie[name] != null )		return addSlice9BitmapMovie( name+(_$increment++), value );
			}
			
			_$increment 			= 0;
			_$sliceClipMovie[name] 	= value;
			
			return name;
		}
		
		/**
		 * <p>Récuperer un <code>Slice9Bitmap</code> par son nom.</p>
		 * <em>Note: Si le <code>Slice9Bitmap</code> n'as pas été ajouté à l'assets manager on va essayer de trouver 
		 * un clip avec ce nom et de créer le <code>Slice9Bitmap</code> à partir de ce clip, 
		 * la fois suivante le clip sera créé et on pourra le récuperer directement.</em>
		 * <p></p>
		 * @param name Le nom associé au <code>Skin</code> que l'on veut récuperer.
		 * <p></p>
		 * @return Le <code>Skin</code> demandé s'il est dans la liste, sinon retourne <code>null</code>
		 * */
		public static function getSlice9Bitmap( name:String ):Slice9Bitmap
		{
			if( _$sliceClip && _$sliceClip[name] )	return _$sliceClip[name].clone();
			else if( _$clips && _$clips[name] )			
			{
				addSlice9Bitmap( name, new Slice9Bitmap( _$clips[name] ) );
				return getSlice9Bitmap(name);
			}
			
			return null;
		}
		
		/**
		 * <p>Récuperer un <code>Slice9BitmapMovie</code> par son nom.</p>
		 * <em>Si le <code>Slice9BitmapMovie</code> n'as pas été ajouté à l'assets manager on va essayer de trouver 
		 * un clip avec ce nom et de créer le <code>Slice9BitmapMovie</code> à partir de ce clip, 
		 * la fois suivante le clip sera créé et on pourra le récuperer directement.</em>
		 * <p></p>
		 * @param name Le nom associé au <code>Slice9BitmapMovie</code> que l'on veut récuperer.
		 * <p></p>
		 * @return Le <code>Slice9BitmapMovie</code> demandé s'il est dans la liste, sinon retourne <code>null</code>
		 * */
		public static function getSlice9BitmapMovie( name:String ):Slice9BitmapMovie
		{
			if( _$sliceClipMovie && _$sliceClipMovie[name] )	return _$sliceClipMovie[name].clone();
			else if( _$clips && _$clips[name] )	
			{
				addSlice9BitmapMovie( name, new Slice9BitmapMovie( _$clips[name] ) );
				return getSlice9BitmapMovie(name);
			}
			
			return null;
		}
		
		
		public static function getBitmapClip( name:String ):BitmapClip
		{
			if( _$bitmapDatas && _$bitmapDatas[name] )			
			{
				var b:BitmapClip = new BitmapClip();
				b.bitmapData = _$bitmapDatas[name];
				
				return b;
			}
			
			return null;
		}
	}
}