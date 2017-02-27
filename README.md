# XLTools
个人工具库
<h3>XLPicker</h3>
···objc
// 根UITableView用法一样，首先遵循XLPickerDataSource 和XLPickerDelegate(如果不需要处理点击响应，也可不加)
// 必选
@protocol XLPickerDataSource <NSObject>
- (NSInteger)numberOfItemsInPicker:(XLPickerView *)xlPickerView;
- (NSString *)titleForItemAtIndex:(NSInteger)index xlPickerView:(XLPickerView *)picker;

// 可选
@protocol XLPickerDelegate <NSObject>
@optional
- (CGFloat)heightForXLPickerView:(XLPickerView *)picker;
- (void)xlPickerView:(XLPickerView *)picker didSelectItemAtIndex:(NSInteger)index;
- (void)xlPickerView:(XLPickerView *)picker didUnSelectItemAtIndex:(NSInteger)index;
···

<h4>使用示例</h4>
···objc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KLIGHTGRAYCOLOR;
    self.navigationItem.title = @"Debug";
    
    titles = @[
               @"奥斯卡电影"
               ,@"豆瓣电影"
               ,@"美团电影"
               ,@"猫眼电影"
               ,@"腾讯视频"
               ,@"百度视频"
               ,@"爱奇艺"
               ,@"乐视TV"
               ,@"PPTV"
               ,@"熊猫TV"
               ];
    
    XLPickerView *picker = [[XLPickerView alloc] initWithFrame:CGRectMake(0, 0, KSCRWIDTH, 80)];
    picker.delegate = self;
    picker.dataSource = self;
    [self.view addSubview:picker];
    
    [picker reloadData];
    //[picker selectItem:0];
}


- (void)xlPickerView:(XLPickerView *)picker didSelectItemAtIndex:(NSInteger)index{
    DLog(@"[Picker select:]atIdx:%ld", index);
}

- (NSInteger)numberOfItemsInPicker:(XLPickerView *)xlPickerView{
    return titles.count;
}
- (NSString *)titleForItemAtIndex:(NSInteger)index xlPickerView:(XLPickerView *)picker{
    return titles[index%titles.count];
}

- (CGFloat)heightForXLPickerView:(XLPickerView *)picker{
    return 44;  // 默认也是44
}

···

