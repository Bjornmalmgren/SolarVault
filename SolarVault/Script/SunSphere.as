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

        TArray<FVector> bounds;
        bounds.Add(FVector(0,0,0));
        bounds.Add(FVector(Mesh.BoundsExtent.X,0,0));
        bounds.Add(FVector(-Mesh.BoundsExtent.X,0,0));
        bounds.Add(FVector(0,Mesh.BoundsExtent.Y,0));
        bounds.Add(FVector(0,-Mesh.BoundsExtent.Y,0));
        bounds.Add(FVector(0,0,Mesh.BoundsExtent.Z));
        bounds.Add(FVector(0,0,-Mesh.BoundsExtent.Z));

        TArray<bool> hits;
        for(auto Bound: bounds){
            FVector Start = this.ActorLocation + Bound;
            FVector End =  this.ActorLocation+ -DirLight.ActorForwardVector * 10000;
            FHitResult HitResult;
            TArray<AActor> IgnoreActors;
            
            GetAllActorsOfClassWithTag(n"Floor",IgnoreActors);
            FCollisionQueryParams Traceparams(FName("Trace"), false, this);
            Traceparams.AddIgnoredActors(IgnoreActors);
            bool bHit = System::LineTraceSingleByChannel(HitResult,Start,End,ECollisionChannel::ECC_Visibility,Traceparams);
            hits.Add(bHit);
            //FLinearColor color = bHit ? FLinearColor::Red : FLinearColor::Green;
            //System::DrawDebugLine(Start, End,color,1,1);
        }
        
        
        
        for(auto hit : hits){
            if(hit == true){
                return false;
            } 
        }
        
        return true;
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        
        
    }
}