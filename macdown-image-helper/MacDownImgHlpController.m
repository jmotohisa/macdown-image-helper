//
//  MacDownImgHlpController.m
//  macdown-image-helper
//
//  Created by Junichi Motohisa
//  Copyright © 2016 J. Motohisa, All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MacDownImgHlpController.h"
//#import "RandomBytes.h"
#import "NSData+MD5.h"

#define LEN 8

@protocol MacDownMarkdownSource <NSObject>

@property (readonly) NSString *markdown;

@end


@implementation MacDownImgHlpController

- (NSString *)name
{
    return @"image-helper";
}

- (BOOL)run:(id)sender
{
    NSDocumentController *dc = [NSDocumentController sharedDocumentController];
    return [self imagehelper:dc.currentDocument];
}

- (BOOL)imagehelper:(NSDocument *)document
{
    // get contents of the pastboard as png file
    
    // create instance of NSPasteboard
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    // take image
    NSArray *classArray = [NSArray arrayWithObject:[NSImage class]];
    NSDictionary *options = [NSDictionary dictionary];
    BOOL ok = [pasteboard canReadObjectForClasses:classArray options:options];
    
    if (!ok) {
        NSLog(@"no valid image data");
        return NO;
    }
    
    NSArray *objectsToPaste = [pasteboard readObjectsForClasses:classArray options:options];
    NSImage *image = [objectsToPaste objectAtIndex:0];
//        NSImage *image = [pasteboard valueForPasteboardType:@"public.image"];
    BOOL interlaced=true;
    
    // Set data into image,filename, interlaced
    NSData *data = [image TIFFRepresentation];
    NSBitmapImageRep *bitmapImageRep = [NSBitmapImageRep imageRepWithData:data];
    NSDictionary *properties = [NSDictionary
                  dictionaryWithObject:[NSNumber numberWithBool:interlaced]
                  forKey:NSImageInterlaced];
    data = [bitmapImageRep representationUsingType:NSPNGFileType
                                        properties:properties];
 
//    id<MacDownMarkdownSource> markdownSource = (id)document;
//    NSString *markdown = markdownSource.markdown;
//    if (!markdown.length)
//        return NO;
    
    // get folder and filname of the markdown document
    NSString *mdFileName = document.fileURL.path.lastPathComponent;
    if (!mdFileName.length)
    {
        NSLog(@"file is not saved.");
        return NO;
    }
//        mdFileName = @"Untitled";
    
    // File name and path name for an image file based on the MD5 hash
    NSString *imgFileName0 =[[data MD5] substringWithRange:NSMakeRange(0, 6)];
    NSString *imgFileName = [NSString stringWithFormat:@"%@_%@.png",[mdFileName stringByDeletingPathExtension],imgFileName0];
    NSString *imgFolder =@"imgFolder";
    NSString *imgName = [imgFolder stringByAppendingPathComponent:imgFileName];

//    NSLog(@"mdFileName: %@",mdFileName);
//    NSLog(@"imgFileName: %@",imgFileName);
//    NSLog(@"imgName: %@",imgName);

    // Determine the location of file to save
    NSString *mdFolderPath = [document.fileURL.path stringByDeletingLastPathComponent];
    NSString *imgFolderPath = [mdFolderPath stringByAppendingPathComponent:imgFolder];
    NSString *filePath = [imgFolderPath stringByAppendingPathComponent:imgFileName];

//  NSLog(@"mdFolderPath: %@",mdFolderPath);
//  NSLog(@"imgFolderPath: %@",imgFolderPath);
//  NSLog(@"filePath: %@",filePath);
    
    // check directory
    // Manage *manage = [[Manage alloc] init];
    NSFileManager *filemanager = [ NSFileManager defaultManager];
    BOOL isDir = NO;
    if([filemanager fileExistsAtPath:imgFolderPath isDirectory:&isDir])
    {
        if( isDir == YES ){
//            NSLog(@"directory exists.");
        } else {
            NSLog(@"Error: file exsists.");
            return NO;
        }
    } else {
//        NSLog(@"Create Directory: %@",imgFolderPath);
        NSError *error = nil;
        BOOL created = [filemanager createDirectoryAtPath:imgFolderPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
        // Folder creation failure
        if (!created) {
            NSLog(@"failed to create directory. reason is %@ - %@", error, error.userInfo);
        }
    }
    
    // save image file
    if ([data writeToFile:filePath atomically:YES]) {
//        NSLog(@"Ok:file write to %@",filePath);
    } else {
        NSLog(@"Error: failed to write file.");
    }
    
    // paste imgName into pasteboard (with md format)
    NSString *str=[NSString stringWithFormat:@"![](%@)",imgName];
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:str forType:NSStringPboardType];
    return YES;
}

@end
