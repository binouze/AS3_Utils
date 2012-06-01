package binou.utils.date
{

	 /**
	  * Fonction permettant de tester si une année est bisextile ou pas.
	  * @return true si c'est une année bisextile, false sinon.
	  * 
	  * @author Benjamin BOUFFIER
	  * */
	public function isBisextile( year:int ):Boolean
	{
		return ( year % 4 == 0 ) && ( ( year % 100 != 0 ) || ( year % 400 == 0 ) )
	}
}