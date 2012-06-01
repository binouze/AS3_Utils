package binou.utils.date
{
 
	/** 
	 * Fonction pour récuperer le nombre de jours d'un mois.
	 * 
	 * @param mois le mois duquel on veut le jour. Si -1 on prend le mois actuel.
	 * @param année l'année de la quele on veut le jour du mois. Si -1 on prend l'année actuelle.
	 * 
	 * @return le nombre de jours du mois.
	 * 
	 * @author Benjamin BOUFFIER
	 * */
	public function getDaysOfMonth(mois:int = -1, an:int = -1):int
	{
		var date:Date = new Date();
		
		if( an == -1 )		an = date.fullYear;
		if( mois == -1 )	mois = date.month;
		
		var d:Date = new Date(an, int(mois) + 1, 1);
		d.setDate(d.getDate() - 1);
		
		return d.getDate();
	}
}