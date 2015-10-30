//
//  ViewController.m
//  SuperImage
//
//  Created by leaf_kai on 15/10/22.
//  Copyright © 2015年 leaf_kai. All rights reserved.
//

#import "ViewController.h"
#import "QKQuestion.h"

@interface ViewController ()

//问题集合 懒加载的数据在这里
@property (nonatomic, strong) NSArray *questions;

//控制题目索引的属性
@property (nonatomic, assign) int index;
//显示当前第几题
@property (weak, nonatomic) IBOutlet UILabel *lblIndex;
//显示图片标题
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
//显示积分的按钮
@property (weak, nonatomic) IBOutlet UIButton *btnScore;
//显示中间大图的按钮
@property (weak, nonatomic) IBOutlet UIButton *btnIcon;
//提示按钮
@property (weak, nonatomic) IBOutlet UIButton *btnTip;
//帮助按钮
@property (weak, nonatomic) IBOutlet UIButton *btnHelp;
//查看大图的按钮
@property (weak, nonatomic) IBOutlet UIButton *btnBigImg;
//下一题
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
//记录原始的icon 的frame
@property (nonatomic, assign) CGRect iconFrame;
//阴影按钮
@property (nonatomic, weak) UIButton *coverBtn;
//答案按钮的view
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *optionsView;
//间隔
@property (nonatomic, assign) float margin;
//答案按钮的宽高
@property (nonatomic, assign) float btnWidth;

@property (nonatomic, assign) float btnHeight;

- (IBAction)btnIconClick:(id)sender;

- (IBAction)btnNextClick:(id)sender;
- (IBAction)btnBigImgClick:(id)sender;

@end

@implementation ViewController

//重写状态栏的颜色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//懒加载数据  get方法  测试啊    啊啊啊
-(NSArray *)questions
{
    if (_questions == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"questions.plist" ofType:nil];
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *muArrayModel = [NSMutableArray array];
        //遍历数据
        for (NSDictionary *dict in tempArray) {
            QKQuestion *model = [QKQuestion questionwithDict:dict];
            [muArrayModel addObject:model];
            
        }
        _questions = muArrayModel;
    }
    return  _questions;
}

//点击下一题
-(void)nextQuestion
{
    //删除子控件
//    while (self.answerView.subviews.firstObject) {
//        [self.answerView.subviews.firstObject removeFromSuperview];
//    }
    //第二种删除子控件的方法 让每一个控件调用一下删除自己的方法。
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   //index ++
    self.index++;
    //从当前数组集合中找到 当前index 的model
    QKQuestion *tempModel = self.questions[self.index];
    [self setModelToView:tempModel];
   //创建答案按钮
    [self createAnswerBtns:tempModel];
    //生成 待选答案的按钮
    [self createOptionsBtn:tempModel];
    self.optionsView.userInteractionEnabled = YES;
    
}

//加载数据 将模型中数据设置到界面上
-(void)setModelToView:(QKQuestion *)tempModel
{
    //把model 数据设置到界面对应的控件上
    self.lblIndex.text = [NSString stringWithFormat:@"%d / %ld", self.index+1, self.questions.count];
    self.lblTitle.text = tempModel.title;
    UIImage *tempImg = [UIImage imageNamed:tempModel.icon];
    //图片状态
    [self.btnIcon setImage:tempImg forState:UIControlStateNormal];
    
    //设置到达最后一题  下一题按钮不可用
    self.btnNext.enabled = (self.index != self.questions.count -1);
}


//生成答案按钮
-(void)createAnswerBtns:(QKQuestion *)tempModel
{
    //生成答案按钮
    int count = tempModel.answer.length;
    float marginLeft = (self.answerView.frame.size.width - (count * self.btnWidth) - (count -1) * self.margin)*0.5;
    for (int i=0; i<count; i++) {
        UIButton *tempAbtn = [[UIButton alloc]init];
        [tempAbtn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [tempAbtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateNormal];
        [tempAbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        tempAbtn.frame = CGRectMake((marginLeft + i * (self.btnWidth + self.margin)), 0, self.btnWidth, self.btnHeight);
        [tempAbtn addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.answerView addSubview:tempAbtn];
    }
}


//答案阿牛点击
-(void)answerClick:(UIButton *)sender
{
    //启用点击
    self.optionsView.userInteractionEnabled = YES;
//    for (UIButton *tempbtn in self.optionsView.subviews) {
//        if ([tempbtn.currentTitle isEqualToString:sender.currentTitle]) {
//            tempbtn.hidden = NO;
//            break;
//        }
//    }
    for (UIButton *tempbtn in self.optionsView.subviews) {
        if (tempbtn.tag == sender.tag) {
            tempbtn.hidden = NO;
            break;
        }
    }
    [sender setTitle:nil forState:UIControlStateNormal];
}


//生成带选项的按钮
-(void)createOptionsBtn:(QKQuestion *)tempModel
{
    //清除带选项按钮
    [self.optionsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //获取options 数量
    int count = tempModel.options.count;
    //一行放7个
    int num = 7;
    //算出间隔
    float margin = (self.optionsView.frame.size.width - (num * self.btnWidth)) / (num + 1);
    
    float marginy = 10;
    NSArray *words = tempModel.options;
    for (int i =0; i<count; i++) {
        //行索引
        int colx = i % num;
        //列索引
        int rowY = i / num;
        UIButton *tempobtn = [[UIButton alloc]init];
        [tempobtn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [tempobtn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateNormal];
        [tempobtn setTitle:words[i] forState:UIControlStateNormal];
        [tempobtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGFloat optionx = margin + colx * (margin + self.btnWidth);
        CGFloat optiony = rowY * (marginy + self.btnHeight);
        
        tempobtn.frame = CGRectMake(optionx, optiony, self.btnWidth, self.btnHeight);
        tempobtn.tag = i;
        [self.optionsView addSubview:tempobtn];
        //注册事件
        [tempobtn addTarget:self action:@selector(optionsClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}


//options click
-(void)optionsClick:(UIButton *)sender
{
    sender.hidden = YES;
    NSString *optext= [sender titleForState:UIControlStateNormal];
    //或者
    optext = sender.currentTitle;
    //显示第一个不为空的按钮
    for (UIButton *tempBtn in self.answerView.subviews) {
        //判断每个答案按钮的文字不为空
        if (tempBtn.currentTitle == nil) {
            [tempBtn setTitle:optext forState:UIControlStateNormal];
            tempBtn.tag = sender.tag;
            break;
        }
    }
    
    //假设已经满了
    BOOL isFull = YES;
    for (UIButton *tempbtn1 in self.answerView.subviews) {
        if (tempbtn1.currentTitle == nil) {
            isFull = NO;
            break;
        }
    }
    if (isFull) {
        self.optionsView.userInteractionEnabled = NO;
    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.btnWidth = 44;
    self.btnHeight = 44;
    self.margin = 10;
    self.index = -1;
    [self nextQuestion];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnIconClick:(id)sender {
    if (self.coverBtn == nil) {
        //放大
        [self btnBigImgClick:nil];
    }
    else
    {
        //缩小
        [self coverBtnClick];
    }
}

- (IBAction)btnNextClick:(id)sender {
    [self nextQuestion];
}

//变成小兔
-(void)coverBtnClick
{
//    NSLog(@"sdfsdf");
    //frame 还原  阴影alpha 还原成0   然后 移除阴影按钮
    [UIView animateWithDuration:0.7 animations:^{
        self.btnIcon.frame = self.iconFrame;
        self.coverBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self.coverBtn removeFromSuperview];
        //把蒙版按钮变成nil
        self.coverBtn = nil;
    }];
    
}

- (IBAction)btnBigImgClick:(id)sender {
    //记录原始的frame
    self.iconFrame = self.btnIcon.frame;
    //创建一个按钮 大小与self.view 一样的阴影
    UIButton *coverBtn = [[UIButton alloc]init];
    //因为bounds xy为0  大小是自己 所以这个是简便方法
//    self.coverBtn.frame = self.view.bounds;
    coverBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    coverBtn.backgroundColor = [UIColor blackColor];
    coverBtn.alpha = 0;
    [coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:coverBtn];
    //把图片按钮设置再阴影之上
    //将这个显示图片的那个按钮btnIcon 设置到整个view 里面控件的最上方
    [self.view  bringSubviewToFront:self.btnIcon];
    //改变原来图片按钮的大小及位置
    CGFloat imgWidth = self.view.frame.size.width;
    CGFloat imgHeight = imgWidth;
    CGFloat imgX = 0;
    CGFloat imgY = (self.view.frame.size.height - imgHeight)*0.5;
    [UIView animateWithDuration:0.7 animations:^{
        coverBtn.alpha = 0.6;
        self.btnIcon.frame = CGRectMake(imgX, imgY, imgWidth, imgHeight);
    }];
    self.coverBtn = coverBtn;
    
    //通过动画的方式把图片放大
}



@end
