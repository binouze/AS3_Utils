package binou.utils.texte
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	
	/**
	 * Inserer des images dans un champs texte au format html en utilisant des balises <code><img /></code>.<br/>
	 * Flash ne gere pas les images 'inline' dans un champ texte, 
	 * cette classe permet d'inserer des espaces à la place de ces images et d'y mettre les images par dessus.
	 * 
	 * @author Benjamin BOUFFIER
	 * */
	public class ImgPositioner extends Sprite
	{
		private var _htmlArr		:Array;		// le tableau contenant les balises img
		private var _htmlArrId		:int;		// l'image actuellement traitée
		private var _idx			:int;		// position de l'image actuelle
		private var _sp				:String;	// la chaine d'espaces actuelle
		private var _spaceWidth		:Number;	// la largeur d'un espace
		private var _imgVspace		:int;		// l'espacement vertical entre le texte à gauche et l'image elle meme
		private var _imageLines		:Array;
		
		private var _images			:Vector.<DisplayObject>;
		private var _imagesId		:Vector.<int>;
		private var _tf				:TextField;
		
		public function ImgPositioner( textField:TextField )
		{
			_tf = textField;
			
			if( _tf.parent )
			{
				this.addChildTo( _tf.parent );
				this.addChild( _tf );
			}
			
			this.x 	= _tf.x;
			this.y 	= _tf.y;
			_tf.x 	= 0;
			_tf.y 	= 0;
		}
		
		/** 
		 * Modifier le texte au format html du TextField
		 * */
		public function set texte(htmlStr:String):void
		{
			trace( htmlStr );
			
			_htmlArr 	= [];
			_imageLines = [];
			
			var i			:int;
			var j			:int;
			var indexStart	:int 	= 0;
			var indexFinish	:int 	= 0;
			
			while( i <= htmlStr.length - 1 )
			{
				if( htmlStr.substring(i, i + 4) == "<img" )
				{
					indexFinish = i;
					_htmlArr.push( htmlStr.substring(indexStart, indexFinish) );
					indexStart 	= i;
					
					j = indexStart;
					while( htmlStr.substring(j, j + 2) != "/>" )
					{
						j++;
					}
					
					_htmlArr.push( htmlStr.substring(indexStart, j + 2) );
					i = j + 1;
					indexStart = j + 2;
				}
				
				i++;
			}
			
			_htmlArr.push( htmlStr.substring(indexStart, i) );
			_images 	= new Vector.<DisplayObject>( _htmlArr.length, true );
			_imagesId 	= new Vector.<int>( _htmlArr.length, true );
			_getImageSrc(0);
		}
		
		/** @private **/
		private function _getImageSrc(id:uint):void
		{
			_htmlArrId = id;
			//trace( '_getImageSrc(', _htmlArrId, ')' );
			
			if( _htmlArr[id] )
			{
				if( _htmlArr[id].substring(0, 4) == "<img" )
				{
					var srcArr		:Array = [];
					var srcValueArr	:Array = [];
					var vspaceArr	:Array = [];
					
					srcArr 		= _htmlArr[id].split("src='");
					srcValueArr = srcArr[1].split("'");
					vspaceArr 	= _htmlArr[id].split("vspace='");
					
					if( vspaceArr[1] )
					{
						var vspaceValueArr:Array = [];
						
						vspaceValueArr 	= vspaceArr[1].split("'");
						_imgVspace 		= vspaceValueArr[0];
					}
					else
					{
						_imgVspace = -1;
					}
					
					var req:URLRequest 	= new URLRequest( srcValueArr[0] );
					var loader:Loader 	= new Loader();
					loader.contentLoaderInfo.addEventListener( Event.COMPLETE, 			_getImage );
					loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, 	_onImageError );
					loader.load( req );
				}
				else
				{
					_getImageSrc( ++id );
				}
			}
			else
			{
				var i:int 		= 0;
				var s:String 	= '';
				while( _htmlArr[i] )
				{
					s += _htmlArr[i++];
				}
				_tf.htmlText = s;
				setFrameout( _processline, 2 );
				dispatchEvent( new Event("finish") );
			}
		}
		
		protected function _onImageError(event:IOErrorEvent):void
		{
			trace( '_onImageError(', _htmlArrId, ')' );
			_getImageSrc(++_htmlArrId);
		}
		
		/** @private **/
		private function _getImage( evt:Event ):void
		{
			//trace( '_getImage(', _htmlArrId, ')' );
			
			_images[_htmlArrId] 	= LoaderInfo( evt.target ).content;		// enregistrement de l'image
			_htmlArr[_htmlArrId] 	= '[+] ';								// remplacer la balise par une chaine retrouvable facilement
			
			// mettre a jour le texte afin de pouvoir définir la taille d'un espace à cet endroit
			var i:uint = 0;
			var s:String = '';
			while( _htmlArr[i] )
			{
				s += _htmlArr[i++];
			}
			_tf.htmlText = s;
			
			setFrameout( _getSpaceWidth, 1 );
		}
		
		private function _getSpaceWidth():void
		{
			var i:int 		= 0;
			var index:int 	= _tf.text.search( '[+]' ) + 2;
			_spaceWidth 	= _tf.getCharBoundaries(index).width;					// récupération de la largeur d'un espace
			var ligne:int 	= _tf.getLineIndexOfChar( index-2 );
			
			if( !_imageLines[ligne] )	_imageLines[ligne] = [];
			_imageLines[ligne].push( _htmlArrId );
			
			_sp = '';
			var space:int = _imgVspace != -1 ? _imgVspace * 2 : 10;					// calcul des marges
			var numSpaces:int = (_images[_htmlArrId].width+space) / _spaceWidth;	// calcul du nombre d'espaces nécéssaire
			
			// création de la chaine espace
			for( i = 0; i<numSpaces; i++ )
			{
				_sp += ' ';
			}
			
			_htmlArr[_htmlArrId] = _sp;												// hop on met les espaces a la place de l'image
			
			// mettre a jour le texte afin de pouvoir positionner l'image
			i=0;
			var s:String = '';
			while (_htmlArr[i])
			{
				s += _htmlArr[i];
				i++;
			}
			_tf.htmlText = s;
			
			//_idx = index-2;
			_imagesId[_htmlArrId] = index-2;
			_getImageSrc( ++_htmlArrId );
		}
		
		private var _actualLine	:int = 0;
		private function _processline():void
		{
			if( _actualLine > _tf.numLines )	
			{
				_placeImgs();
				return;
			}
			
			var thisLineImgs:Array 	= _imageLines[_actualLine];
			var nextLineImgs:Array 	= _imageLines[_actualLine+1];
			
			if( !thisLineImgs )	thisLineImgs 	= [];
			if( !nextLineImgs )	nextLineImgs 	= [];
			
			var lineImgs:Array = thisLineImgs.concat( nextLineImgs );
			
			// si aucune image sur cette ligne
			if( !lineImgs || lineImgs.length == 0 )	
			{
				_actualLine++;
				setFrameout( _processline, 2 );
				return;
			}
			
			var img		:int 		= getHighestPic( lineImgs );
			var begin	:int		= _tf.getLineOffset( _actualLine+1 );
			var length	:int 		= _tf.getLineLength( _actualLine+1 );
			var bnds	:Rectangle 	= _tf.getCharBoundaries( begin );
			
			var add:int = 1;
			while( !bnds && add<3 )	
			{
				bnds = _tf.getCharBoundaries( add++ );
			}
			
			if( !bnds )	
			{
				_actualLine++;
				setFrameout( _processline, 2 );
				return;
			}
			var numBr	:int 		= _images[img].height / 2 / bnds.height;
			var brs		:String 	= '<br/>';
			var milieu	:Array		= [];
			
			for( var j:int = 0; j<numBr; j++ )
			{
				brs += '<br/>';
				milieu.push( null );
			}
			
			var debut	:Array 	= _imageLines.slice(0,_actualLine+1);
			var fin		:Array 	= _imageLines.slice(_actualLine+1);
			_imageLines = debut.concat( milieu ).concat(fin);
			
			var firstCharTxt:String = _tf.text.charAt( begin+length+1 );
			var firstCharHtml:String = _tf.htmlText.charAt( findHTMLindex( begin+length+1, _tf.htmlText ) );
			
			var ind:int 	= findHTMLindex( begin+length, _tf.htmlText );
			var str:String 	= _tf.htmlText.slice(0, ind) + brs + _tf.htmlText.slice(ind);
			
			_tf.htmlText 	= str;
			
			if( numBr < 1 )	numBr = 1;
			
			for( var a:int = _actualLine+1; a<_imageLines.length; a++ )
			{
				if( _imageLines[a] )
				{
					for( var b:int = 0; b<_imageLines[a].length; b++ )
					{
						if( _imagesId[ _imageLines[a][b] ] )
						{
							_imagesId[ _imageLines[a][b] ] += numBr;
						}
					}
				}
			}
			
			_actualLine += numBr+1;
			setFrameout( _processline, 2 );
		}
		
		private function _placeImgs():void
		{
			for( var i:int = 0; i<_images.length; i++ )
			{
				if( !_images[i] )	continue;
				
				var bounds:Rectangle 	= _tf.getCharBoundaries(_imagesId[i]);
				
				if( !bounds )	continue;
				var lastSpaceIndex:int 	= _imagesId[i];
				while( _tf.text.charAt(lastSpaceIndex) == ' ' )
				{
					lastSpaceIndex++;
				}
				var bound:Rectangle = _tf.getCharBoundaries(lastSpaceIndex);
				var num:int = 0;
				while( !bound )
				{
					num++;
					bound = _tf.getCharBoundaries(--lastSpaceIndex);
				}
				var spWidth:int = ( bound.x-(num*bounds.width) ) - bounds.x;
				
				_images[i].x 	= bounds.x + ( (spWidth - _images[i].width)>>1 );
				_images[i].y 	= bounds.y - ( (_images[i].height-bounds.height)>>1 );
				_images[i].alpha = 0.5;
				addChild( _images[i] );
			}
		}
		
		private function getHighestPic(images:Array):int
		{
			var img:DisplayObject = _images[ images[0] ];
			var id:int = 0;
			for( var i:int = 1; i<images.length; i++ )
			{
				if( _images[ images[i] ].height > _images[ images[id] ].height )	
				{
					id = i;
				}
			}
			
			return images[id];
		}
	}
}