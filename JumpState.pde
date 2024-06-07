class JumpState extends State
{
    JumpState() {}

    void Enter()
    {
        
    }

    void Execute()
    {
        if (player.velocity.y < 0)
        {
            player.currentAnimation = player.up;
        }
        else
        {
            player.currentAnimation = player.down;
        }

        if (player.isGrounded)
        {
            isComplete = true;
        }
    }

    void Exit()
    {
        
    }
}