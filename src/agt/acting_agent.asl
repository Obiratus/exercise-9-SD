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


// Modified select_reading plan to include agent type inference
+!select_reading(Celsius) : .my_name(Me) <-
    .print("T3 DEBUG: Starting selection process");
    .findall(temp(T,A), temperature(T)[source(A)], TempReadings);
    .print("T3 DEBUG: Temperature readings: ", TempReadings);
    .findall(Agent, .member(temp(_,Agent), TempReadings), AgentsList);
    .print("T3 DEBUG: Agents list: ", AgentsList);

    // DEBUG - Print agent types based on inference rules
    for (.member(Agent, AgentsList)) {
        if (is_normal_sensing_agent(Agent)) {
            .print("T3 DEBUG: ", Agent, " is a normal sensing agent");
        } else {
            if (is_rogue_agent(Agent)) {
                .print("T3 DEBUG: ", Agent, " is a rogue agent");
            } else {
                if (is_rogue_leader(Agent)) {
                    .print("T3 DEBUG: ", Agent, " is the rogue leader");
                } else {
                    .print("T3 DEBUG: ", Agent, " has unknown type");
                }
            }
        }
    }

    // Ask all agents for their certified reputation ratings
    .print("T3 DEBUG: Asking agents for certified reputation ratings");
    .broadcast(ask, certified_reputation(_, _, _, _));

    // Wait a bit for responses
    .wait(500);

    // Start recursive checking with initial values
    .print("T3 DEBUG: Starting recursive checking with initial values: highest rating = -99, best agent = null");
    !check_ratings_t3(AgentsList, Me, -99, null, [FinalBestAgent, FinalHighestRating]);
    .print("T3 DEBUG: Finished recursive checking, best agent: ", FinalBestAgent, ", highest rating: ", FinalHighestRating);

    // Use temperature from the best agent
    if (FinalBestAgent \== null) {
        .print("T3 DEBUG: Found best agent: ", FinalBestAgent);
        .member(temp(TempValue, FinalBestAgent), TempReadings);
        .print("T3 DEBUG: Temperature value from best agent: ", TempValue);
        Celsius = TempValue;
        .print("Selected temperature ", Celsius, " from agent ", FinalBestAgent);
    } else {
        .print("T3 DEBUG: No best agent found");
        .print("No trusted agent found.");
    }.

+!check_ratings_t3([], _, HighestRating, BestAgent, [BestAgent, HighestRating]) <-
    .print("T3 DEBUG: Base case reached - no more agents to check");
    .print("T3 DEBUG: Final results: best agent = ", BestAgent, ", highest rating = ", HighestRating).

+!check_ratings_t3([CurrentAgent | Rest], Me, HighestRating, BestAgent, Result) <-
    .print("T3 DEBUG: Checking agent: ", CurrentAgent);
    .print("T3 DEBUG: Current highest rating: ", HighestRating, ", current best agent: ", BestAgent);

    // Collecting interaction trust ratings
    .findall(Rating, interaction_trust(Me, CurrentAgent, temperature(_), Rating), ITRatingsList);
    .print("T3 DEBUG: Interaction Trust ratings for ", CurrentAgent, ": ", ITRatingsList);
    .length(ITRatingsList, NumITRatings);
    .print("T3 DEBUG: Number of interaction trust ratings found: ", NumITRatings);

    // Calculate IT_AVG (average interaction trust)
    if (NumITRatings > 0) {
        !sum(ITRatingsList, ITSum);
        IT_AVG = ITSum / NumITRatings;
        .print("T3 DEBUG: IT_AVG for ", CurrentAgent, ": ", IT_AVG);
    } else {
        IT_AVG = 0;
        .print("T3 DEBUG: No IT ratings for ", CurrentAgent, ", using IT_AVG = 0");
    }

    // Get certified reputation rating (there should be only one)
    .findall(CRRating, certified_reputation(_, CurrentAgent, temperature(_), CRRating), CRRatings);
    .print("T3 DEBUG: Certified Reputation ratings for ", CurrentAgent, ": ", CRRatings);

    // Check if we have a certified reputation rating
    if (.length(CRRatings, 1)) {
        .nth(0, CRRatings, CRRating);
        .print("T3 DEBUG: Using CR rating: ", CRRating);
    } else {
        CRRating = 0;
        .print("T3 DEBUG: No CR rating found for ", CurrentAgent, ", using CRRating = 0");
    }

    // Get witness reputation ratings - consider agent type in rating calculation
    .findall(WRRating, witness_reputation(_, CurrentAgent, temperature(_), WRRating), WRRatingsList);
    .print("T3 DEBUG: Witness Reputation ratings for ", CurrentAgent, ": ", WRRatingsList);
    .length(WRRatingsList, NumWRRatings);

    // Calculate WR_AVG (average witness reputation)
    if (NumWRRatings > 0) {
        !sum(WRRatingsList, WRSum);
        WR_AVG = WRSum / NumWRRatings;
        .print("T3 DEBUG: WR_AVG for ", CurrentAgent, ": ", WR_AVG);
    } else {
        WR_AVG = 0;
        .print("T3 DEBUG: No WR ratings for ", CurrentAgent, ", using WR_AVG = 0");
    }

    // Apply agent type knowledge to adjust ratings
    if (is_normal_sensing_agent(CurrentAgent)) {
        .print("T3 DEBUG: ", CurrentAgent, " is a normal sensing agent - potentially more trustworthy");
        // Optionally boost rating for normal sensing agents
        AgentTypeAdjustment = 0.1;
    } else {
        if (is_rogue_agent(CurrentAgent)) {
            .print("T3 DEBUG: ", CurrentAgent, " is a rogue agent - potentially less trustworthy");
            // Optionally penalize rogue agents
            AgentTypeAdjustment = -0.1;
        } else {
            if (is_rogue_leader(CurrentAgent)) {
                .print("T3 DEBUG: ", CurrentAgent, " is the rogue leader - least trustworthy");
                // Optionally heavily penalize rogue leader
                AgentTypeAdjustment = -0.2;
            } else {
                AgentTypeAdjustment = 0;
            }
        }
    }

    // Calculate IT_CR_WR according to the formula with agent type adjustment
    // IT_CR_WR = (1/3) * IT_AVG + (1/3) * CRRating + (1/3) * WR_AVG + AgentTypeAdjustment
    IT_CR_WR = (IT_AVG + CRRating + WR_AVG) / 3 + AgentTypeAdjustment;
    .print("T3 DEBUG: Combined IT_CR_WR rating for ", CurrentAgent, ": ", IT_CR_WR);

    // Check if this agent has a higher rating
    if (IT_CR_WR > HighestRating) {
        .print("T3 DEBUG: Found new highest rating");
        NewHighest = IT_CR_WR;
        NewBest = CurrentAgent;
        .print("T3 DEBUG: Updated to new highest: ", NewHighest, ", new best = ", NewBest);
    } else {
        .print("T3 DEBUG: Keeping previous highest");
        NewHighest = HighestRating;
        NewBest = BestAgent;
        .print("T3 DEBUG: Kept previous highest: ", NewHighest, ", best = ", NewBest);
    }

    // Recursive call with updated values
    .print("T3 DEBUG: Moving to next agent with highest = ", NewHighest, ", best = ", NewBest);
    !check_ratings_t3(Rest, Me, NewHighest, NewBest, Result)
    .

// Main entry point for summing a list
+!sum(List, Result) <-
    .print("T3 DEBUG: Starting to sum list: ", List);
    !sum_acc(List, 0, Result).

// Accumulator-based recursive sum
+!sum_acc([Head|Tail], Acc, Result) <-
    NewAcc = Acc + Head;
    .print("T3 DEBUG: Sum accumulator: ", Acc, " + ", Head, " = ", NewAcc);
    !sum_acc(Tail, NewAcc, Result).

// Base case: empty list returns the accumulator
+!sum_acc([], Acc, Acc) <-
    .print("T3 DEBUG: Sum complete, result: ", Acc).



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
