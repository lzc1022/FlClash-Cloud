// 定义一个泛型函数类型，返回值为T类型
typedef Success<T> = Function(T data);
// 定义一个函数类型，返回值为int类型和String类型
typedef Fail = Function(int code, String msg);
// 定义一个泛型函数类型，返回值为T类型和C类型
typedef ParamDoubleCallback<T, C> = Function(T t, C c);
// 定义一个泛型函数类型，返回值为T类型
typedef ParamCallback<T> = Function(T t);
