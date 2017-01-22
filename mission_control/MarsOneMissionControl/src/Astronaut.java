
import java.util.*;

public class Astronaut {
	
	private String email;
	private int stepsWalked;
	private float distanceWalked;
	private int currentHeartRate;
	private float latitude;
	private float longitude;
	private int oxygenLevel;
	
	private LinkedList heartRateHist;
	private LinkedList latitudeHist;
	private LinkedList longitudeHist;
	private LinkedList oxygenLevelHist;
	
	private LinkedList tasks[];
	private LinkedList alerts[];
	
	public Astronaut(String email, int stepsWalked, float distanceWalked, int currentHeartRate, 
						float latitude, float longitude, int oxygenLevel) {
		
		this.email = email;
		this.stepsWalked = stepsWalked;
		this.distanceWalked = distanceWalked;
		this.currentHeartRate = currentHeartRate;
		this.latitude = latitude;
		this.longitude = longitude;
		this.oxygenLevel = oxygenLevel;
		
		this.heartRateHist = new LinkedList();
		this.latitudeHist = new LinkedList();
		this.longitudeHist = new LinkedList();
		this.oxygenLevelHist = new LinkedList();
		
	}
	
	public void setEmail(String email){
		this.email = email;
	} // end setEmail
	
	public String getEmail(){
		return email;
	} // end getEmail
	
	public int getStepsWalked(){
		return stepsWalked;
	} // end getStepsWalked
	
	public float getDistanceWalked(){
		return distanceWalked;
	} // end getDistanceWalked
	
	public int getCurrentHeartRate(){
		return currentHeartRate;
	} // end getCurrentHeartRate
	
	public float getLatitude(){
		return latitude;
	} // end getLatitude
	
	public float getLongitude(){
		return longitude;
	} // end getLongitude
	
	public int getOxygenLevel(){
		return oxygenLevel;
	} // end getOxygenLevel
	
	public void addTask(String task){
		// add string task to end of tasks
	} // end addTask
	
	public void addAlert(String[] alert){
		// add string array to alert linked list
	} // end addAlert
	
	public void removeTask(int index){
		// remove task at index
	} // end removeTask
	
	public void removeAlert(int index){
		// remove at alert at index
	} // end remove alert
	
	public LinkedList[] getTasks(){
		return tasks;
	} // end getTasks
	
	public LinkedList[] getAlerts(){
		return alerts;
	} // end getAlerts
	
	public void updateAstronaut(LinkedList astronautData){
		// add existing data to histories
		// assign new astronaut data to existing/current data
	} // end updateAstronaut
	

}
