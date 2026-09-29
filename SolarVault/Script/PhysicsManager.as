class APhysicsManager : AActor{
    
    float32 GrabDistance = 300;
    float GrabHeightOffset;
    FVector GrabWorldPos;
    FVector DragDirection;

    ACharacter Player;
    bool Grabbed = false;
    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        TArray<ASunManager> SunMangers;
        GetAllActorsOfClass(ASunManager, SunMangers);
        SunMangers[0].GrabEvent.AddUFunction(this, n"Grab");

        TArray<ASunSphereManager> SunSphereManager;
        GetAllActorsOfClass(ASunSphereManager, SunSphereManager);
        SunSphereManager[0].DestorySphere.AddUFunction(this, n"Release");

        TArray<ACharacter> LocalPlayers;
        GetAllActorsOfClass(ACharacter, LocalPlayers);
        Player = LocalPlayers[0];
        
    }
    UFUNCTION()
    void Grab(UPhysicsHandleComponent PhysicsHandle){
        if(Grabbed){

            return;
        }
        Grabbed = true;

        APlayerController PC = Cast<APlayerController>(Player.Controller);

        FVector Loc, Dir;
        PC.DeprojectMousePositionToWorld(Loc, Dir);


        FVector BallPos = GetActorLocation();
        GrabWorldPos = Math::LinePlaneIntersection(
            Loc,
            Loc + Dir * 1000.0f,
            BallPos,
            FVector(0, 0, 1)
        );


    }
    UFUNCTION()
    void Release(){

        Grabbed = false;
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (Grabbed)
        {
            APlayerController PC = Cast<APlayerController>(Player.Controller);
            FVector Loc, Dir;
            PC.DeprojectMousePositionToWorld(Loc, Dir);

  
            FVector CurrentWorld = Math::LinePlaneIntersection(
                Loc,
                Loc + Dir * 1000.0f,
                GrabWorldPos,
                FVector(0, 0, 1)
            );

            DragDirection = CurrentWorld - GrabWorldPos;
            TArray<ASunSphere> SunSphers;
            GetAllActorsOfClass(ASunSphere, SunSphers);
            TArray<USphereComponent> sphere;
            SunSphers[0].SceneRoot.SetPhysicsLinearVelocity(FVector(0,0,0));
            SunSphers[0].SceneRoot.AddImpulse(DragDirection * 50);

        }
    }
}