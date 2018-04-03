//
//  CollectionViewCell.m
//  CloundSafe
//
//  Created by LittleMian on 16/7/6.
//
//

#import "CSCollectionCell.h"
#import "UIView+Layout.h"
#import "CSPicture.h"
#import "FICImageCache.h"
@interface CSCollectionCell()
@property (strong, nonatomic) UITapGestureRecognizer *fullScreenRecognizer;
@end
@implementation CSCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.selectPhotoButton = [[UIButton alloc] init];
        [self.selectPhotoButton addTarget:self action:@selector(selectPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectPhotoButton];
        
        self.selectImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_selectImageView];
        UIImage *image = self.selectPhotoButton.isSelected ? [UIImage imageNamed:@"photo_sel"] : [UIImage imageNamed:@"photo_des"];
        self.selectImageView.image = image;
        
        self.imageView = [[UIImageView alloc]init];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:self.imageView];
        
        //将selectPhotoButton和selectImageView推到视图层的最前面，避免被imgeView覆盖掉
        [self.contentView bringSubviewToFront:self.selectPhotoButton];
        [self.contentView bringSubviewToFront:self.selectImageView];
        self.fullScreenRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didFullScreenDisplayImage:)];
        [self addGestureRecognizer:self.fullScreenRecognizer];
    }
    return self;
}
- (void)setPlayerImageView:(UIImageView *)playerImageView
{
    _playerImageView = playerImageView;
    [self.contentView addSubview:_playerImageView];
    [_playerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
//        make.size.mas_offset(_playerImageView.image.size);
         make.size.mas_offset(CGSizeMake(40, 40));
    }];
}
- (void)didFullScreenDisplayImage:(UITapGestureRecognizer *)gesture
{
    //[self.delegate passImage:[self.picture sourceImage] imagePath:self.imageIdentifier];
    [self.delegate passimagePath:self.imageIdentifier];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.selectPhotoButton.frame = CGRectMake(self.tz_width - 44, 0, 44, 44);
    self.selectImageView.frame = CGRectMake(self.tz_width - 27, 0, 27, 27);
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.equalTo(self.contentView);
    }];

}

//设置图片
- (void)setPicture:(CSPicture *)picture
{
    if (picture != _picture)
    {
        _picture = picture;
//        self.selectPhotoButton.selected = NO;
//        self.selectImageView.image = [UIImage imageNamed:@"photo_des"];
        [[FICImageCache sharedImageCache] retrieveImageForEntity:picture withFormatName:_imageFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image)
         {
             // This completion block may be called much later. We should check to make sure this cell hasn't been reused for different photos before displaying the image that has loaded.
             if (picture == [self picture])
             {
                 self.imageView.image = image;
             }
         }];

    }
}
- (void)selectPhotoButtonClick:(UIButton *)sender
{
    if (self.didSelectPhotoBlock)//block不为空
    {
        self.didSelectPhotoBlock(sender.isSelected);
    }
    UIImage *image = sender.isSelected ? [UIImage imageNamed:@"photo_sel"] : [UIImage imageNamed:@"photo_des"];
    self.selectImageView.image = image;
    if (sender.isSelected)
    {
        [UIView showOscillatoryAnimationWithLayer:_selectImageView.layer type:TZOscillatoryAnimationToBigger];
    }
}

@end
