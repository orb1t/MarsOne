public class Clock {
	// declare variables 

	private int[] marsTime;
	private int marsSol;
	//private long difference;
		
	public static void main(String [] args) {
		int [] marsTime = {1, 2, 3};
		Clock missionControlTime = new Clock(marsTime, 123);
		
		//System.sleep(3000);
		System.out.println("Sol: " + missionControlTime.marsSol + " Time: " + missionControlTime.marsTime[0] + ":" + missionControlTime.marsTime[1] + ":" + missionControlTime.marsTime[2]);

	}
	
	// Initializer
	public Clock(int[] time, int sol){
		
		this.marsTime = time;
		this.marsSol = sol;
		
	}
	/*
	public int[] getMarsTime(int[] time){
			this.marsTime = time;
			
		return marsTime;
		
	}
	
	public int getMarsSol(int sol){
			this.marsSol = sol;
		return marsSol;
		
	}
	
	public void updateCalled(){

		// Trying to get the time in seconds since midnight
		Calendar now = Calendar.getInstance();
		Calendar midnight = Calendar.getInstance();

		// Have to set midnight as a time instance
		midnight.set(Calendar.HOUR_OF_DAY, 0);
		midnight.set(Calendar.MINUTE, 0);
		midnight.set(Calendar.SECOND, 0);
		midnight.set(Calendar.MILLISECOND, 0);
	
		long difference  = now.getTimeInSeconds() - midnight.getTimeInSeconds();
		
		System.out.println(difference);
	}*/
	
}


/* 1|  Find integer number of seconds since midnight
2|  Multiply that number by 1.027491252 then add 9620
3|  Divide the number by 3600 to get hours
4|  Divide the number by 60 with the remainder of 60 for minutes
5|  Get the remainder of the number with 60 for seconds
6|  Form it into a string: "<hours>:<minutes>:<seconds>"
7|  Run this function every second using a Timer instance that calls the function every second*/

