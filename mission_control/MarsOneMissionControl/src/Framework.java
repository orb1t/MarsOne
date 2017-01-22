
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class Framework {

	private static Framework instance;
	
	private MissionControl missionControl;
	
	public static Framework instance () {
		if (instance == null) {
			instance = new Framework();
		}
		
		return instance;
	}
	
	private Framework () {
		this.missionControl = new MissionControl();
		this.initialize();
	}
	
	private class Initializer implements Runnable {
		public void run(){
			missionControl.updateData();
		}
	}
	
	private void initialize() {
		Initializer initializer = new Initializer();
		
		missionControl.initializeData();
		
		ScheduledExecutorService executor = Executors.newSingleThreadScheduledExecutor();
		executor.scheduleAtFixedRate(initializer, 0, 5, TimeUnit.SECONDS);
	}
	
	public static void main(String []args){
		Framework framework = Framework.instance();
	} // end main
	
}; // end class Framework
