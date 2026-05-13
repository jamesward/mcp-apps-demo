package com.jamesward.springaimcpdemo;

import gg.jte.generated.precompiled.StaticTemplates;
import org.springframework.ai.mcp.annotation.McpResource;
import org.springframework.ai.mcp.annotation.McpTool;
import org.springframework.ai.mcp.annotation.context.MetaProvider;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;
import org.webjars.WebJarVersionLocator;

import java.io.IOException;
import java.nio.charset.Charset;
import java.util.Map;
import java.util.Objects;

@SpringBootApplication
public class Application {
    static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

@Component
class EC2App {

    private final StaticTemplates staticTemplates = new StaticTemplates();

    private final String appExtJs;

    public EC2App() throws IOException {
        WebJarVersionLocator webJarVersionLocator = new WebJarVersionLocator();
        Resource appExt = new ClassPathResource(Objects.requireNonNull(
                webJarVersionLocator.fullPath("modelcontextprotocol__ext-apps", "dist/src/app-with-deps.js")));
        appExtJs = appExt.getContentAsString(Charset.defaultCharset());
    }

    @McpResource(
            name = "EC2 Instances App Resource",
            uri = "ui://ec2/ec2-instances.html",
            mimeType = "text/html;profile=mcp-app"
    )
    public String getEC2InstancesResource() {
        return staticTemplates.ec2Instances(appExtJs).render();
    }

    @McpTool(
            title = "List EC2 Instances",
            name = "listEC2Instances",
            description = "Opens a rich AWS-console-style table of the user's EC2 instances with filter and sort.",
            metaProvider = EC2MetaProvider.class)
    public String listEC2Instances() {
        return "Opening the EC2 instances console.";
    }

    public static final class EC2MetaProvider implements MetaProvider {
        @Override
        public Map<String, Object> getMeta() {
            return Map.of("ui",
                    Map.of(
                            "resourceUri", "ui://ec2/ec2-instances.html"));
        }
    }
}
