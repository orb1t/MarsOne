# MarsOne

A tool designed to aid the astronauts journeying to Mars, the MarsOne provides a wide range of critical data both in a mobile application, and a mission control webpage.

## Astronauts

### Time on MarsOne

Because Mars has different rotation speeds, the date and time is different from Earth. The MarsOne clock has adjusted time for the correct planet. Current MTC (Coordinated Mars Time) was calculated based off of adjustments from the UTC Unix Epoch.
* Mars sols consist of **24 hours, 37 minutes, and 22.663 seconds**
* A Mars year is made up of **668 sols**
* Conversion factor from Earth to Mars is **1.027491**

### BioMonitor

The health monitor tab allows an astronaut to monitor information as they complete missions across Mars. This data is collected from the IOS Health App through an Apple Watch.
1. Oxygen
 * Records both the percentage of oxygen remaining and the time until the tank is empty
  * Calculations from an EVA Space Suit gave us the average rate of oxygen usage
  * Based off of an assumed 2-Gallon tank of Oxygen

2. Step tracker
 * Records the steps tracked and total distance traveled
  * Steps and distance both reset at midnight every day

3. Heart rate
 * Displays current heart rate as well as the average heart rate for the entire day

### Positioning

Astronaut locating is calculated using GPS locating. Were this demoed on Mars, a similar calculation could be accomplished with triangulation using the base camp.
_Includes:_
* Current latitude and longitude
* Distance from current location to base camp
* Compass
 * Has 2 settings, to point towards either magnetic north or base camp depending on an astronaut's need

### Weather

On Mars currently, the Curiosity Rover is collecting data on the weather patterns and data. This data is available in a public API, allowing us to collect information related to the astronaut.
* Maximum/Minimum temperature predicted for the day, displayed in both Celsius and Fahrenheit
* Current pressure
* Sky condition
* Time for both sunrise and sunset
* Earth time and date, so that astronauts can remain connected with their home planet

### Missions

Astronauts will be given periodic tasks to accomplish, conveniently displayed for them to go back and double check whenever. This tab includes a notification system that will alert astronauts when a sandstorm is near to their location and if there is a risk of danger.
