# SwiftUI Project

Simple Cursor AI + XCode sync using [sync_xcodeproj.rb](https://github.com/CocoaPods/Xcodeproj)


> **⚠️ IMPORTANT NOTICE**
> 
> This is just a playground. It has issues and its for demo purposes only.


## Configure

Change the project path in the sync_xcodeproj.rb file to your path

```
project_path = File.join(Dir.pwd, 'todoapp2.xcodeproj')
```

```
    next if item == '.' || item == '..' || item == 'todoapp2.xcodeproj'
```

## Sync to XCode


**Build**: Compiles the Xcode project.
   - Run with: `Cmd+Shift+B` or `Tasks: Run Build Task`


![picture 0](https://res.cloudinary.com/ddbi0suli/image/upload/v1725896132/skillpark/7d9b0a409d19bbc4ca0787a45252af4d45e21836743ac40750c013dd0be792a9.png)  
