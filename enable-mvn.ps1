$mavenHome = "C:\Users\Admin\Desktop\tools\apache-maven-3.9.6"
$env:MAVEN_HOME = $mavenHome
$env:Path = "$mavenHome\bin;" + $env:Path
Write-Host "Maven 已启用！版本信息：" -ForegroundColor Green
mvn -v