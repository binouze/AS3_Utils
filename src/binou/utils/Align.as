package binou.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author Benjamin BOUFFIER
	 */
	public class Align
	{
		public function Align(){}
		
		/**
		 * Retourne un rectangle image d'un conteneur avec des marges.
		 * @param clip le clip duquel on veut les bounds;
		 * @param targetCoordinateSpace les coordonnées a partir desquelles on veut les bounds.
		 * @param top la marge en haut.
		 * @param right la marge à droite.
		 * @param bottom la marge en bas.
		 * @param left la marge à gauche.
		 * 
		 * @return le rectangle des limites du clip+marges dans les coordonnées targetCoordinateSpace.
		 **/ 
		public static function getMarginBounds( clip:DisplayObject, targetCoordinateSpace:DisplayObject, top:int = 0, right:int = 0, bottom:int = 0, left:int = 0 ):Rectangle
		{
			var r:Rectangle = clip.getBounds(targetCoordinateSpace);
			
			r.x += left;
			r.y += top;
			r.width -= (left+right);
			r.height -= (top+bottom);
			
			return r;
		}
		/**
		 * Aligner un élément dans un conteneur.
		 * @param clip l'objet à aligner.
		 * @param conteneur le conteneur dans lequel on doit aligner l'objet 
		 * (utilisez getMarginBounds(...) pour obtenir un rectangle d'un conteneur en y ajoutant des marges).
		 * @param method un string indiquand comment doit etre centré le clip dans le conteneur:
		 * 	<ul>
		 * 		<li>tl -> top left align</li>
		 *  	<li>cl -> center left align</li>
		 *  	<li>bl -> bottom left align</li>
		 *  	<li>tm -> top middle align</li>
		 *  	<li>cm -> center middle align</li>
		 * 		<li>bm -> bottom middle align</li>
		 *  	<li>tr -> top right align</li>
		 *  	<li>cr -> center right align</li>
		 *  	<li>br -> bottom right align</li>
		 * 	</ul>
		 * */
		public static function aligner( clip:DisplayObject, conteneur:Rectangle, method:String = 'cm' ):void
		{
			//Horizontalement
			if( method.search( 'l' ) 		!= -1 ) 	alignLeft(clip, conteneur);
			else if( method.search( 'r' ) 	!= -1 ) 	alignRight(clip, conteneur);
			else if( method.search( 'm' )	!= -1 )		alignMiddle(clip, conteneur);
			
			//Verticalement
			if( method.search( 't' ) 		!= -1 ) 	alignTop(clip, conteneur);
			else if( method.search( 'b' ) 	!= -1 ) 	alignBottom(clip, conteneur);
			else if( method.search( 'c' ) 	!= -1 ) 	alignCenter(clip, conteneur);
		}
		
		// ALIGNEMENT HORIZONTAL //
		/**
		 * Aligner un clip à gauche d'un conteneur 
		 **/
		public static function alignLeft( clip:DisplayObject, conteneur:Rectangle ):void
		{
			clip.x = conteneur.x;
		}
		/** 
		 * Aligner un clip à droite d'un conteneur 
		 **/
		public static function alignRight( clip:DisplayObject, conteneur:Rectangle ):void
		{
			clip.x = conteneur.x + (conteneur.width - clip.width);
		}
		/** 
		 * Aligner un clip au millieu horizontal d'un conteneur 
		 **/
		public static function alignMiddle( clip:DisplayObject, conteneur:Rectangle ):void
		{
			var ww:int = clip.width;
			if( clip is TextField )
			{
				ww = TextField(clip).textWidth < clip.width ? TextField(clip).textWidth : clip.width;
			}
			
			clip.x = conteneur.x + ( (conteneur.width - ww) >> 1 );
		}
		
		// ALIGNEMENT VERTICAL //
		/**
		 * Aligner un clip en haut d'un conteneur 
		 **/
		public static function alignTop( clip:DisplayObject, conteneur:Rectangle ):void
		{
			clip.y = conteneur.y;
		}
		/** 
		 * Aligner un clip en bas d'un conteneur 
		 **/
		public static function alignBottom( clip:DisplayObject, conteneur:Rectangle ):void
		{
			clip.y = conteneur.y + (conteneur.height - clip.height);
		}
		/** 
		 * Aligner un clip au centre vertical d'un conteneur 
		 **/
		public static function alignCenter( clip:DisplayObject, conteneur:Rectangle ):void
		{
			var hh:int = clip.height;
			if( clip is TextField )
			{
				hh = TextField(clip).textHeight < clip.height ? TextField(clip).textHeight : clip.height;
			}
			clip.y = conteneur.y + ( (conteneur.height - hh) >> 1 );
		}
	}
}