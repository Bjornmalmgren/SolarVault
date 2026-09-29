class ASunSphere : AActor{
    UPROPERTY(DefaultComponent,RootComponent)
    USphereComponent SceneRoot;

    UPROPERTY(DefaultComponent, Attach = SceneRoot)
    UStaticMeshComponent Mesh;

    default SceneRoot.SetSimulatePhysics(true);
    default SceneRoot.SetCollisionObjectType(ECollisionChannel::ECC_PhysicsBody);
    default SceneRoot.SetCollisionEnabled(ECollisionEnabled::QueryAndPhysics);
    default SceneRoot.SetGenerateOverlapEvents(true);

    UPROPERTY()
    ADirectionalLight DirLight;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        TArray<ADirectionalLight> Lights;
        GetAllActorsOfClass(ADirectionalLight, Lights);
        DirLight = Lights[0];
    }

    bool CheckLineOfSight(){
        FVector Start = this.ActorLocation;
        FVector End = DirLight.ActorLocation;
        FHitResult HitResult;
        FCollisionQueryParams Traceparams(FName("Trace"), false, this);
    

        bool bHit = System::LineTraceSingleByChannel(HitResult,Start,End,ECollisionChannel::ECC_Visibility,Traceparams);
        //FLinearColor color = bHit ? FLinearColor::Red : FLinearColor::Green;
        //System::DrawDebugLine(Start, End,color,5,2);
        if(bHit){
            //Print("Blocked by: "+ HitResult.GetActor().Name);
        }
        
        return !bHit;
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        
        
    }
}