//
//  SampleHandler.m
//  record
//
//  Created by Fane on 2021/2/28.
//  Copyright © 2021 Smile Financial. All rights reserved.
//


#import "SampleHandler.h"
#import "ZXAppGroupManager.h"


#define kExtensionCountdownTime   4
#define kExtensionShotcutTime     3.9


@interface SampleHandler()

@property(nonatomic,strong)RPScreenRecorder* screenRecorder;
@property(nonatomic,strong)AVAssetWriter* assetWriter;
@property(nonatomic,strong)AVAssetWriterInput* assetWriterInput;
@property(nonatomic,strong)NSString* videoOutPath;
@property(nonatomic,strong)AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor;
@property(nonatomic,strong)AVCaptureSession *captureSession;

@property (nonatomic, assign) BOOL countdownOut;

@end

@implementation SampleHandler

- (NSString*)recordName{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.wcsz.ios.app"];
   NSString *recordName = [userDefaults stringForKey:@"recordname"];
//   NSDictionary* nameDic = [ZXAppGroupManager.defaultManager dictionaryFromFile:@"kRecordTypeName"];
//    NSString *recordName = [nameDic valueForKey:@"recordname"];
    return @"recordName";
    return recordName;
}


- (void)setupDocumentPath{
    NSString *outputURL = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    self.videoOutPath = [[outputURL stringByAppendingPathComponent:[self recordName]] stringByAppendingPathExtension:@"mp4"];
    NSLog(@"self.videoOutPath=%@",self.videoOutPath);
    
    NSFileManager *manager = NSFileManager.defaultManager;
    if ([manager fileExistsAtPath:self.videoOutPath]) {
       BOOL res = [manager removeItemAtPath:self.videoOutPath error:nil];
        NSLog(@"----------extension doumentment setup %d",res);
    }

}

//初始化录屏所需类
- (void)startScreenRecording {
    
    self.captureSession = [[AVCaptureSession alloc]init];
    self.screenRecorder = [RPScreenRecorder sharedRecorder];
    if (self.screenRecorder.isRecording) {
        return;
    }
    
    //沙盒路径设置
    [self setupDocumentPath];

    
    self.assetWriter = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:self.videoOutPath] fileType:AVFileTypeMPEG4 error:nil];
    
    NSDictionary *compressionProperties =
        @{AVVideoProfileLevelKey         : AVVideoProfileLevelH264HighAutoLevel,
          AVVideoH264EntropyModeKey      : AVVideoH264EntropyModeCABAC,
          AVVideoAverageBitRateKey       : @(1920 * 1080 * 11.4),
          AVVideoMaxKeyFrameIntervalKey  : @60,
          AVVideoAllowFrameReorderingKey : @NO};
    
    NSNumber* width= [NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.width];
    NSNumber* height = [NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.height];
    
    NSDictionary *videoSettings =
        @{
          AVVideoCompressionPropertiesKey : compressionProperties,
          AVVideoCodecKey                 : AVVideoCodecTypeH264,
          AVVideoWidthKey                 : width,
          AVVideoHeightKey                : height
          };
    
    self.assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    self.pixelBufferAdaptor =
    [[AVAssetWriterInputPixelBufferAdaptor alloc]initWithAssetWriterInput:self.assetWriterInput
                                              sourcePixelBufferAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA],kCVPixelBufferPixelFormatTypeKey,nil]];
    [self.assetWriter addInput:self.assetWriterInput];
    [self.assetWriterInput setMediaTimeScale:60];
    [self.assetWriter setMovieTimeScale:60];
    [self.assetWriterInput setExpectsMediaDataInRealTime:YES];
    
    //写入视频
    [self.assetWriter startWriting];
    [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    [self.captureSession startRunning];
    
}

#pragma mark - 录屏代理方法 -
//- (void)completeRequestWithBroadcastURL:(NSURL *)broadcastURL setupInfo:(nullable NSDictionary <NSString *, NSObject <NSCoding> *> *)setupInfo{
//    NSLog(@"----------");
//}

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(defaultsChanged:)
//                                                 name:NSUserDefaultsDidChangeNotification
//                                               object:nil];
    NSLog(@"------>>>>>>>>+++++++++++broadcastStartedWithSetupInfo");

    [ZXAppGroupManager.defaultManager passMessageObject:setupInfo type:@"broadcastStartedWithSetupInfo"];
    [self startScreenRecording];

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    dispatch_queue_t currentQue = dispatch_queue_create("com.zxsd.extension.countdown.processing", DISPATCH_QUEUE_CONCURRENT);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kExtensionCountdownTime * NSEC_PER_SEC), currentQue, ^{
        self.countdownOut = YES;
        [self broadcastFinished];
        
        UIImage *snapshotImage = [self shotcutOnFrameInVideo];
        BOOL res = [ZXAppGroupManager.defaultManager saveData:UIImageJPEGRepresentation(snapshotImage, 1.0) toFile:@"kGroupImage"];
        if (res) {
            [self defaultsChanged:nil];
        }
        else{
            NSLog(@"---------");
        }
    });
    
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    
    if (self.countdownOut) {
        return;
    }
    
    switch (sampleBufferType) {
            
        case RPSampleBufferTypeVideo:
            // Handle video sample buffer for app audio
        {
            CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            static int64_t frameNumber = 0;
            if(self.assetWriterInput.readyForMoreMediaData){
                NSLog(@"录屏中写入...");
                [self.pixelBufferAdaptor appendPixelBuffer:imageBuffer
                                      withPresentationTime:CMTimeMake(frameNumber, 25)];
            }
            
            frameNumber++;
            
            NSLog(@"已获取的长度%lu",[NSData dataWithContentsOfFile:self.videoOutPath].length);
        }
            break;
        case RPSampleBufferTypeAudioApp:
            // Handle audio sample buffer for app audio
            break;
        case RPSampleBufferTypeAudioMic:
            // Handle audio sample buffer for mic audio
            break;
        default:
            break;
    }
}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.
    NSLog(@"暂停录屏");
    
}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.
    NSLog(@"继续录屏");
    
}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
    [self.captureSession stopRunning];
    
    [self.assetWriter finishWritingWithCompletionHandler:^{
        self.captureSession = nil;
        self.assetWriter = nil;
    }];
    
//        NSData *videoData = [ZXAppGroupManager.defaultManager dataFromFile:filename];
    //    NSLog(@"----------videoData lenght:%lu",(unsigned long)videoData.length);
    
    
//    NSData* data = [NSData dataWithContentsOfFile:self.videoOutPath];
    
    //存储数据到共享区:SuiteName和宿主必须一致
//    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.wcsz.ios.app"];
//
//    [userDefaults setValue:data forKey:@"key"];
//    [userDefaults synchronize];
    
    
}

#pragma mark - noti -

- (void)defaultsChanged:(NSNotification*)noti{
    
    //向宿主发送通知
    [ZXAppGroupManager.defaultManager passMessageObject:@{@"filename":[self recordName]} type:@"broadcastFinished"];
    
    NSError *error = [[NSError alloc] initWithDomain:@"录屏已完成" code:-1 userInfo:@{NSLocalizedFailureReasonErrorKey:@"录屏已完成，前往“薪朋友”app以便继续您的上传流程？"}];
    
//    dispatch_queue_t currentQue = dispatch_queue_create("com.zxsd.extension.finishBroadcastWithError", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_after(dispatch_walltime(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), currentQue, ^{
        
        
//        NSUserDefaults *userDefaults = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.com.wcsz.ios.app"];
//        NSData* videoData = [userDefaults valueForKey:@"key"];
//        UIImage *img = [UIImage imageWithData:videoData];
        [self finishBroadcastWithError:error];

//    });


}

#pragma mark - image handle -
- (void)extensionScreenShotcutHandle{
    
    
//    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//    // 1.开启上下文
//    UIGraphicsBeginImageContextWithOptions(window.bounds.size, window.opaque, 0);
//    // 2.渲染
//    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
//    // 3.获取图片
//    UIImage *snapshotImage=UIGraphicsGetImageFromCurrentImageContext();
//    // 4.结束上下文
//    UIGraphicsEndImageContext();
}

- (UIImage*)shotcutOnFrameInVideo{
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.videoOutPath] options:nil];
    
    CMTime cmtime = asset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    
    //获取视频缩略图
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    
    CMTime requestTime;
    
    
   NSDictionary *typeNameDic = [ZXAppGroupManager.defaultManager dictionaryFromFile:@"kGroupScoreTypeName"];
    CGFloat rTime = 0.5;
    if (IsValidDictionary(typeNameDic)) {
        
        NSString *lTime = [typeNameDic objectForKey:@"kGroupScoreTypeName"];
        
        if ([lTime isKindOfClass:NSString.class] &&
            [lTime rangeOfString:@"wechat"].location != NSNotFound) {
            rTime = 0.86;
        }
        
    }
    
    requestTime =CMTimeMakeWithSeconds(durationSeconds*rTime, 60);  // CMTime是表示电影时间信息的结构体，第一个参数表示是视频当前时间，第二个参数表示每秒帧数
    
    NSError*  error =nil;
    
    CMTime actualTime;
    
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:&error];
    
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return thumbImg;

    
}


-(UIImage*)thumbnailImageWithAtTime:(NSTimeInterval)inputTime forVideo:(NSURL *)videoURL{
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    
    //获取视频缩略图
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    
    CMTime requestTime;
    
    requestTime =CMTimeMakeWithSeconds(inputTime, 60);  // CMTime是表示电影时间信息的结构体，第一个参数表示是视频当前时间，第二个参数表示每秒帧数
    
    NSError*  error =nil;
    
    CMTime actualTime;
    
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:&error];
    
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return thumbImg;
    
}


@end
