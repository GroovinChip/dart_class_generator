# run using `powershell .\zip_windows.ps1`
$compress = @{
    LiteralPath = "C:\Users\ReubenT\FlutterProjects\experiments\dart_class_generator\build\windows\x64\Debug\Runner\"
    CompressionLevel = "Fastest"
    DestinationPath = "C:\Users\ReubenT\FlutterProjects\experiments\dart_class_generator\build\windows\x64\Debug\Runner\dart_class_generator_windows.zip"
}
#Copy-Item Copy-Item -Path "C:\Users\ReubenT\FlutterProjects\experiments\dart_class_generator\build\windows\x64\Debug\Runner\" -Force -PassThru | Get-ChildItem |
Compress-Archive @compress -Update
Invoke-Item C:\Users\ReubenT\FlutterProjects\experiments\dart_class_generator\build\windows\x64\Debug\Runner\