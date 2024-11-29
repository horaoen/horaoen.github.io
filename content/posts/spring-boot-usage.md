+++
title = "springboot usage"
date = "2024-10-30"
+++

1. jdbcTemplate配置sql日志打印
```yaml
logging:
  level:
    org.springframework.jdbc.core.JdbcTemplate: DEBUG
```

2. 条件注入
```java
@SpringBootConfiguration
@ConditionalOnProperty(prefix = "ws", name = "enabled", havingValue = "true")
public class WebServiceConfig {
    @Value("${ws.wsdl_url}")
    private String wsdlUrl;

    @Bean(name = "webServiceClient")
    public Client client() {
        return JaxWsDynamicClientFactory.newInstance().createClient(wsdlUrl);
    }
}
```
```java
public class AccessControlServiceImpl implements AccessControlService, ApplicationContextAware {
    private Client webServiceClient;
    ....

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        if (applicationContext.containsBean("webServiceClient")) {
            this.webServiceClient = applicationContext.getBean("webServiceClient", Client.class);
        }
    }
}
```
