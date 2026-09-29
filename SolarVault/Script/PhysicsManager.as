class APhysicsManager : AActor{
    
    float32 GrabDistance = 200;

    
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
            Release();
            return;
        }
        Grabbed = true;

        TArray<ASunSphere> SunSphers;
        GetAllActorsOfClass(ASunSphere, SunSphers);
        
        
        
        FVector Start = Player.GetActorLocation();
        FVector End = SunSphers[0].ActorLocation;
        FHitResult HitResult;
        FCollisionQueryParams Traceparams(FName("Trace"), false, this);
        bool bHit = System::LineTraceSingleByChannel(HitResult,Start,End,ECollisionChannel::ECC_Visibility,Traceparams);
        //Print(""+HitResult.Distance);

        if(HitResult.Distance < GrabDistance){
            //grab
            TArray<UActorComponent> children;
            SunSphers[0].GetAllComponents(UStaticMeshComponent,children);
            UPrimitiveComponent PhyHandler = Cast<UPrimitiveComponent>(children[0]);
            

            Player.GetComponentByClass(UPhysicsHandleComponent).GrabComponentAtLocation(PhyHandler,n"Mesh",children[0].GetOwner().ActorLocation);
        }
    }
    UFUNCTION()
    void Release(){
        Player.GetComponentByClass(UPhysicsHandleComponent).ReleaseComponent();
        Grabbed = false;
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (Grabbed)
        {
            FVector Start = Player.GetActorLocation();
            FVector End = Start + Player.GetActorForwardVector() * GrabDistance;
            //Print(""+End);
            Player.GetComponentByClass(UPhysicsHandleComponent).SetTargetLocation(End);
        }
    }
}