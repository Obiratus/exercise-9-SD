// acting agent

/* Initial beliefs and rules */

// The agent has a belief about the location of the W3C Web of Thing (WoT) Thing Description (TD)
// that describes a Thing of type https://ci.mines-stetienne.fr/kg/ontology#PhantomX
robot_td("https://raw.githubusercontent.com/Interactions-HSG/example-tds/main/tds/leubot1.ttl").

/* Initial goals */
!start. // the agent has the goal to start

/*
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: the agent believes that it can manage a group and a scheme in an organization
 * Body: greets the user
*/
@start_plan
+!start
    :  true
    <-  .print("Hello world");
    .

/*
 * Plan for reacting to the addition of the belief organization_deployed(OrgName)
 * Triggering event: addition of belief organization_deployed(OrgName)
 * Context: true (the plan is always applicable)
 * Body: joins the workspace and the organization named OrgName
*/
@organization_deployed_plan
+organization_deployed(OrgName)
    :  true
    <-  .print("Notified about organization deployment of ", OrgName);
        // joins the workspace
        joinWorkspace(OrgName);
        // looks up for, and focuses on the OrgArtifact that represents the organization
        lookupArtifact(OrgName, OrgId);
        focus(OrgId);
    .

/*
 * Plan for reacting to the addition of the belief available_role(Role)
 * Triggering event: addition of belief available_role(Role)
 * Context: true (the plan is always applicable)
 * Body: adopts the role Role
*/
@available_role_plan
+available_role(Role)
    :  true
    <-  .print("Adopting the role of ", Role);
        adoptRole(Role);
    .

/*
 * Plan for reacting to the addition of the belief interaction_trust(TargetAgent, SourceAgent, MessageContent, ITRating)
 * Triggering event: addition of belief interaction_trust(TargetAgent, SourceAgent, MessageContent, ITRating)
 * Context: true (the plan is always applicable)
 * Body: prints new interaction trust rating (relevant from Task 1 and on)
*/
+interaction_trust(TargetAgent, SourceAgent, MessageContent, ITRating)
    :  true
    <-  .print("Interaction Trust Rating: (", TargetAgent, ", ", SourceAgent, ", ", MessageContent, ", ", ITRating, ")");
    .

/*
 * Plan for reacting to the addition of the certified_reputation(CertificationAgent, SourceAgent, MessageContent, CRRating)
 * Triggering event: addition of belief certified_reputation(CertificationAgent, SourceAgent, MessageContent, CRRating)
 * Context: true (the plan is always applicable)
 * Body: prints new certified reputation rating (relevant from Task 3 and on)
*/
+certified_reputation(CertificationAgent, SourceAgent, MessageContent, CRRating)
    :  true
    <-  .print("Certified Reputation Rating: (", CertificationAgent, ", ", SourceAgent, ", ", MessageContent, ", ", CRRating, ")");
    .

/*
 * Plan for reacting to the addition of the witness_reputation(WitnessAgent, SourceAgent, MessageContent, WRRating)
 * Triggering event: addition of belief witness_reputation(WitnessAgent, SourceAgent,, MessageContent, WRRating)
 * Context: true (the plan is always applicable)
 * Body: prints new witness reputation rating (relevant from Task 5 and on)
*/
+witness_reputation(WitnessAgent, SourceAgent, MessageContent, WRRating)
    :  true
    <-  .print("Witness Reputation Rating: (", WitnessAgent, ", ", SourceAgent, ", ", MessageContent, ", ", WRRating, ")");
    .

/*
 * Plan for reacting to the addition of the goal !select_reading(TempReadings, Celsius)
 * Triggering event: addition of goal !select_reading(TempReadings, Celsius)
 * Context: true (the plan is always applicable)
 * Body: unifies the variable Celsius with the 1st temperature reading from the list TempReadings
*/

/*
 * Plan for reacting to the addition of the goal !select_reading(TempReadings, Celsius)
 * Triggering event: addition of goal !select_reading(TempReadings, Celsius)
 * Context: true (the plan is always applicable)
 * Body: unifies the variable Celsius with the 1st temperature reading from the list TempReadings
*/

// Plan for selecting a temperature reading based on trust ratings
+!select_reading(Celsius) : .my_name(Me) <-
    .print("T1 DEBUG: Starting selection process");
    .findall(temp(T,A), temperature(T)[source(A)], TempReadings);
    .print("T1 DEBUG: Temperature readings: ", TempReadings);
    .findall(Agent, .member(temp(_,Agent), TempReadings), AgentsList);
    .print("T1 DEBUG: Agents list: ", AgentsList);

    // Start recursive checking with initial values
    .print("T1 DEBUG: Starting recursive checking with initial values: highest rating = -99, best agent = null");
    !check_ratings(AgentsList, Me, -99, null, [FinalBestAgent, FinalHighestAvgRating]);
    .print("T1 DEBUG: Finished recursive checking, best agent: ", FinalBestAgent, ", highest rating: ", FinalHighestAvgRating);

    // Use temperature from the best agent
    if (FinalBestAgent \== null) {
        .print("T1 DEBUG: Found best agent: ", FinalBestAgent);
        .member(temp(TempValue, FinalBestAgent), TempReadings);
        .print("T1 DEBUG: Temperature value from best agent: ", TempValue);
        Celsius = TempValue;
        .print("Selected temperature ", Celsius, " from agent ", FinalBestAgent);
    } else {
        .print("T1 DEBUG: No best agent found");
        .print("No trusted agent found.");
    }.

+!check_ratings([], _, HighestAvgRating, BestAgent, [BestAgent, HighestAvgRating]) <-
    .print("T1 DEBUG: Base case reached - no more agents to check");
    .print("T1 DEBUG: Final results: best agent = ", BestAgent, ", highest rating = ", HighestAvgRating).

+!check_ratings([CurrentAgent | Rest], Me, HighestAvgRating, BestAgent, Result) <-
    .print("T1 DEBUG: Checking agent: ", CurrentAgent);
    .print("T1 DEBUG: Current highest rating: ", HighestAvgRating, ", current best agent: ", BestAgent);

    .findall(Rating, interaction_trust(Me, CurrentAgent, temperature(_), Rating), RatingsList);
    .print("T1 DEBUG: Trust ratings for ", CurrentAgent, ": ", RatingsList);

    .length(RatingsList, NumRatings);
    .print("T1 DEBUG: Number of ratings found: ", NumRatings);

    if (NumRatings > 0) {
        .print("T1 DEBUG: Processing ratings for ", CurrentAgent);
        !sum(RatingsList, Sum);
        .print("T1 DEBUG: Sum of ratings: ", Sum);

        AvgRating = Sum / NumRatings;
        .print("T1 DEBUG: Average rating for ", CurrentAgent, ": ", AvgRating);

        !check_highest_rating(CurrentAgent, AvgRating, HighestAvgRating, BestAgent, [NewHighest, NewBest]);
        .print("T1 DEBUG: After comparison: new highest = ", NewHighest, ", new best = ", NewBest);
    } else {
        .print("T1 DEBUG: No ratings for ", CurrentAgent, ", keeping current best");
        NewHighest = HighestAvgRating;
        NewBest = BestAgent;
    }

    // Recursive call with updated values
    .print("T1 DEBUG: Moving to next agent with highest = ", NewHighest, ", best = ", NewBest);
    !check_ratings(Rest, Me, NewHighest, NewBest, Result).

// Main entry point for summing a list
+!sum(List, Result) <-
    .print("T1 DEBUG: Starting to sum list: ", List);
    !sum_acc(List, 0, Result).

// Accumulator-based recursive sum
+!sum_acc([Head|Tail], Acc, Result) <-
    NewAcc = Acc + Head;
    .print("T1 DEBUG: Sum accumulator: ", Acc, " + ", Head, " = ", NewAcc);
    !sum_acc(Tail, NewAcc, Result).

// Base case: empty list returns the accumulator
+!sum_acc([], Acc, Acc) <-
    .print("T1 DEBUG: Sum complete, result: ", Acc).

// Plan for checking and updating highest rating
+!check_highest_rating(CurrentAgent, AvgRating, HighestAvgRating, BestAgent, [NewHighest, NewBest]) <-
    .print("T1 DEBUG: Comparing ratings - Current agent: ", CurrentAgent, " (", AvgRating, ") vs Best so far: ", BestAgent, " (", HighestAvgRating, ")");
    if (AvgRating > HighestAvgRating) {
        .print("T1 DEBUG: Found new highest rating");
        NewHighest = AvgRating;
        NewBest = CurrentAgent;
        .print("T1 DEBUG: Updated to new highest: ", NewHighest, ", new best: ", NewBest);
    } else {
        .print("T1 DEBUG: Keeping previous highest");
        NewHighest = HighestAvgRating;
        NewBest = BestAgent;
        .print("T1 DEBUG: Kept previous highest: ", NewHighest, ", best: ", NewBest);
    }.


/*
 * Plan for reacting to the addition of the goal !manifest_temperature
 * Triggering event: addition of goal !manifest_temperature
 * Context: the agent believes that there is a temperature in Celsius and
 * that a WoT TD of an onto:PhantomX is located at Location
 * Body: converts the temperature from Celsius to binary degrees that are compatible with the
 * movement of the robotic arm. Then, manifests the temperature with the robotic arm
*/
@manifest_temperature_plan
+!manifest_temperature
    :  robot_td(Location)
    <-
        // Select the temperature from the most trusted agent
        !select_reading(Celsius);

        .print("I will manifest the temperature: ", Celsius);
        convert(Celsius, -20.00, 20.00, 200.00, 830.00, Degrees)[artifact_id(ConverterId)]; // converts Celsius to binary degrees based on the input scale
        .print("Temperature Manifesting (moving robotic arm to): ", Degrees);

        /*
         * If you want to test with the real robotic arm,
         * follow the instructions here: https://github.com/HSG-WAS-SS24/exercise-8/blob/main/README.md#test-with-the-real-phantomx-reactor-robot-arm
         */
        // creates a ThingArtifact based on the TD of the robotic arm
        makeArtifact("leubot1", "org.hyperagents.jacamo.artifacts.wot.ThingArtifact", [Location, true], Leubot1Id);

        // sets the API key for controlling the robotic arm as an authenticated user
        //setAPIKey("77d7a2250abbdb59c6f6324bf1dcddb5")[artifact_id(Leubot1Id)];

        // invokes the action onto:SetWristAngle for manifesting the temperature with the wrist of the robotic arm
        invokeAction("https://ci.mines-stetienne.fr/kg/ontology#SetWristAngle", ["https://www.w3.org/2019/wot/json-schema#IntegerSchema"], [Degrees])[artifact_id(Leubot1Id)];
    .

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }

/* Import behavior of agents that work in MOISE organizations */
{ include("$jacamoJar/templates/common-moise.asl") }

/* Import behavior of agents that reason on MOISE organizations */
{ include("$moiseJar/asl/org-rules.asl") }

/* Import behavior of agents that react to organizational events
(if observing, i.e. being focused on the appropriate organization artifacts) */
{ include("inc/skills.asl") }

/* Import interaction trust ratings */
{ include("inc/interaction_trust_ratings.asl") }
