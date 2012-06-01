package com.lagoon.utils.texte
{
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	
	/** 
	 * Change les couleurs d'un champ texte
	 * 
	 * @author Benjamin BOUFFIER
	 * */
	public class TextFieldColor 
	{
		/** @rpivate **/
		private static const _$BYTE_TO_PERC	:Number = 1 / 0xff;
		/** @rpivate **/
		private var _textField				:TextField;
		/** @rpivate **/
		private var _textColor				:uint;
		/** @rpivate **/
		private var _selectedColor			:uint;
		/** @rpivate **/
		private var _selectionColor			:uint;
		/** @rpivate **/
		private var _colorMatrixFilter		:ColorMatrixFilter;
		
		/**
		 * Change les couleurs d'un champ texte.
		 * 
		 * @param textField le champ texte à modifier.
		 * @param textColor la couleur du texte souhaitée.
		 * @param selectionColor la couleur du surlignage de selection.
		 * @param selectedColor la couleur du texte surligné.
		 * */
		public function TextFieldColor( textField:TextField, textColor:uint = 0x000000, selectionColor:uint = 0x000000, selectedColor: uint = 0x000000 ) 
		{
			_textField 			= textField;
			
			_colorMatrixFilter 	= new ColorMatrixFilter();
			_textColor 			= textColor;
			_selectionColor 	= selectionColor;
			_selectedColor 		= selectedColor;
			
			updateFilter();
		}
		
		/**
		 * le champ texte affecté par le changement de couleur.
		 * */
		public function get textField():TextField 
		{
			return _textField;
		}
		
		/**
		 * la couleur du texte.
		 * */
		public function set textColor(c:uint):void 
		{
			_textColor = c;
			updateFilter();
		}
		public function get textColor():uint 
		{
			return _textColor;
		}
		
		/**
		 * la couleur du surlignage de selection.
		 * */
		public function set selectionColor(c:uint):void 
		{
			_selectionColor = c;
			updateFilter();
		}
		public function get selectionColor():uint 
		{
			return _selectionColor;
		}
		
		/**
		 * la couleur du texte surligné.
		 * */
		public function set selectedColor(c:uint):void 
		{
			_selectedColor = c;
			updateFilter();
		}
		public function get selectedColor():uint 
		{
			return _selectedColor;
		}
		
		/**
		 * @private
		 * la méthode appelée pour mettre à jour les couleurs du champ texte
		 * */
		private function updateFilter():void 
		{
			
			_textField.textColor = 0xff0000;
			
			var o:Array = splitRGB(_selectionColor);
			var r:Array = splitRGB(_textColor);
			var g:Array = splitRGB(_selectedColor);
			
			var ro:int = o[0];
			var go:int = o[1];
			var bo:int = o[2];
			
			var rr:Number = ((r[0] - 0xff) - o[0]) * _$BYTE_TO_PERC + 1;
			var rg:Number = ((r[1] - 0xff) - o[1]) * _$BYTE_TO_PERC + 1;
			var rb:Number = ((r[2] - 0xff) - o[2]) * _$BYTE_TO_PERC + 1;
			
			var gr:Number = ((g[0] - 0xff) - o[0]) * _$BYTE_TO_PERC + 1 - rr;
			var gg:Number = ((g[1] - 0xff) - o[1]) * _$BYTE_TO_PERC + 1 - rg;
			var gb:Number = ((g[2] - 0xff) - o[2]) * _$BYTE_TO_PERC + 1 - rb;
			
			_colorMatrixFilter.matrix = [ 	rr, 	gr, 	0, 		0, 
											ro, 	rg, 	gg, 	0, 
											0, 		go,	 	rb, 	gb, 
											0, 		0, 		bo, 	0, 
											0, 		0, 		1, 		0   ];
			
			_textField.filters = [_colorMatrixFilter];
		}
		
		/**
		 * @private
		 * transforme une couleur uint rgb en un tableau [r,g,b].
		 * */
		private static function splitRGB(color:uint):Array
		{
			return [color >> 16 & 0xff, color >> 8 & 0xff, color & 0xff];
		}
	}
}