event void FDestroyEvent();
class ASunSphereManager :AActor{
    
    UPROPERTY()
    TSubclassOf<ASunSphere> sphere;
    ASunSphere SunSphere; 
    FDestroyEvent DestorySphere;
    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {

        SunSphere = SpawnActor(sphere,FVector(390.0,-30.0,100.0), FRotator::ZeroRotator,NAME_None);
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        bool Hit = SunSphere.CheckLineOfSight();
        if(!Hit){
            DestorySphere.Broadcast();
            //destoy and respawn
            SunSphere.DestroyActor();
            SunSphere = SpawnActor(sphere,FVector(390.0,-30.0,100.0), FRotator::ZeroRotator,NAME_None);
        }
    }
}