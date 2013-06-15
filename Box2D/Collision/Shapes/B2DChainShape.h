//
//  B2DChainShape.h
//  Box2D
//
//  Created by Juan José Karam on 6/15/13.
//  Copyright (c) 2013 Joybox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "B2DShape.h"

@class B2DEdgeShape;

@interface B2DChainShape : B2DShape

@property (nonatomic, assign, readonly) NSInteger vertexCount;
@property (nonatomic, assign, readonly) CGPoint *vertices;
@property (nonatomic, assign, readonly) BOOL hasPreviousVertex;
@property (nonatomic, assign, readonly) CGPoint previousVertex;
@property (nonatomic, assign, readonly) BOOL hasNextVertex;
@property (nonatomic, assign, readonly) CGPoint nextVertex;

- (void)createLoopWithVertices:(CGPoint *)vertices andVertexCount:(NSInteger)vertexCount;
- (void)createChainWithVertices:(CGPoint *)vertices andVertexCount:(NSInteger)vertexCount;
- (void)setPreviousVertex:(CGPoint)vertex;
- (void)setNextVertex:(CGPoint)vertex;
- (void)getChildEdge:(B2DEdgeShape *)edgeShape withIndex:(NSInteger)index;

@end