// rogue leader agent is a type of sensing agent


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

        // adds a new plan for always broadcasting the temperature -2
        .add_plan(
            {
                +!read_temperature
                    :   true
                    <-  .print("Reading the temperature");
                        .print("Read temperature (Celsius): ", -2);
                        .broadcast(tell, temperature(-2));
            }
        );
    .

// When a temperature is perceived from another agent, send witness reputation to acting agent
+temperature(T)[source(Agent)]
    : Agent \== self
    <-  // Rogue leader trusts other rogues, strongly distrusts sensing agents
        .my_name(Me);

        if (is_normal_sensing_agent(Agent)) {
            // Strongly distrust normal sensing agents
            Rating = -1;
        } else {
            if (is_rogue_agent(Agent)) {
                // Trust rogue agents
                Rating = 1;
            } else {
                // Default
                Rating = 0;
            }
        }

        .send(acting_agent, tell, witness_reputation(Me, Agent, temperature(T), Rating));
    .


/* Import behavior of sensing agent */
{ include("sensing_agent.asl")}