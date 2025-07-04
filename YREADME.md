修改APP名称: rename setAppName --targets android,macos,windows,linux --value "红薯云"
修改包名: rename setBundleId --targets android,macos,windows,linux --value "com.guangda.cloud"

打包apk: flutter build apk --split-per-abi 


source ~/.bash_profile : 加载环境变量


加 build 号 +1