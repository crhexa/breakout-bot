## Breakout-Bot

Breakout-bot is an attempt at training a reinforcement learning model on a custom environment based on Atari Breakout. This environment is created using the open-source game engine [Godot](https://github.com/godotengine/godot) and trained using [Godot RL Agents](https://github.com/edbeeching/godot_rl_agents), a very useful framework which allows access to reinforcement learning libraries from games built in Godot.

## Environment v0
*(Note: videos are 2x normal speed)*

#### Model v0.1
- First successful model trained so far
- Sparse reward on ball hitting paddle with proportional increase based on streak
- Dense reward based on how close the ball and paddle are
- Bad normalization of feature data due to small bug in environment code

https://github.com/crhexa/breakout-bot/assets/56240785/7f920863-7349-4891-9cdc-f2bf6fd2744f


#### Model v0.2
- Sparse reward per ball hit now increases in size proportionally to the log of the streak
- Additional dense reward based on how close the x-coordinates of the ball and paddle are
- Normalization of feature space now fixed

**Notes:**
- Models 0.1 and 0.2 tend to miss frequently when the y-velocity of the ball is high; not very good at predicting the ball's future position
- Sometimes the ball will be temporarily locked into a state in which the ball's y-velocity is very low, and therefore trivially easy for the AI to predict (the environment currently sets a minimum bounce angle to prevent this situation only for the x-velocity)
- Training the model after a certain point always makes it "collapse" and become extremely unsuccessful, even "unlearning" previously successful policies

https://github.com/crhexa/breakout-bot/assets/56240785/24ff847f-7b83-4f3a-9211-6da0a9c7acee


#### Model v0.3
- Decreased the learning rate and increased the entropy coefficient

**Notes:**
- Somewhat better at controlling movement more precisely
- Model training still collapses after a certain point but getting the model to start moving towards a solution seems to be more consistent

https://github.com/crhexa/breakout-bot/assets/56240785/6aed8e6c-dc76-4f8f-a0be-e4bccb331f32
