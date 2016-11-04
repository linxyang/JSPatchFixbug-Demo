
// 在这里写一些bug修复代码  文档:https://github.com/bang590/JSPatch/blob/master/README-CN.md

// 修改控制器中viewDidLoad方法
require('UIView,UIColor,UITableView,UITableViewStyle')
defineClass('MyBeautyPlanDailyViewController',{
            
            // 1、改变导航栏的标题
            viewDidLoad:function() {
                self.super().viewDidLoad();
                self.setTitle("JSPatch修改的标题");
                _tableView = UITableView.alloc().initWithFrame_style(self.view().frame(), 0);
                _tableView.setSeparatorStyle(0);//枚举变量直接用数值
                _tableView.setDataSource(self);
                _tableView.setDelegate(self);
                self.view().addSubview(_tableView);
            
            }       
            
            
});

// 修改cell中的setModel方法
require('NSMutableParagraphStyle,NSAttributedString,NSURL,UIImage,UIFont');
defineClass('BeautyDailyTableViewCell', {
            setModel: function(model) {
            _model = model;
            // 改日期为自己写的，不用后台返回的
            self.timeLabel().setText("JSPatch日期");// model.time()
            
            var paragraphStyle = NSMutableParagraphStyle.alloc().init();
            paragraphStyle.setLineSpacing(4); //调整行间距
            var attributes = {
            "NSFont":self.contentLabel().font(),//NSFontAttributeName-->"NSFont"
            "NSParagraphStyle": paragraphStyle// NSParagraphStyleAttributeName-->"NSParagraphStyle"
            };
            var attrString = NSAttributedString.alloc().initWithString_attributes(model.content(), attributes);
            self.contentLabel().setAttributedText(attrString);
            
            if (model.imgUrl()=="") {
            self.recordImageView().setHidden(YES);
            self.recordImageView().mas__remakeConstraints(block('MASConstraintMaker*', function(make) {
                                                         make.top().equalTo()(self.contentLabel().mas__bottom()).offset()(10);//mas_bottom()-->mas__bottom()要多加一个下划线
                                                         make.centerX().equalTo()(self.contentLabel());
                                                         make.height().width().equalTo()(0);
                                                         }));
            } else {
            self.recordImageView().setHidden(NO);
            self.recordImageView().setImageWithURL_placeholderImage(NSURL.URLWithString(model.imgUrl()), UIImage.imageNamed("point"));
            self.recordImageView().mas__remakeConstraints(block('MASConstraintMaker*', function(make) {
                                                         make.top().equalTo()(self.contentLabel().mas__bottom()).offset()(10);
                                                         make.centerX().equalTo()(self.contentLabel());
                                                         make.height().width().equalTo()(100);
                                                         }));
            }
            self.lineView().setHidden(model.isLast() ? YES : NO);
            
            },
});


/*
require('UIView, UIColor, UILabel')
defineClass('AppDelegate', {
            // replace the -genView method
            genView: function() {
            var view = self.ORIGgenView();
            view.setBackgroundColor(UIColor.greenColor())
            var label = UILabel.alloc().initWithFrame(view.frame());
            label.setText("JSPatch");
            label.setTextAlignment(1);
            view.addSubview(label);
            return view;
            }
            });
*/


/**** 基本使用方法 ***/

/*
 // 调用require引入要使用的OC类
 require('UIView, UIColor, UISlider, NSIndexPath')
 
 // 调用类方法
 var redColor = UIColor.redColor();
 
 // 调用实例方法
 var view = UIView.alloc().init();
 view.setNeedsLayout();
 
 // set proerty
 view.setBackgroundColor(redColor);
 
 // get property
 var bgColor = view.backgroundColor();
 
 // 多参数方法名用'_'隔开：
 // OC：NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
 var indexPath = NSIndexPath.indexPathForRow_inSection(0, 1);
 
 // 方法名包含下划线'_'，js用双下划线表示
 // OC: [JPObject _privateMethod];
 JPObject.__privateMethod()
 
 // 如果要把 `NSArray` / `NSString` / `NSDictionary` 转为对应的 JS 类型，使用 `.toJS()` 接口.
 var arr = require('NSMutableArray').alloc().init()
 arr.addObject("JS")
 jsArr = arr.toJS()
 console.log(jsArr.push("Patch").join(''))  //output: JSPatch
 
 // 在JS用字典的方式表示 CGRect / CGSize / CGPoint / NSRange
 var view = UIView.alloc().initWithFrame({x:20, y:20, width:100, height:100});
 var x = view.bounds().x;
 
 // block 从 JavaScript 传入 Objective-C 时，需要写上每个参数的类型。
 // OC Method: + (void)request:(void(^)(NSString *content, BOOL success))callback
 require('JPObject').request(block("NSString *, BOOL", function(ctn, succ) {
 if (succ) log(ctn)
 }));
 
 // GCD
 dispatch_after(function(1.0, function(){
 // do something
 }))
 dispatch_async_main(function(){
 // do something
 })
 */

