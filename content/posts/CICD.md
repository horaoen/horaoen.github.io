+++
title = "CICD"
date = "2025-01-20"
+++

# Jenkins
## java jar包启动
```
pipeline {
    agent any
    environment {
        MAVEN_HOME = '/Users/horaoen/dev/apache-maven-3.8.8'
        PATH = "${MAVEN_HOME}/bin:${env.PATH}"
        JAVA_HOME = '/Users/horaoen/.jenv/versions/oracle64-1.8.0.401'
    }
    stages {
        stage('build and run') {
            steps {
                script {
                    // 停止在端口9001上运行的服务
                    script {
                        def pid = sh(script: "lsof -t -i:9001", returnStatus: true)
                        if (pid != 1) {
                            sh "kill -9 ${pid}"
                            echo "Stopped existing service on port 9001 with PID ${pid}"
                        } else {
                            echo "No process found on port 9001"
                        }
                    }
                    // 进入指定目录
                    dir('chinatower_cyy_service') {
                        // 执行 Maven 构建命令
                        sh 'mvn clean package --settings /Users/horaoen/code/cntower.xml -Dmaven.repo.local=/Users/horaoen/.m2/repository'
                        // 重新启动服务
                        sh 'nohup java -jar target/chinatower_cyy_service-1.0.0-SNAPSHOT.jar --spring.profiles=local --server.port=9001 >> ~/logs/service.log &'
                    }
                }
            }
        }
    }
}
```

