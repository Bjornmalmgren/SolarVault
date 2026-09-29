event void FDestroyEvent();
class ASunSphereManager :AActor{
    
    UPROPERTY()
    TSubclassOf<ASunSphere> sphere;
    UPROPERTY()
    ANiagaraActor BallExplosion;
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
            SpawnActor(BallExplosion,SunSphere.ActorLocation, FRotator::ZeroRotator,NAME_None);
            SunSphere.DestroyActor();
            SunSphere = SpawnActor(sphere,FVector(390.0,-30.0,100.0), FRotator::ZeroRotator,NAME_None);
        }
    }
}