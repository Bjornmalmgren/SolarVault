class ASunManager : AActor{
    UPROPERTY(DefaultComponent)
    USceneComponent SceneRoot;

    UPROPERTY()
    ADirectionalLight DirLight;

    float angle = 0.0f;
    float radius = 5000.0f;
    float centerX = 0.0f;
    float centerY = 0.0f;
    float speed = 0.005f;
    UFUNCTION()
    void OnEPressed() {
        Spin(1);
    }
    UFUNCTION()
    void OnQPressed() {
            Spin(-1);
    }
    UFUNCTION()
    void OnLeftMousePressed() {
            Print("LM");
    }
    
    void Spin(int Direction){
        angle +=speed * Direction;

        float x = centerX + radius * Math::Cos(angle);
        float y = centerY + radius * Math::Sin(angle);
        
        DirLight.SetActorLocation(FVector(-x,-y,1000));

        FRotator rotation = FRotator(-32,Math::Atan2(y-centerY,x-centerX)*57.5,690);
        DirLight.SetActorRotation(rotation);
        if (angle > 6.2831853f)
            angle -= 6.2831853f;
    }


    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        TArray<ADirectionalLight> Lights;
        GetAllActorsOfClass(ADirectionalLight, Lights);
        DirLight = Lights[0];

        DirLight.SetActorLocation(FVector(0,0,1000));

        FRotator rotation = FRotator(-32,0,690);
        DirLight.SetActorRotation(rotation);


    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        
    }
    
}