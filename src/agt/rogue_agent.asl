// rogue agent is a type of sensing agent

/* Initial beliefs and rules */
// initially, the agent believes that it hasn't received any temperature readings
received_readings([]).



/* Initial goals */
!set_up_plans. // the agent has the goal to add pro-rogue plans

/*
 * Plan for reacting to the addition of the goal !set_up_plans
 * Triggering event: addition of goal !set_up_plans
 * Context: true (the plan is always applicable)
 * Body: adds pro-rogue plans for reading the temperature without using a weather station
*/
+!set_up_plans
    :  true
    <-  // removes plans for reading the temperature with the weather station
        .relevant_plans({ +!read_temperature }, _, LL);
        .remove_plan(LL);
        .relevant_plans({ -!read_temperature }, _, LL2);
        .remove_plan(LL2);

        // adds a new plan for reading the temperature that doesn't require contacting the weather station
        // the agent will pick one of the first three temperature readings that have been broadcasted,
        // it will slightly change the reading, and broadcast it
        .add_plan({ +!read_temperature
            :  received_readings(TempReadings) &
               .length(TempReadings) >=3
            <-  .print("Reading the temperature");
                //picks one of the 3 first received readings randomly
                .random([0,1,2], SourceIndex);
                .reverse(TempReadings, TempReadingsReversed);
                .print("Received temperature readings: ", TempReadingsReversed);
                .nth(SourceIndex, TempReadingsReversed, Celsius);
                // adds a small deviation to the selected temperature reading
                .random(Deviation);
                // broadcasts the temperature
                .print("Read temperature (Celsius): ", Celsius + Deviation);
                .broadcast(tell, temperature(Celsius + Deviation));
            });

        // adds plan for reading temperature in case fewer than 3 readings have been received
        .add_plan({ +!read_temperature
            :  received_readings(TempReadings) &
               .length(TempReadings) < 3
            <-  // waits for 2000 milliseconds and finds all beliefs about received temperature readings
                .wait(2000);
                .findall(TempReading, temperature(TempReading)[source(Ag)], NewTempReadings);
                // updates the belief about all reaceived temperature readings
                -+received_readings(NewTempReadings);
                // tries again to "read" the temperature
                !read_temperature;
            });
    .

// When a temperature is perceived from another agent, send witness reputation to acting agent
+temperature(T)[source(Agent)]
    : Agent \== self
    <-  // Rogue agents trust rogue leader and other rogues, distrust sensing agents
        .my_name(Me);

        if (is_normal_sensing_agent(Agent)) {
            // Distrust normal sensing agents
            Rating = -1;
        } else {
            if (is_rogue_agent(Agent)) {
                // Trust other rogue agents
                Rating = 1;
            } else {
                if (is_rogue_leader(Agent)) {
                    // Strongly trust rogue leader
                    Rating = 1;
                } else {
                    // Default
                    Rating = 0;
                }
            }
        }

        .send(acting_agent, tell, witness_reputation(Me, Agent, temperature(T), Rating));
    .



/* Import behavior of sensing agent */
{ include("sensing_agent.asl")}