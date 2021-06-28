//
//  GameViewController.m
//  MAD_SceneKit
//
//  Created by JingFeng Ma on 2020/3/9.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "RoleViewController.h"
#import "Utils.h"
#import "MapViewController.h"

@interface RoleViewController()
@property (nonatomic, strong) SCNScene *scene;
@property (nonatomic, strong) SCNNode *keysNode;
@property (nonatomic, strong) SCNNode *boxNode;
@property (nonatomic, strong) SCNNode *delivererTextNode;
@property (nonatomic, strong) SCNNode *senderTextNode;
@property (nonatomic, strong) SCNNode *cameraNode;

@property(strong, nonatomic) MapViewController *mapviewController;
@end

@implementation RoleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapviewController = [GET_STORYBOARD(@"Main") instantiateViewControllerWithIdentifier:@"mapViewControllerSID"];
    // create a new scene
//    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    self.scene = [SCNScene sceneNamed:@"art.scnassets/key.scn"];

    // create and add a camera to the scene
    self.cameraNode = [SCNNode node];
    self.cameraNode.camera = [SCNCamera camera];
    [self.scene.rootNode addChildNode:self.cameraNode];

    // place the camera
    self.cameraNode.position = SCNVector3Make(0, 0, 15);
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [self.scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [self.scene.rootNode addChildNode:ambientLightNode];
    
    // retrieve the ship node
    self.keysNode = [self.scene.rootNode childNodeWithName:@"Key" recursively:YES];
    self.boxNode = [self.scene.rootNode childNodeWithName:@"Box" recursively:YES];
    
    SCNText *dText = [SCNText textWithString:@"I'd like to deliver packages" extrusionDepth:0.4f];
    SCNText *sText = [SCNText textWithString:@"I have packages to deliver" extrusionDepth:0.4f];
    dText.font = [UIFont systemFontOfSize:0.7f];
    sText.font = [UIFont systemFontOfSize:0.7f];
    
    self.delivererTextNode = [SCNNode nodeWithGeometry:dText];
    self.senderTextNode = [SCNNode nodeWithGeometry:sText];
    self.delivererTextNode.hidden = YES;
    self.senderTextNode.hidden = YES;
//    SCNMaterial *textMaterial1 = [[SCNMaterial alloc] init];
//    textMaterial1.diffuse.contents = [UIColor systemGrayColor];
//    SCNMaterial *textMaterial2 = [[SCNMaterial alloc] init];
//    textMaterial2.diffuse.contents = [UIColor systemTealColor];
//
//    dText.materials = @[textMaterial1, textMaterial2];
//    sText.materials = @[textMaterial2, textMaterial1];

    [self.scene.rootNode addChildNode:self.delivererTextNode];
    [self.scene.rootNode addChildNode:self.senderTextNode];
    
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // set the scene to the view
    scnView.scene = self.scene;
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = NO;
        
    // show statistics such as fps and timing information
//    scnView.showsStatistics = YES;

    // configure the view
    scnView.backgroundColor = [UIColor blackColor];
    
    // add a tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
    scnView.gestureRecognizers = gestureRecognizers;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.keysNode.hidden = YES;
    self.boxNode.hidden = YES;
    self.delivererTextNode.hidden = YES;
    self.senderTextNode.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    SCNView *scnView = (SCNView *)self.view;
    CGRect bounds = self.view.bounds;
//    float screenZ = (0.0f - self.cameraNode.camera.zNear) / (self.cameraNode.camera.zFar - self.cameraNode.camera.zNear);
    
    SCNVector3 positionOfKeys = [scnView unprojectPoint:SCNVector3Make(bounds.size.width / 4, bounds.size.height / 4, 0)];
    SCNVector3 positionOfBox = [scnView unprojectPoint:SCNVector3Make(bounds.size.width * 3 / 4, bounds.size.height * 3 / 4, 0)];
    [self.keysNode setPosition:SCNVector3Make(positionOfKeys.x * 20, positionOfKeys.y * 20, -50)];
    [self.boxNode setPosition:SCNVector3Make(positionOfBox.x * 20, positionOfBox.y * 20, -50)];
    
    SCNVector3 dTextBoxMin, dTextBoxMax, sTextBoxMin, sTextBoxMax;
    [[self.keysNode.childNodes firstObject] getBoundingBoxMin:&dTextBoxMin max:&dTextBoxMax];
    [[self.boxNode.childNodes firstObject] getBoundingBoxMin:&sTextBoxMin max:&sTextBoxMax];
    
    [self.delivererTextNode setPosition:SCNVector3Make(dTextBoxMin.x - 1.2,
                                                       dTextBoxMin.y + 1,
                                                       -50)];
    [self.senderTextNode setPosition:SCNVector3Make(sTextBoxMin.x - 1,
                                                    sTextBoxMin.y - 1.5,
                                                    -50)];

//    [self.delivererTextNode setPosition:SCNVector3Make(positionOfKeys.x * 20,
//                                                       positionOfKeys.y * 20,
//                                                       -100)];
//    [self.senderTextNode setPosition:SCNVector3Make(positionOfBox.x * 20,
//                                                    positionOfBox.y * 20,
//                                                    -100)];
    
    
    /*self.delivererTextNode.pivot = SCNMatrix4MakeTranslation(
                                                             dTextBoxMin.x + 0.5 * (dTextBoxMax.x - dTextBoxMin.x),
                                                             dTextBoxMin.y + 0.5 * (dTextBoxMax.y - dTextBoxMin.y),
                                                             dTextBoxMin.z + 0.5 * (dTextBoxMax.z - dTextBoxMin.z));
    self.senderTextNode.pivot = SCNMatrix4MakeTranslation(
                                                          sTextBoxMin.x + 0.5 * (sTextBoxMax.x - sTextBoxMin.x),
                                                          sTextBoxMin.y + 0.5 * (sTextBoxMax.y - sTextBoxMin.y),
                                                          sTextBoxMin.z + 0.5 * (sTextBoxMax.z - sTextBoxMin.z));*/
    
    self.keysNode.hidden = NO;
    self.boxNode.hidden = NO;
    self.delivererTextNode.hidden = NO;
    self.senderTextNode.hidden = NO;
    
    // animate the 3d object
    [self.keysNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:5 z:0 duration:1]] forKey:@"KeyRotation_fast"];
    [self.boxNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:-5 z:0 duration:1]] forKey:@"ShipRotation_fast"];
    [self.delivererTextNode runAction:[SCNAction repeatAction:[SCNAction moveByX:0 y:0 z:40 duration:0.8f] count:1]];
    [self.senderTextNode runAction:[SCNAction repeatAction:[SCNAction moveByX:0 y:0 z:40 duration:1.0f] count:1]];
    
    // animate the 3d object with z
    [self.keysNode runAction:[SCNAction repeatAction:[SCNAction moveByX:0 y:0 z:40 duration:0.8f] count:1] completionHandler:^{
        [self.keysNode removeActionForKey:@"KeyRotation_fast"];
        [self.keysNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:0.5 z:0 duration:1]] forKey:@"KeyRotation_slow"];
    }];
    [self.boxNode runAction:[SCNAction repeatAction:[SCNAction moveByX:0 y:0 z:40 duration:1.0f] count:1] completionHandler:^{
        [self.boxNode removeActionForKey:@"ShipRotation_fast"];
        [self.boxNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:-0.5 z:0 duration:1]] forKey:@"ShipRotation_slow"];
    }];
}

- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:scnView];
    NSArray *hitResults = [scnView hitTest:p options:nil];
    
    // check that we clicked on at least one object
    if([hitResults count] > 0){
        // retrieved the first clicked object
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        
        // get its material
        SCNMaterial *material = result.node.geometry.firstMaterial;
        
        // highlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        
        // on completion - unhighlight
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            
            material.emission.contents = [UIColor blackColor];
            
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [UIColor redColor];
        
        [SCNTransaction commit];
        
        if([result.node isEqual:[self.keysNode.childNodes firstObject]]){
            _mapviewController.role = TailWindRole_Deliverer;
            [self.navigationController pushViewController:_mapviewController animated:YES];
        }else if([result.node isEqual:[self.boxNode.childNodes firstObject]]){
            _mapviewController.role = TailWindRole_Sender;
            [self.navigationController pushViewController:_mapviewController animated:YES];
        }
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

/*
 - (SCNVector3)convertToScenOfPoint:(CGPoint)point
 {
     CGFloat Z_Far = 0.1;
     CGFloat Screen_Aspect =  [UIScreen mainScreen].bounds.size.width > 400 ? 0.3 : 0.0;
     double Y = tan((double)(self.scene.pointOfView.camera.fieldOfView/180/2)*M_PI) * (double)(Z_Far-Screen_Aspect);
     double X = tan((double)(self.scene.pointOfView.camera.fieldOfView/2/180)*M_PI) * (double)(Z_Far-Screen_Aspect) * (double)(self.view.bounds.size.width/self.view.bounds.size.height);
     CGFloat alphaX = 2 *  X / self.view.bounds.size.width;
     CGFloat alphaY = 2 *  Y / self.view.bounds.size.height;
     float x = -(CGFloat)X + point.x * alphaX;
     float y = (CGFloat)Y - point.y * alphaY;
     SCNVector3 target = SCNVector3Make((float)(x), (float)(y),(float)(-Z_Far));
     SCNVector3 convertPoint = [self.scene.pointOfView convertVector:target toNode:self.sceneView.scene.rootNode];
     NSLog(@"convertPoint X: %f,Y:%f，Z:%f", convertPoint.x, convertPoint.y, convertPoint.z);
     return convertPoint;
 }
 */

@end
