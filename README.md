# JFAnimation

动画节奏控制属性timingFunction：
CA_EXTERN NSString * const kCAMediaTimingFunctionLinear //线性匀速
CA_EXTERN NSString * const kCAMediaTimingFunctionEaseIn //慢进快出
CA_EXTERN NSString * const kCAMediaTimingFunctionEaseOut //快进慢出
CA_EXTERN NSString * const kCAMediaTimingFunctionEaseInEaseOut  //慢进慢出
CA_EXTERN NSString * const kCAMediaTimingFunctionDefault  //默认


当前对象在非活动时间段的行为fillMode：
CA_EXTERN NSString * const kCAFillModeForwards //动画结束后，保持着动画最后的状态
CA_EXTERN NSString * const kCAFillModeBackwards //动画开始前，到达准备状态
CA_EXTERN NSString * const kCAFillModeBoth  //动画开始前，进入准备状态，结束后，保持最后的状态
CA_EXTERN NSString * const kCAFillModeRemoved  //动画完成后，移除，默认模式

与transform和用的属性valueFunction：
我们做一个旋转动画，我们会使用transform.rotation作为keyPath，但是它并不真实存在，这个属性就是因此而存在的，系统提供给了如下方式：
CA_EXTERN NSString * const kCAValueFunctionRotateX
CA_EXTERN NSString * const kCAValueFunctionRotateY
CA_EXTERN NSString * const kCAValueFunctionRotateZ
CA_EXTERN NSString * const kCAValueFunctionScale
CA_EXTERN NSString * const kCAValueFunctionScaleX
CA_EXTERN NSString * const kCAValueFunctionScaleY
CA_EXTERN NSString * const kCAValueFunctionScaleZ
CA_EXTERN NSString * const kCAValueFunctionTranslate
CA_EXTERN NSString * const kCAValueFunctionTranslateX
CA_EXTERN NSString * const kCAValueFunctionTranslateY
CA_EXTERN NSString * const kCAValueFunctionTranslateZ

属性动画可以做动画的属性：
opacity 透明度
backgroundColor 背景颜色
cornerRadius 圆角
borderWidth 边框宽度
contents 内容
shadowColor 阴影颜色
shadowOffset 阴影偏移量
shadowOpacity 阴影透明度
shadowRadius 阴影圆角
...
rotation 旋转
transform.rotation.x
transform.rotation.y
transform.rotation.z
...
scale 缩放
transform.scale.x
transform.scale.y
transform.scale.z
...
translation 平移
transform.translation.x
transform.translation.y
transform.translation.z
...
position 位置
position.x
position.y
...
bounds 
bounds.size
bounds.size.width
bounds.size.height
bounds.origin
bounds.origin.x
bounds.origin.y


当存在多个关键帧时，我们把每一个关键帧看为一个点，那么这些点可以是离散的,也可以直线相连后进行插值计算,也可以使用圆滑的曲线将他们相连后进行插值计算，那么就应用到了这个属性，具体取值如下
CA_EXTERN NSString * const kCAAnimationLinear  默认值，关键帧之间直接直线相连进行插值计算
CA_EXTERN NSString * const kCAAnimationDiscrete 离散的，就是不进行插值计算，所有关键帧直接逐个进行显示
CA_EXTERN NSString * const kCAAnimationPaced  动画均匀进行，此时keyTimes和timingFunctions的设置失效
CA_EXTERN NSString * const kCAAnimationCubic  关键帧进行圆滑曲线相连后插值计算，对于曲线的形状还可以通过tensionValues，continuityValues，biasValues来进行调整自定义(http://en.wikipedia.org/wiki/Kochanek-Bartels_spline),这里的主要目的是使得运行的轨迹变得圆滑
CA_EXTERN NSString * const kCAAnimationCubicPaced  在kCAAnimationCubic的基础上使得动画运行变得均匀，就是系统时间内运动的距离相同，此时keyTimes以及timingFunctions也是无效的
