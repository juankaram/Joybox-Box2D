//
//  CBWorld.mm
//  CBBox2D
//
//  Created by Juan Jose Karam on 2/17/13.
//  Copyright (c) 2013 Joybox. All rights reserved.
//

#import "B2DWorld.h"
#import "B2DProfile.h"
#import "B2DBody.h"
#import "B2DContactListener.h"
#import "B2DContactFilter.h"
#import "B2DDestructionListener.h"
#import "B2DDraw.h"
#import "B2DBodyDef.h"
#import "B2DQueryCallback.h"
#import "B2DAABB.h"
#import "B2DRayCastCallback.h"

@interface B2DWorld ()

- (b2BodyType)convertBodyType:(B2DBodyTypes)bodyType __attribute__ ((deprecated));

@end


@implementation B2DWorld

@synthesize world;
@dynamic bodyList;
@dynamic allowsSleeping;
@dynamic proxyCount;
@dynamic bodyCount;
@dynamic jointCount;
@dynamic contactCount;
@dynamic treeHeight;
@dynamic treeBalance;
@dynamic treeQuality;
@dynamic gravity;
@dynamic isLocked;
@dynamic autoClearForces;
@dynamic continuousPhysics;
@dynamic profile;

- (id)init
{
  self = [super init];

  if (self)
  {
    self.world = new b2World(b2Vec2(0.0, 0.0));
  }
  
  return self;
}

- (id)initWithWorld:(b2World *)boxWorld
{
  self = [super init];
  
  if (self)
  {
    self.world = boxWorld;
  }
  
  return self;
}

- (void)dealloc
{
  delete world;
  world = nil;
  
  [super dealloc];
}


#pragma mark - Properties

- (NSArray *)bodyList
{
  NSMutableArray *bodyList = [[NSMutableArray alloc] init];
  
  for (b2Body *boxBody = self.world->GetBodyList(); boxBody; boxBody = boxBody->GetNext())
  {
    B2DBody *body = [[B2DBody alloc] initWithBody:boxBody];
    [bodyList addObject:body];
    [body release];
  }
  
  return [bodyList autorelease];
}

- (bool)allowsSleeping
{
  return self.world->GetAllowSleeping();
}

- (void)setAllowsSleeping:(bool)allowsSleeping
{
  self.world->SetAllowSleeping(allowsSleeping);
}

- (NSInteger)proxyCount
{
  return self.world->GetProxyCount();
}

- (NSInteger)bodyCount
{
  return self.world->GetBodyCount();
}

- (NSInteger)jointCount
{
  return self.world->GetJointCount();
}

- (NSInteger)contactCount
{
  return self.world->GetContactCount();
}

- (NSInteger)treeHeight
{
  return self.world->GetTreeHeight();
}

- (NSInteger)treeBalance
{
  return self.world->GetTreeBalance();
}

- (NSInteger)treeQuality
{
  return self.world->GetTreeQuality();
}

- (CGPoint)gravity
{
  return CGPointFromVector(self.world->GetGravity());
}

- (void)setGravity:(CGPoint)gravity
{
  self.world->SetGravity(b2Vec2FromPoint(gravity));
}

- (bool)isLocked
{
  return self.world->IsLocked();
}

- (bool)autoClearForces
{
  return self.world->GetAutoClearForces();
}

- (void)setAutoClearForces:(bool)autoClearForces
{
  self.world->SetAutoClearForces(autoClearForces);
}

- (B2DProfile *)profile
{
  b2Profile boxProfile = self.world->GetProfile();
  
  B2DProfile *profile = [[B2DProfile alloc] init];
  profile.step = boxProfile.step;
  profile.collide = boxProfile.collide;
  profile.solve = boxProfile.solve;
  profile.solveInit = boxProfile.solveInit;
  profile.solveVelocity = boxProfile.solveVelocity;
  profile.solvePosition = boxProfile.solvePosition;
  profile.broadphase = boxProfile.broadphase;
  profile.solveTOI = boxProfile.solveTOI;
  
  return [profile autorelease];
}


#pragma mark - Methods

- (void)setContactListener:(B2DContactListener *)contactListener
{
  self.world->SetContactListener(contactListener.contactListener);
}

- (void)setContactFilter:(B2DContactFilter *)contactFilter
{
  self.world->SetContactFilter(contactFilter.contactFilter);
}

- (void)setDestructionListener:(B2DDestructionListener *)destructionListener
{
  self.world->SetDestructionListener(destructionListener.destructionListener);
}

- (void)setDebugDraw:(B2DDraw *)draw
{
  self.world->SetDebugDraw(draw.draw);
}

- (B2DBody *)createBody:(B2DBodyDef *)bodyDefinition
{
  b2BodyDef body;
  
  body.type = (b2BodyType)bodyDefinition.type;
  body.position = b2Vec2FromPoint(bodyDefinition.position);
  body.angle = bodyDefinition.angle;
  body.linearVelocity = b2Vec2FromPoint(bodyDefinition.linearVelocity);
  body.angularVelocity = bodyDefinition.angularVelocity;
  body.linearDamping = bodyDefinition.linearDamping;
  body.angularDamping = bodyDefinition.angularDamping;
  body.allowSleep = bodyDefinition.allowSleep;
  body.awake = bodyDefinition.awake;
  body.fixedRotation = bodyDefinition.fixedRotation;
  body.bullet = bodyDefinition.bullet;
  body.active = bodyDefinition.active;
  body.userData = NULL;
  body.gravityScale = bodyDefinition.gravityScale;
  
  return [[[B2DBody alloc] initWithBody:self.world->CreateBody(&body)] autorelease];
}

- (void)destroyBody:(B2DBody *)body
{
  self.world->DestroyBody(body.body);
}

- (void)stepWithDelta:(CGFloat)delta velocityInteractions:(int)velocityInteractions positionInteractions:(int)positionInteractions
{
  self.world->Step(delta, velocityInteractions, positionInteractions);
}

- (void)clearForces
{
  self.world->ClearForces();
}

- (void)queryAABBWithCallback:(B2DQueryCallback *)queryCallback andAABB:(B2DAABB *)aabb
{
  b2AABB boxAABB;
  boxAABB.lowerBound = b2Vec2FromPoint(aabb.lowerBound);
  boxAABB.upperBound = b2Vec2FromPoint(aabb.upperBound);
  
  self.world->QueryAABB(queryCallback.queryCallback, boxAABB);
}

- (void)rayCastWithCallback:(B2DRayCastCallback *)rayCastCallback andPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2
{
  self.world->RayCast(rayCastCallback.rayCastCallback, b2Vec2FromPoint(point1), b2Vec2FromPoint(point2));
}

- (void)drawDebugData
{
  self.world->DrawDebugData();
}

- (void)dump
{
  self.world->Dump();
}


#pragma mark - Deprecated

- (void)addContactListener:(B2DContactListener *)contactListener
{
  NSLog(@"Deprecated Method: User setContactListener: instead.");
  self.world->SetContactListener(contactListener.contactListener);
}

- (BOOL)continuousPhysics
{
  NSLog(@"Deprecated Method: This method is for testing purposes only.");
  return self.world->GetContinuousPhysics();
}

- (void)setContinuousPhysics:(BOOL)continuousPhysics
{
  NSLog(@"Deprecated Method: This method is for testing purposes only.");
  self.world->SetContinuousPhysics(continuousPhysics);
}

- (B2DBody *)createBodyInPosition:(CGPoint)position
                             type:(B2DBodyTypes)bodyType
{
  NSLog(@"Deprecated Method: User createBody: instead.");
  b2BodyDef bodyDefinition;
  bodyDefinition.type = [self convertBodyType:bodyType];
  bodyDefinition.position.Set(position.x, position.y);

  b2Body *body = self.world->CreateBody(&bodyDefinition);

  return [[[B2DBody alloc] initWithBody:body] autorelease];
}

- (void)removeBody:(B2DBody *)body
{
  NSLog(@"Deprecated Method: User destroyBody: instead.");
  self.world->DestroyBody(body.body);
}

- (b2BodyType)convertBodyType:(B2DBodyTypes)bodyType
{
  NSLog(@"Deprecated Method: This method is not longer needed");
  b2BodyType convertedBodyType = b2_staticBody;

  if (bodyType == kKinematicBodyType)
  {
    convertedBodyType = b2_kinematicBody;
  }
  else if(bodyType == kDynamicBodyType)
  {
    convertedBodyType = b2_dynamicBody;
  }

  return convertedBodyType;
}



@end
