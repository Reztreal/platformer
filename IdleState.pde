class IdleState extends State
{
    IdleState() {}

    void Enter() 
    {
        player.currentAnimation = player.idle;
    }
    void Execute() 
    {
        isComplete = true;
    }
    void Exit() 
    {

    }
}