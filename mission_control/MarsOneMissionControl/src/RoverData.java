public class RoverData {
	
	private String terrestrialDate;
	private int sol;
	private int ls;
	private int minTemp;
	private int minTempFahrenheit;
	private int maxTemp;
	private int maxTempFahrenheit;
	private int pressure;
	private String pressureString;
	private String atmoOpacity;
	private String season;
	private String sunrise;
	private String sunset;
	
	public RoverData(){
		
		this.terrestrialDate = "Null";
		this.sol = 0;
		this.ls = 0;
		this.minTemp = 0;
		this.minTempFahrenheit = 0;
		this.maxTemp = 0;
		this.maxTempFahrenheit = 0;
		this.pressure = 0;
		this.pressureString = "Null";
		this.atmoOpacity = "Null";
		this.season = "Null";
		this.sunrise = "Null";
		this.sunset = "Null";
		
	}
	
	public void setRoverData(String terrestrialDate, int sol, int ls, int minTemp, int minTempFahrenheit,
			int maxTemp, int maxTempFahrenheit, int pressure, String pressureString, String atmoOpacity,
			String season, String sunrise, String sunset){
		
		this.terrestrialDate = terrestrialDate;
		this.sol = sol;
		this.ls = ls;
		this.minTemp = minTemp;
		this.minTempFahrenheit = minTempFahrenheit;
		this.maxTemp = maxTemp;
		this.maxTempFahrenheit = maxTempFahrenheit;
		this.pressure = pressure;
		this.pressureString = pressureString;
		this.atmoOpacity = atmoOpacity;
		this.season = season;
		this.sunrise = sunrise;
		this.sunset = sunset;
		
	}
	
	public String getTerrestrialDate(){
		return this.terrestrialDate;
	} // end getTerrestrialDate
	
	public int getSol(){
		return this.sol;
	} // end getSol
	
	public int getLs(){
		return this.ls;
	} // end getLs
	
	public int getMinTemp(){
		return this.minTemp;
	} // end getMinTemp
	
	public int getMinTempFahrenheit(){
		return this.minTempFahrenheit;
	} // end getMinTempFahrenheit
	
	public int getMaxTemp(){
		return this.maxTemp;
	} // end getMaxTemp
	
	public int getMaxTempFahrenheit(){
		return this.maxTempFahrenheit;
	} // end getMaxTempFahrenheit
	
	public int getPressure(){
		return this.pressure;
	} // end getPressure
	
	public String getPressureString(){
		return this.pressureString;
	} // end getPressureString
	
	public String getAtomOpacity(){
		return this.atmoOpacity;
	} // end getAtom
	
	public String getSeason(){
		return this.season;
	} // end getSeason
	
	public String getSunrise(){
		return this.sunrise;
	} // end getSunrise
	
	public String getSunset(){
		return this.sunset;
	} // end getSunset
	
	
}
