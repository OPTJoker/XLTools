# XLTools
个人工具库之
个人工具库

<h2>XLPicker</h2>
 <img src="https://github.com/OPTJoker/XLTools/blob/master/XLPicker_gif.gif" width = "300" height = "450" alt="XLPicker效果图" align=center />
```objc 
// 根UITableView用法一样，首先遵循XLPickerDataSource 和XLPickerDelegate(如果不需要处理点击响应，也可不加) 
// 必选 @protocol XLPickerDataSource

(NSInteger)numberOfItemsInPicker:(XLPickerView *)xlPickerView;
(NSString *)titleForItemAtIndex:(NSInteger)index xlPickerView:(XLPickerView *)picker;
// 可选 @protocol XLPickerDelegate @optional

(CGFloat)heightForXLPickerView:(XLPickerView *)picker;
(void)xlPickerView:(XLPickerView *)picker didSelectItemAtIndex:(NSInteger)index;
(void)xlPickerView:(XLPickerView *)picker didUnSelectItemAtIndex:(NSInteger)index; 
```
使用示例

```objc

(void)viewDidLoad { 
	[super viewDidLoad]; 
	self.navigationItem.title = @"Debug";

	titles = @[ @"奥斯卡电影" 
				,@"美团电影" 
				,@"猫眼电影" 
				,@"百度视频" 
				,@"乐视TV" 
				,@"PPTV"
				,@"熊猫TV" 
				];

	XLPickerView *picker = [[XLPickerView alloc] initWithFrame:CGRectMake(0, 0, KSCRWIDTH, 	80)]; 
	picker.delegate = self; 
	picker.dataSource = self;

	[self.view addSubview:picker];

	[picker reloadData]; 
	//[picker selectItem:0]; 
}

-(void)xlPickerView:(XLPickerView *)picker didSelectItemAtIndex:(NSInteger)index{ 
	DLog(@"[Picker select:]atIdx:%ld", index); 
}

-(NSInteger)numberOfItemsInPicker:(XLPickerView *)xlPickerView{ 
	return titles.count; 
}

-(NSString *)titleForItemAtIndex:(NSInteger)index xlPickerView:(XLPickerView *)picker{ 
	return titles[index%titles.count]; 
}

-(CGFloat)heightForXLPickerView:(XLPickerView *)picker{ 
	return 44; // 默认是44 
}

```
