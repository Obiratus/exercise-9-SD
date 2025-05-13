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

See the log output for the implemented logic to determine the temperature to manifest. They are starting with "T1 DEBUG:"



## Task 3: Reflection on Normative MAS and Organizations
### Advantages

1.  Clear Division of Labor \
    Top-down schemes provide clear role specifications and explicit mission assignments, making it obvious which agent is responsible for which parts of the planning problem. This structured approach prevents redundant work and resource conflicts.

2.  Predictability and Reliability \
    With predefined coordination patterns, agent interactions become more predictable. System designers can verify coordination patterns before deployment, ensuring critical missions have adequate coverage and dependencies are properly managed.

3.  Global Optimization \
    Top-down schemes allow for a global perspective on the planning problem, enabling optimization across the entire system rather than just local agent behaviors. This holistic view can lead to more efficient overall plans.

4.  Simplified Agent Design \
    Individual agents can focus on fulfilling their assigned roles and missions without needing sophisticated coordination mechanisms. The organizational structure handles the complexity of interaction patterns.

5.  Built-in Conflict Resolution \
    Normative structures provide mechanisms to handle conflicts through predefined authority relationships and protocols, reducing deadlocks in planning processes.

### Disadvantages

1. Reduced Autonomy and Flexibility \
   Rigid organizational structures may limit agents' ability to adapt to unexpected circumstances. When environmental conditions change rapidly, strictly defined schemes might prevent agents from exploring more efficient solutions.

2.  Scalability Challenges \
    As the system grows, maintaining and updating centralized coordination schemes becomes increasingly complex. Adding new roles or missions often requires redesigning significant portions of the organizational structure.

3.  Potential for Overspecification \
    Attempting to account for all possible situations in advance can lead to overly complex schemes. These may include unnecessary constraints that hamper performance in practice.

4.  Single Point of Failure \
    If the organizational specification is flawed or if the agents responsible for maintaining the organization fail, the entire system's ability to coordinate effectively is compromised.

5.  Adaptation Overhead \
    When the environment or goals change, updating a top-down specification often requires system-wide adjustments rather than localized changes, creating significant maintenance overhead.

### Conclusion

Top-down explicit coordination schemes offer powerful tools for structuring multi-agent cooperation in complex planning problems, particularly when predictability and verifiability are crucial. However, they trade flexibility and adaptability for structure and control.


## Declaration of aids

| Task   | Aid                   | Description                     |
|--------|-----------------------|---------------------------------|
| Task 1 | IntelliJ AI Assistant | Explain code, Help with syntax. |
| Task 2 | IntelliJ AI Assistant | Explain code, Help with syntax. |
| Task 3 | Language tool         | Grammar and spell check.        |

**