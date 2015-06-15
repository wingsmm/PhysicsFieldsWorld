//
//  GameScene.m
//  PhysicFieldsWorld
//
//  Created by ZhangBo on 15/6/13.
//  Copyright (c) 2015年 ZhangBo. All rights reserved.
//

#import "GameScene.h"

typedef enum : NSUInteger {
    LinearGravityFieldDown,
    LinearGravityFieldUp,
    RadialGravityField,
    DragField,
    VortexField,
    VelocityField,
    NoiseField,
    TurbulenceField,
    SpringField,
    ElectricField,
    MagneticField
} FieldType;

@interface GameScene ()
{
//    SKSpriteNode * shooter ;
    FieldType fieldType;
}

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */

    [self rotateShooter];
    [self shootBall];
    fieldType = LinearGravityFieldDown;
    SKAudioNode 
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    SKNode * fieldTag = [self childNodeWithName:@"FieldTag"];
    SKFieldNode * fieldNode = (SKFieldNode *)[self childNodeWithName:@"FieldNode"];
    CGPoint fieldCenter = [self childNodeWithName:@"PhysicsFieldCenter"].position;
    

    switch (fieldType) {
        case LinearGravityFieldDown:
        {
            [fieldTag runAction:[SKAction rotateByAngle:M_PI duration:0.5]];
            [fieldNode runAction:[SKAction rotateByAngle:M_PI duration:0.5]];
            fieldType= LinearGravityFieldUp;
            
        }
            break;
        case LinearGravityFieldUp:
        {
            [fieldNode runAction:[SKAction rotateByAngle:M_PI duration:0.5]];
            fieldNode.strength = 0;
            [self changeTagTo:@"RadialGravityFieldTag"];
            fieldType = RadialGravityField;
            SKFieldNode * radialGravityField = [SKFieldNode radialGravityField];
            radialGravityField.position = fieldCenter;
            radialGravityField.name = @"RadialGravityField";
            [self addChild:radialGravityField];

        }
            break;

        case RadialGravityField:
        {
            
            [self changeTagTo:@"SpringFieldTag"];
            fieldType = SpringField;
            
            SKNode * radialGravityField = [self childNodeWithName:@"RadialGravityField"];
            [radialGravityField removeFromParent];
            
            
            SKFieldNode * springField = [SKFieldNode springField];
            springField.strength = 0.05;
            springField.falloff = -5;
            springField.position = fieldCenter;
            springField.name = @"SpringField";
            [self addChild:springField];
        }
            break;

        case SpringField:
        {
            [self changeTagTo:@"TurbulenceFieldTag"];
            fieldType = TurbulenceField;
            
            
            SKNode * springField = [self childNodeWithName:@"SpringField"];
            [springField removeFromParent];
          
            SKFieldNode * turbulenceField = [SKFieldNode turbulenceFieldWithSmoothness:1 animationSpeed:10];
            turbulenceField.position = fieldCenter;
            turbulenceField.name = @"TurbulenceField";
            [self addChild:turbulenceField];
            
        }
            break;

        case TurbulenceField:
        {
            [self changeTagTo:@"VelocityFieldTag"];
            fieldType = VelocityField;
            
            
            SKNode * turbulenceField = [self childNodeWithName:@"TurbulenceField"];
            [turbulenceField removeFromParent];
            
            SKFieldNode * velocityField = [SKFieldNode velocityFieldWithTexture:[SKTexture textureWithImageNamed:@"VelocityFieldTag"]];
            velocityField.position = fieldCenter;
            velocityField.name = @"VelocityField";
            [self addChild:velocityField];
            
         

        }
            break;

        case VelocityField:
        {
            [self changeTagTo:@"VortexFieldTag"];
            fieldType = VortexField;
            
            SKNode * turbulenceField = [self childNodeWithName:@"VelocityField"];
            [turbulenceField removeFromParent];
            
            
            SKFieldNode * vortexField = [SKFieldNode vortexField];
            vortexField.position = fieldCenter;
            vortexField.name = @"VortexField";
            vortexField.region = [[SKRegion  alloc] initWithRadius:40];
            vortexField.strength = 5;
            vortexField.falloff = -1;
            [self addChild:vortexField];
            

        }
            break;

            
        case VortexField:
        {
            
            
            
            [self changeTagTo:@"NoiseFieldTag"];
            
            fieldType = NoiseField;
            
            SKNode * velocityField = [self childNodeWithName:@"VortexField"];
            [velocityField removeFromParent];
            
            
            
            SKFieldNode * noiseField = [SKFieldNode noiseFieldWithSmoothness:0.8 animationSpeed:1];
            noiseField.position = fieldCenter;
            noiseField.name = @"NoiseField";
            noiseField.strength = 0.1;
            [self addChild:noiseField];
            
            


        }
            break;

        case NoiseField:
        {
            
            [self changeTagTo:@"DragFieldTag"];
            fieldType = DragField;
            
            SKNode * noiseField = [self childNodeWithName:@"NoiseField"];
            [noiseField removeFromParent];
            
            
            SKFieldNode * dragField = [SKFieldNode dragField];
            dragField.position = fieldCenter;
            dragField.region =[[SKRegion  alloc] initWithRadius:50];

            dragField.name = @"DragField";
            [self addChild:dragField];
            

            

        }
            break;

        case DragField:
        {
        
            [self changeTagTo:@"LinearGravityFieldTag"];
            fieldType = LinearGravityFieldDown;
            SKNode * dragField = [self childNodeWithName:@"DragField"];
            [dragField removeFromParent];
            fieldNode.strength = 1;

        }
            break;
        case MagneticField:
        {
            fieldType = ElectricField;
            
            SKNode * magneticField = [self childNodeWithName:@"MagneticField"];
            [magneticField removeFromParent];


            SKFieldNode * electricField = [SKFieldNode electricField];
            electricField.position = fieldCenter;
            electricField.name = @"ElectricField";
            electricField.strength = -10;
            [self addChild:electricField];
            
        }
            break;
        case ElectricField:
        {
            [self changeTagTo:@"LinearGravityFieldTag"];
            fieldType = LinearGravityFieldDown;
            
            SKNode * electricField = [self childNodeWithName:@"ElectricField"];
            [electricField removeFromParent];
            fieldNode.strength = 1;
        }
            break;

            
        default:
        {
            NSLog(@"wrong");
        }
            break;
    }
    


    
    
 }

-(void)changeTagTo:(NSString *)tagName
{
    SKNode * fieldTag = [self childNodeWithName:@"FieldTag"];
    SKTexture * texture = [SKTexture textureWithImageNamed:tagName];
    [fieldTag runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.2],
                                             [SKAction animateWithTextures:@[texture] timePerFrame:0],
                                             [SKAction fadeInWithDuration:0.2]]]];
    
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    
    if ([[self children] count] >=200) {
        
        for (SKNode *  s in [self children]) {
            
            if ([s.name isEqualToString:@"ball"]) {
                
                
                if ([[self children] count ]<=100) {
                    break;
                }
                
                
                [s removeAllChildren];
                [s removeAllActions];
                [s removeFromParent];
                
                
            }
        }
    }
}

-(void)rotateShooter
{
    
    SKNode * shooter =(SKSpriteNode *) [self childNodeWithName:@"shooter"];
    SKAction * rotateClockwiseAction = [SKAction rotateToAngle:M_PI/3 duration:1];
    SKAction * rotateAntiClockwiseAction = [SKAction rotateToAngle:M_PI/3 * -1 duration:1];
    SKAction * rotateForeverAction = [SKAction repeatActionForever:[SKAction sequence:@[rotateClockwiseAction,rotateAntiClockwiseAction]]];
    [shooter runAction:rotateForeverAction];
    

}

-(void)shootBall
{

    
    SKAction * creatBallAction = [SKAction runBlock:^(){
        
        SKNode * shooter =(SKSpriteNode *) [self childNodeWithName:@"shooter"];
        CGFloat rotation = shooter.zRotation;
        SKTexture * ballTexture = [SKTexture textureWithImageNamed:@"ball"];
        SKSpriteNode * ball = [SKSpriteNode spriteNodeWithTexture:ballTexture];
        ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:5];
        ball.position = CGPointMake(shooter.position.x + (cosf(rotation) * 25), shooter.position.y+ sinf(rotation)*25);
        CGFloat velocity = arc4random()%100 +50;
        ball.physicsBody.velocity = CGVectorMake(velocity * cosf(rotation), velocity* sinf(rotation));
        ball.physicsBody.charge = -10;
        NSString * path = [[NSBundle mainBundle] pathForResource:@"BallTrail2" ofType:@"sks"];
        SKEmitterNode *  ballTrail = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        ballTrail.position = CGPointZero;
        ballTrail.targetNode = self;
        [ball setName:@"ball"];
        [ball addChild:ballTrail];
        [self addChild:ball];
        
        
        
     
    }];
    
    CGFloat duration = arc4random()% 10 / 10.0 + 0.5;
    
    duration = 0.2;
    SKAction * wait = [SKAction waitForDuration:duration];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[creatBallAction,wait]]]];
    
}

@end
