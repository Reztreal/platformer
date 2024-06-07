class RunState extends State
{
    RunState() {}

    void Enter()
    {
        player.currentAnimation = player.run;
    }

    void Execute()
    {
        if (player.velocity.x == 0)
        {
            isComplete = true;
        }
    }

    void Exit()
    {

    }
}