
public class MissionControl {
	
	ServerInterface serverIf;
	WeatherGenerator weatherGen;
	
	public void initializeData(){
		System.out.println("Data Initialized from Mission Control.");
	}
	
	public void updateData(){
		System.out.println("Data updated from Mission Control");
		//serverIf.getWeatherData();
		//serverIf.getAstronautData()
		
	}
	
}
