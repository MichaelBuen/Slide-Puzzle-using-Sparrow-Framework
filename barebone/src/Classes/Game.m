//
//  Game.m
//  AppScaffold
//

#import "Game.h" 

@implementation Game
{
    SPSprite *_tiles[23];
    
    SPSprite *_currentTile;
    int _currentDirection; // 0 on X, 1 on Y
    
    int _beforeDragX;
    int _beforeDragY;

}

-(void) moveCurrentSpriteX : (int) deltaX
{

    int newX = _currentTile.x + deltaX;

    
     int detectX = deltaX > 0 ? newX + 80 : newX - 80;
    
    for (int i = 0; i < 23 ; ++i ) {
        
        SPSprite *tile = _tiles[i];
        
        if (tile == _currentTile || tile.y != _currentTile.y) continue;
        
        if (deltaX > 0) {
            if (tile.x < _currentTile.x) continue;
        }
        else if (deltaX < 0 ){
            if (tile.x > _currentTile.x) continue;
        }
        
        
       
        if (deltaX > 0) {
            if (detectX >= tile.x) {
                return;
            }
        }
        else if (deltaX < 0) {
            if (detectX <= tile.x) {
                return;
            }
        }

        
    }
    

    _currentTile.x = newX;
}

-(void) moveCurrentSpriteY : (int) deltaY
{

    int newY = _currentTile.y + deltaY;
    
    
    int detectY = deltaY > 0 ? newY + 80 : newY - 80;
    
    
    for (int i = 0; i < 23 ; ++i) {
        
        SPSprite *tile = _tiles[i];
        
        if (tile == _currentTile || tile.x != _currentTile.x) continue;
        
        if (deltaY > 0) {
            if (tile.y < _currentTile.y) continue;
        }
        else if (deltaY < 0 ){
            if (tile.y > _currentTile.y) continue;
        }
        
        
        
        if (deltaY > 0) {
            if (detectY >= tile.y) {
                return;
            }
        }
        else if (deltaY < 0) {
            if (detectY <= tile.y )
                return;
        }
        

    }
    
    
    _currentTile.y = newY;
}

-(void)onTouched:(SPTouchEvent *) event
{
//        // http://forum.sparrow-framework.org/topic/possible-to-get-spsprite-object-that-touch-in-event-sp_event_type_touch

    
    {
        SPTouch *dragBegan = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] anyObject];
        if (dragBegan) {
            SPDisplayObject *image = (SPDisplayObject *) event.target;
            _currentTile = (SPSprite *)image.parent;
            
            _beforeDragX = _currentTile.x;
            _beforeDragY = _currentTile.y;
            
        }
    }
    
    
    // Dragging
    {
        SPTouch *drag = [[event touchesWithTarget:self andPhase:SPTouchPhaseMoved] anyObject];
        if (drag) {

            SPPoint *dragLocation = [drag locationInSpace:_currentTile];
            SPPoint *prevDragLocation = [drag previousLocationInSpace:_currentTile];
            
 

            if (_currentDirection == -1) {
            
                int deltaX = dragLocation.x - prevDragLocation.x;
                int deltaY = dragLocation.y - prevDragLocation.y;
                
                int absDeltaX = abs(deltaX);
                int absDeltaY = abs(deltaY);
                
                if (absDeltaX > absDeltaY) {
                    _currentDirection = 0;
                    [self moveCurrentSpriteX: deltaX];
                }
                else if (absDeltaY > absDeltaX) {
                    _currentDirection = 1;
                    [self moveCurrentSpriteY: deltaY];
                }
            }
            else {
                if (_currentDirection == 0) {
                    int deltaX = dragLocation.x - prevDragLocation.x;
                    [self moveCurrentSpriteX: deltaX];
                }
                else if (_currentDirection == 1){
                    int deltaY = dragLocation.y - prevDragLocation.y;
                    [self moveCurrentSpriteY: deltaY];
                }
            }
            
            
            
         }
    }//Draggin
    
    
    // Drag End
    {
        SPTouch *dragEnded = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
        if (dragEnded) {

            
            SPPoint *dragLocation = [dragEnded locationInSpace:self];
            
            if (_currentDirection == 0) {
                
                int newX = (int) dragLocation.x / 80 * 80;
                
                
                BOOL blank = true;

                int i = 0;
                for (i = 0; i < 23; ++i) {
                    SPSprite *tile = _tiles[i];
                    
                    if (tile.x == newX && tile.y == _currentTile.y) {
                        if (tile != _currentTile) {
                            blank = false;
                            break;
                        }
                    }
                }
                
                if (blank && abs(newX - _beforeDragX) <= 80)
                    _currentTile.x = newX;
            }
            else if (_currentDirection == 1) {

                
                int newY = (int) dragLocation.y / 80 * 80;
                
                BOOL blank = true;
                
                int i;
                for (i = 0; i < 23; ++i) {
                    SPSprite *tile = _tiles[i];
                    
                    if (tile.y == newY && tile.x == _currentTile.x) {
                        if (tile != _currentTile) {
                            blank = false;
                            break;
                        }
                    }
                }
                
                if (blank && abs(newY - _beforeDragY) <= 80)
                    _currentTile.y = newY;
            }
            
        

            
            // Normalize
            _currentTile.x = (int)_currentTile.x / 80 * 80;
            _currentTile.y = (int)_currentTile.y / 80 * 80;
            
            _currentTile = NULL;
            _currentDirection = -1;
            
           

        }
    }// Drag End
}

- (id)init
{
    
    if ((self = [super init]))
    {
        
        _currentTile = NULL;
        _currentDirection = -1;


        SPTexture *baseTexture = [SPTexture textureWithContentsOfFile:@"spiderman.jpg"];
        

        
        for (int i = 0; i < 23; ++i) {
            
            int x = i % 4;
            int y = i / 4;
            
            
            int xOffset = x * 80;
            int yOffset = y * 80;
            
            SPTexture *partialTexture = [SPTexture textureWithRegion:[SPRectangle rectangleWithX:xOffset y:yOffset width:80 height:80] ofTexture:baseTexture];
            SPImage *image = [SPImage imageWithTexture:partialTexture];
            
            SPSprite *sprite = [SPSprite sprite];
            [sprite addChild: image];
            
            sprite.x = xOffset;
            sprite.y = yOffset;
            
            [sprite addEventListener:@selector(onTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
            
            _tiles[i] = sprite;
        }
        
        for (int i = 0; i < 23; ++i) {
            [self addChild: _tiles[i]];
        }
        
        
        for (int i = 22, n = 0; i >= 0; --i, ++n) {
            SPSprite *sprite = _tiles[i];
            
            int x = n % 4;
            int y = n / 4;
            
            
            int xOffset = x * 80;
            int yOffset = y * 80;
            
            sprite.x = xOffset;
            sprite.y = yOffset;
        }
        
        

        
        
        
        // Per default, this project compiles as an universal application. To change that, enter the
        // project info screen, and in the "Build"-tab, find the setting "Targeted device family".
        //
        // Now Choose:  
        //   * iPhone      -> iPhone only App
        //   * iPad        -> iPad only App
        //   * iPhone/iPad -> Universal App  
        // 
        // The "iOS deployment target" setting must be at least "iOS 5.0" for Sparrow 2.
        // Always used the latest available version as the base SDK.
    }
    return self;
}

@end
