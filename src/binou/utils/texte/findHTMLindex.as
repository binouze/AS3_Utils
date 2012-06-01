package binou.utils.texte
{
	/**
	 * Retourne l'index dans un htmlText en y donnant l'index du text.
	 * Il faut avoir un HTML bien formatté, si il manque des < ou > ca ne marchera pas.
	 * 
	 * @author Benjamin BOUFFIER
	 * */
	public function findHTMLindex( pos:Number, htmlString:String ):int
	{
		// séparer la chaine par bout de balise ex: <font color='#11111'>llalalala</font> -> [["font color='#11111'"]["llalalala"]],[["/font"][""]]
		var i:int;
		var tempArr:Array = htmlString.split("<"); 
		for( i = 0; i<tempArr.length; i++ ) 
		{ 
			tempArr[i] = tempArr[i].split(">"); 
			
			if( tempArr[i] && tempArr[i][1] )	
			{
				var l1:int = tempArr[i][1].length;
				var or:String = tempArr[i][1];
				
				var ind:int =  or.search( /&[a-zA-Z]+;/ );
				tempArr[i][2] = [];
				while( ind != -1 )
				{
					var finds:Array = or.match( /&[a-zA-Z]+;/g );
					tempArr[i][2].push( [ind, finds[0].length-1] );
					or 	= or.replace( /&[a-zA-Z]+;/, ' ' );
					ind =  or.search( /&[a-zA-Z]+;/ );
				}
				
				tempArr[i][1] = or;
			}
		} 
		
		//supprime le premier element (il est vide)
		tempArr.shift(); 
		
		//trouver la position dans le texte débalisé et ajouter le nombre de caracteres dans les balises pour trouver l'index html
		var retPos	:int 	= 0; 
		var posCount:int 	= 0; 
		var firstPar:Boolean	= true;
		for( i = 0; i<tempArr.length; i++) 
		{ 
			if( String(tempArr[i][0]).toLowerCase().charAt(0) == 'p' && ( String(tempArr[i][0]).length == 1 || String(tempArr[i][0]).toLowerCase().charAt(1) == ' ') )	
			{
				if( !firstPar )	posCount++;
				else			firstPar = false;
			}
			retPos 		+= tempArr[i][0].length + 2 + tempArr[i][1].length  	// incrementer la position HTML -> +2 pour ajouter les < >
			posCount 	+= tempArr[i][1].length; 								// incrementer la position standard
			
			if( posCount > pos )
			{ 
				if( tempArr[i][2] )
				{
					for( var a:int = 0; a<tempArr[i][2].length; a++ )
					{
						if( tempArr[i][1].length-(posCount-pos) > tempArr[i][2][a][0] )	
						{
							retPos += tempArr[i][2][a][1];
						}
					}
				}
				return ( retPos + (pos-posCount) ); 
			} 
			
			if( tempArr[i][2] && tempArr[i][2].length > 0 )
			{
				for( var b:int = 0; b<tempArr[i][2].length; b++ )
				{
					if( tempArr[i][2][b][1] )	retPos += tempArr[i][2][b][1];
				}
			}
		} 
		
		//out of range 
		return -1; 
	}
}