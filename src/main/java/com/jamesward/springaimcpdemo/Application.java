package com.jamesward.springaimcpdemo;

import gg.jte.generated.precompiled.StaticTemplates;
import org.springframework.ai.mcp.annotation.McpResource;
import org.springframework.ai.mcp.annotation.McpTool;
import org.springframework.ai.mcp.annotation.McpToolParam;
import org.springframework.ai.mcp.annotation.context.MetaProvider;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;
import org.webjars.WebJarVersionLocator;

import java.io.IOException;
import java.nio.charset.Charset;
import java.util.List;
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

    @McpTool(
            title = "Create EC2 Instance",
            name = "createEC2Instance",
            description = "Creates a new EC2 instance with the given name, instance type, and availability zone.")
    public String createEC2Instance(
            @McpToolParam(required = true,
                    description = "Friendly name tag for the new instance.")
            String name,
            @McpToolParam(required = true,
                    description = "Instance type, e.g. t3.medium, m5.large.")
            String instanceType,
            @McpToolParam(required = true,
                    description = "Availability Zone, e.g. us-east-1a.")
            String availabilityZone) {

        String trimmedName = name == null ? "" : name.trim();
        if (trimmedName.isEmpty()) {
            return "Name is required.";
        }
        String type = instanceType == null || instanceType.isBlank() ? "t3.medium" : instanceType.trim();
        String az = availabilityZone == null || availabilityZone.isBlank() ? "us-east-1a" : availabilityZone.trim();
        return "Launched a new " + type + " instance in " + az
                + " with name \"" + trimmedName + "\". Current state: pending.";
    }

    @McpTool(
            title = "EC2 Instance Action",
            name = "ec2Action",
            description = "Performs a lifecycle action (start, stop, reboot, terminate) on one or more EC2 instances.")
    public String ec2Action(
            @McpToolParam(required = true,
                    description = "Lifecycle action to perform. One of: start, stop, reboot, terminate.")
            String action,
            @McpToolParam(required = true,
                    description = "List of EC2 instance IDs to apply the action to (e.g. i-0a1b2c3d4e5f60011).")
            List<String> instanceIds) {

        String normalized = action == null ? "" : action.trim().toLowerCase();
        if (!List.of("start", "stop", "reboot", "terminate").contains(normalized)) {
            return "Unsupported action '" + action + "'. Expected: start, stop, reboot, terminate.";
        }
        if (instanceIds == null || instanceIds.isEmpty()) {
            return "No instanceIds provided.";
        }

        String verb = switch (normalized) {
            case "start" -> "Starting";
            case "stop" -> "Stopping";
            case "reboot" -> "Rebooting";
            case "terminate" -> "Terminating";
            default -> "Acting on";
        };
        return verb + " " + instanceIds.size() + " instance(s): " + String.join(", ", instanceIds) + ".";
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
