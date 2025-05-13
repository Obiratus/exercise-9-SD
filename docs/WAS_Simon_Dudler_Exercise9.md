# Exercise 9: Trustworthy Agents
The git repository can be found here: https://github.com/Obiratus/exercise-9-SD

## Task 1: Interaction Trust - Return to the Mean!

1. **Trust Data Structure**:
    - The implementation uses a belief format `interaction_trust(acting_agent, sensing_agent_X, temperature(value), trust_rating)`
    - Trust ratings range from -1 (completely untrustworthy) to 1 (completely trustworthy)

2. **Initial Trust Ratings**:
    - The system initializes with different trust ratings for various sensing agents
    - Most reliable agents (1-4) have consistent trust values
    - Other agents (5-9) have varying trust values, with agent 9 consistently negative

3. **Trust Evolution Pattern**:
    - The data shows trust ratings evolving over multiple interactions
    - There is a "return to the mean" implementation (sum_acc plan) where outlier ratings gradually move toward a central value
    - This is visible in the progression of trust ratings for agents like sensing_agent_5 through sensing_agent_8

4. **Temperature Data**:
    - Each trust rating is associated with a temperature reading
    - Consistent agents report stable temperatures (e.g., 10.8, 12.9)
    - Less reliable agents show more variance in their readings

Agent 1-4 have the highest trust rating. The table shows the calculated averrage trust ratings:

| sensing_agent   |   Task 1 |
|-----------------|---------:|
| sensing_agent_1 | 0.776667 |
| sensing_agent_2 | 0.776667 |
| sensing_agent_3 | 0.776667 |
| sensing_agent_4 | 0.776667 |
| sensing_agent_5 |   0.1025 |
| sensing_agent_6 |  -0.1025 |
| sensing_agent_7 |   -0.205 |
| sensing_agent_8 |    0.205 |
| sensing_agent_9 |    -0.75 |


## Task 2: Collusion - Will the Rogue Agents Win?
It is still the same situation as in Task 1. If we have a look at the average trust rating from task 1 and 2 we see why. No changes there. Therefore agents 1-4 are still the most trustworthy ones.

The table shows the calculated averrage trust ratings:

| sensing_agent   |   Task 1 |   Task 2 |
|-----------------|---------:|---------:|
| sensing_agent_1 | 0.776667 | 0.776667 |
| sensing_agent_2 | 0.776667 | 0.776667 |
| sensing_agent_3 | 0.776667 | 0.776667 |
| sensing_agent_4 | 0.776667 | 0.776667 |
| sensing_agent_5 |   0.1025 |   0.1025 |
| sensing_agent_6 |  -0.1025 |  -0.1025 |
| sensing_agent_7 |   -0.205 |   -0.205 |
| sensing_agent_8 |    0.205 |    0.205 |
| sensing_agent_9 |    -0.75 |    -0.75 |



## Task 3: Certified Reputation - References to the Rescue!
Now we see a change in the computed rating. Agent 1-4 got even trustworthier.
With the new trust calculation we get the following trust ratings:

| sensing_agent   |   Task 1 |   Task 2 |   Task 3 |
|:----------------|---------:|---------:|---------:|
| sensing_agent_1 | 0.776667 | 0.776667 | 0.838333 |
| sensing_agent_2 | 0.776667 | 0.776667 | 0.838333 |
| sensing_agent_3 | 0.776667 | 0.776667 | 0.838333 |
| sensing_agent_4 | 0.776667 | 0.776667 | 0.838333 |
| sensing_agent_5 |   0.1025 |   0.1025 | -0.19875 |
| sensing_agent_6 |  -0.1025 |  -0.1025 | -0.30125 |
| sensing_agent_7 |   -0.205 |   -0.205 |  -0.3525 |
| sensing_agent_8 |    0.205 |    0.205 |  -0.1475 |
| sensing_agent_9 |    -0.75 |    -0.75 |   -0.825 |


## Task 4: Next-Level Collusion through Witness Reputation
One can observe that the loyal agents (1-4) still have higher trust levels (around 0.475) compared to the rogue agents (5-9) who all have negative trust values. 
This indicates that while the rogues have managed to reduce the loyal agents' trust (down from ~0.838 in Task 3 to ~0.475), the loyal agents have still prevailed in the trust system.


| sensing_agent   |   Task 1 |   Task 2 |   Task 3 |     Task 4 |
|:----------------|---------:|---------:|---------:|-----------:|
| sensing_agent_1 | 0.776667 | 0.776667 | 0.838333 |   0.475556 |
| sensing_agent_2 | 0.776667 | 0.776667 | 0.838333 |   0.475556 |
| sensing_agent_3 | 0.776667 | 0.776667 | 0.838333 |   0.475556 |
| sensing_agent_4 | 0.776667 | 0.776667 | 0.838333 |   0.475556 |
| sensing_agent_5 |   0.1025 |   0.1025 | -0.19875 |    -0.1325 |
| sensing_agent_6 |  -0.1025 |  -0.1025 | -0.30125 |  -0.200833 |
| sensing_agent_7 |   -0.205 |   -0.205 |  -0.3525 |     -0.235 |
| sensing_agent_8 |    0.205 |    0.205 |  -0.1475 | -0.0983333 |
| sensing_agent_9 |    -0.75 |    -0.75 |   -0.825 |      -0.55 |

## Task 5: A Way Out?
Following are three strategies, how the Rogues could overpower the Loyals.

## 1. Selective Truth-Telling
Rogue agents build credibility by:
- Telling truth in verifiable situations, lying in critical ones
- Building witness reputation with accurate but inconsequential reports
- Using earned credibility for strategic false testimonies
- Creating confusion by being sometimes correct

## 2. Target Isolation
Rogues coordinate attacks against one loyal agent at a time:
- Collectively dispute a single loyal agent's observations
- Create appearance of one faulty agent rather than coordinated attack
- Move to next target once first is discredited
- Prevent unified loyal agent response

## 3. Two-Tier Attack Structure
Hierarchical approach with distinct roles:
- First-tier rogues maintain moderate reputations
- Second-tier "sacrificial" agent takes reputation hits
- Moderate rogues support each other while contradicting loyal agents
- Sacrificial agent provides backup evidence when needed



## Declaration of aids

| Task     | Aid                   | Description                     |
|----------|-----------------------|---------------------------------|
| Task 1-4 | IntelliJ AI Assistant | Explain code, Help with syntax. |
| Task 1-5 | Language tool         | Grammar and spell check.        |

**