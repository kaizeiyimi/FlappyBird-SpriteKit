//
//  XLMacros.h
//  flappyBird-kaizei
//
//  Created by 王凯 on 14-3-13.
//  Copyright (c) 2014年 王凯. All rights reserved.
//

#ifndef flappyBird_kaizei_XLMacros_h
#define flappyBird_kaizei_XLMacros_h

static const uint32_t kXLBirdBitMask    =  0x1 << 0;
static const uint32_t kXLBlockBitMask   =  0x1 << 1;

static const CGFloat kXLFloorHeight = 40.0;

static const CGFloat KXLBackgroundScrollingSpeed = 0.5 * 60;
static const CGFloat kXLFloorScrollingSpeed = 60;

static const CGFloat kXLPipeGenerationTimeInterval = 180 / kXLFloorScrollingSpeed;
static const CGFloat kXLPipeGapHeight = 120.0;
static const CGFloat kXLPipeWidth = 52;

#endif
