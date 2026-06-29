package testimpl

import (
	"context"
	"encoding/json"
	"fmt"
	"net/url"
	"regexp"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ecs"
	"github.com/aws/aws-sdk-go-v2/service/iam"
	"github.com/aws/aws-sdk-go-v2/service/sts"
	"github.com/gruntwork-io/terratest/modules/terraform"
	testTypes "github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestComposableComplete(t *testing.T, ctx testTypes.TestContext) {
	// Get AWS ECS client to verify task definition
	ecsClient := GetAWSECSClient(t)
	iamClient := GetAWSIAMClient(t)

	// Get outputs from Terraform
	taskDefinitionArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "task_definition_arn")
	taskDefinitionFamily := terraform.Output(t, ctx.TerratestTerraformOptions(), "task_definition_family")
	taskDefinitionRevision := terraform.Output(t, ctx.TerratestTerraformOptions(), "task_definition_revision")
	taskExecutionRoleArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "task_execution_role_arn")
	taskRoleArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "task_role_arn")
	ecsTaskFamilyName := terraform.Output(t, ctx.TerratestTerraformOptions(), "ecs_task_family_name")
	logGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "log_group_name")
	taskDef := fmt.Sprintf("%s:%s", taskDefinitionFamily, taskDefinitionRevision)
	print("taskDef0", taskDef)

	t.Run("TestTaskDefinitionArn", func(t *testing.T) {
		testTaskDefinitionArn(t, taskDefinitionArn)
	})

	t.Run("TestTaskDefinitionFamily", func(t *testing.T) {
		testTaskDefinitionFamily(t, taskDefinitionFamily, ecsTaskFamilyName)
	})

	t.Run("TestTaskDefinitionRevision", func(t *testing.T) {
		testTaskDefinitionRevision(t, taskDefinitionRevision)
	})

	t.Run("TestTaskExecutionRoleArn", func(t *testing.T) {
		testTaskExecutionRoleArn(t, taskExecutionRoleArn)
	})

	t.Run("TestTaskRoleArn", func(t *testing.T) {
		testTaskRoleArn(t, taskRoleArn)
	})

	t.Run("TestLogGroupName", func(t *testing.T) {
		testLogGroupName(t, logGroupName)
	})

	t.Run("TestTaskDefinitionExists", func(t *testing.T) {
		testTaskDefinitionExists(t, ecsClient, taskDefinitionArn)
	})

	t.Run("TestMultipleContainers", func(t *testing.T) {
		testMultipleContainers(t, ecsClient, taskDefinitionArn)
	})

	t.Run("TestTaskRolePolicies", func(t *testing.T) {
		testTaskRolePolicies(t, iamClient, taskRoleArn)
	})

	t.Run("TestMountPoints", func(t *testing.T) {
		testMountPoints(t, ecsClient, taskDefinitionArn)
	})

	t.Run("TestReadOnlyRootFilesystem", func(t *testing.T) {
		testReadOnlyRootFilesystem(t, ecsClient, taskDefinitionArn)
	})

	t.Run("TestLinuxParametersTmpfs", func(t *testing.T) {
		testLinuxParametersTmpfs(t, ecsClient, taskDefinitionArn)
	})
}

func GetAWSSTSClient(t *testing.T) *sts.Client {
	awsSTSClient := sts.NewFromConfig(GetAWSConfig(t))
	return awsSTSClient
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}

func GetAWSECSClient(t *testing.T) *ecs.Client {
	awsECSClient := ecs.NewFromConfig(GetAWSConfig(t))
	return awsECSClient
}

func GetAWSIAMClient(t *testing.T) *iam.Client {
	awsIAMClient := iam.NewFromConfig(GetAWSConfig(t))
	return awsIAMClient
}

func testTaskDefinitionArn(t *testing.T, taskDefinitionArn string) {
	assert.NotEmpty(t, taskDefinitionArn, "Task definition ARN should not be empty")
	print("taskDefinitionArn: ", taskDefinitionArn, "\n")
	// Verify it's a valid ARN format for ECS task definition
	matched, _ := regexp.MatchString(`^arn:aws:ecs:[^:]+:\d+:task-definition/[^:]+:\d+$`, taskDefinitionArn)
	assert.True(t, matched, "Task definition ARN should match ECS task definition ARN format")
}

func testTaskDefinitionFamily(t *testing.T, taskDefinitionFamily, ecsTaskFamilyName string) {
	assert.NotEmpty(t, taskDefinitionFamily, "Task definition family should not be empty")
	assert.Equal(t, ecsTaskFamilyName, taskDefinitionFamily, "Task definition family should match ECS task family name")
}

func testTaskDefinitionRevision(t *testing.T, taskDefinitionRevision string) {
	assert.NotEmpty(t, taskDefinitionRevision, "Task definition revision should not be empty")
	// Verify it's a number
	matched, _ := regexp.MatchString(`^\d+$`, taskDefinitionRevision)
	assert.True(t, matched, "Task definition revision should be a number")
}

func testTaskExecutionRoleArn(t *testing.T, taskExecutionRoleArn string) {
	assert.NotEmpty(t, taskExecutionRoleArn, "Task execution role ARN should not be empty")
	// Verify it's a valid IAM role ARN format
	matched, _ := regexp.MatchString(`^arn:aws:iam::\d+:role/[^:]+$`, taskExecutionRoleArn)
	assert.True(t, matched, "Task execution role ARN should match IAM role ARN format")
}

func testTaskRoleArn(t *testing.T, taskRoleArn string) {
	assert.NotEmpty(t, taskRoleArn, "Task role ARN should not be empty")
	// Verify it's a valid IAM role ARN format
	matched, _ := regexp.MatchString(`^arn:aws:iam::\d+:role/[^:]+$`, taskRoleArn)
	assert.True(t, matched, "Task role ARN should match IAM role ARN format")
}

func testLogGroupName(t *testing.T, logGroupName string) {
	assert.NotEmpty(t, logGroupName, "Log group name should not be empty")
	// Verify it starts with /ecs/
	assert.Contains(t, logGroupName, "/ecs/", "Log group name should contain '/ecs/'")
}

func testTaskDefinitionExists(t *testing.T, ecsClient *ecs.Client, taskDefinitionArn string) {
	// Extract task definition name from ARN
	// ARN format: arn:aws:ecs:region:account:task-definition/family:revision
	parts := regexp.MustCompile(`^arn:aws:ecs:[^:]+:\d+:task-definition/(.+)$`).FindStringSubmatch(taskDefinitionArn)
	require.Len(t, parts, 2, "Task definition ARN should contain task definition name")

	// Describe the task definition to verify it exists
	describeInput := &ecs.DescribeTaskDefinitionInput{
		TaskDefinition: aws.String(parts[1]),
	}
	resp, err := ecsClient.DescribeTaskDefinition(context.TODO(), describeInput)
	require.NoError(t, err, "Failed to describe task definition")
	assert.NotNil(t, resp.TaskDefinition, "Task definition should exist")
}

func testMultipleContainers(t *testing.T, ecsClient *ecs.Client, taskDefinitionArn string) {
	// Extract task definition name from ARN
	parts := regexp.MustCompile(`^arn:aws:ecs:[^:]+:\d+:task-definition/(.+)$`).FindStringSubmatch(taskDefinitionArn)
	require.Len(t, parts, 2, "Task definition ARN should contain task definition name")

	// Describe the task definition
	describeInput := &ecs.DescribeTaskDefinitionInput{
		TaskDefinition: aws.String(parts[1]),
	}
	resp, err := ecsClient.DescribeTaskDefinition(context.TODO(), describeInput)
	require.NoError(t, err, "Failed to describe task definition")

	// Verify multiple containers are defined
	containerDefs := resp.TaskDefinition.ContainerDefinitions
	assert.Greater(t, len(containerDefs), 1, "Task definition should have multiple containers")

	// Check healthcheck for nginx container
	nginxFound := false
	for _, container := range containerDefs {
		if *container.Name == "nginx" {
			nginxFound = true
			assert.NotNil(t, container.HealthCheck, "Nginx container should have a healthcheck")
			if container.HealthCheck != nil {
				assert.Equal(t, []string{"CMD-SHELL", "curl -f http://localhost/ || exit 1"}, container.HealthCheck.Command, "Healthcheck command should match")
				assert.Equal(t, int32(30), *container.HealthCheck.Interval, "Healthcheck interval should be 30")
				assert.Equal(t, int32(15), *container.HealthCheck.Timeout, "Healthcheck timeout should be 15")
				assert.Equal(t, int32(1), *container.HealthCheck.Retries, "Healthcheck retries should be 1")
				assert.Equal(t, int32(30), *container.HealthCheck.StartPeriod, "Healthcheck startPeriod should be 30")
			}
			break
		}
	}
	assert.True(t, nginxFound, "Nginx container should be present")
}

func testTaskRolePolicies(t *testing.T, iamClient *iam.Client, taskRoleArn string) {
	// Extract role name from ARN
	// ARN format: arn:aws:iam::account:role/role-name
	parts := regexp.MustCompile(`^arn:aws:iam::\d+:role/(.+)$`).FindStringSubmatch(taskRoleArn)
	require.Len(t, parts, 2, "Task role ARN should contain role name")
	roleName := parts[1]

	// List attached policies
	listAttachedPoliciesInput := &iam.ListAttachedRolePoliciesInput{
		RoleName: &roleName,
	}
	attachedPolicies, err := iamClient.ListAttachedRolePolicies(context.TODO(), listAttachedPoliciesInput)
	require.NoError(t, err, "Failed to list attached policies for task role")

	// Check for CloudWatch permissions
	hasCloudWatchPolicy := false
	hasSSMPolicy := false
	hasAppConfigPolicy := false
	hasS3Policy := false

	for _, policy := range attachedPolicies.AttachedPolicies {
		policyArn := *policy.PolicyArn
		policyName := *policy.PolicyName

		// Get policy document
		getPolicyInput := &iam.GetPolicyInput{
			PolicyArn: &policyArn,
		}
		policyResp, err := iamClient.GetPolicy(context.TODO(), getPolicyInput)
		require.NoError(t, err, "Failed to get policy")

		policyVersion := *policyResp.Policy.DefaultVersionId
		getPolicyVersionInput := &iam.GetPolicyVersionInput{
			PolicyArn: &policyArn,
			VersionId: &policyVersion,
		}
		policyVersionResp, err := iamClient.GetPolicyVersion(context.TODO(), getPolicyVersionInput)
		require.NoError(t, err, "Failed to get policy version")

		policyDocument := *policyVersionResp.PolicyVersion.Document

		// Parse the policy document
		var policyDoc map[string]interface{}
		unescaped, err := url.QueryUnescape(policyDocument)
		require.NoError(t, err, "Failed to unescape policy document")
		err = json.Unmarshal([]byte(unescaped), &policyDoc)
		require.NoError(t, err, "Failed to parse policy document")

		statements, ok := policyDoc["Statement"].([]interface{})
		require.True(t, ok, "Policy document should have Statement array")

		// Check if it's the CloudWatch policy
		if strings.Contains(policyName, "CloudWatchLogs") {
			hasCloudWatchPolicy = true
			// Check for logs:CreateLogGroup action
			found := false
			for _, stmt := range statements {
				stmtMap, ok := stmt.(map[string]interface{})
				if !ok {
					continue
				}
				action := stmtMap["Action"]
				if actionStr, ok := action.(string); ok {
					if actionStr == "logs:CreateLogGroup" {
						found = true
						break
					}
				} else if actionArr, ok := action.([]interface{}); ok {
					for _, a := range actionArr {
						if a == "logs:CreateLogGroup" {
							found = true
							break
						}
					}
				}
				if found {
					break
				}
			}
			assert.True(t, found, "CloudWatch policy should contain logs:CreateLogGroup action")
		}

		// Check if it's the SSM policy
		if strings.Contains(policyName, "SSMSessionManager") {
			hasSSMPolicy = true
			// Check for SSM actions
			ssmActions := []string{"ssmmessages:*", "ssm:UpdateInstanceInformation", "ssm:StartSession", "ssm:DescribeSessions", "ssm:GetConnectionStatus"}
			for _, expectedAction := range ssmActions {
				found := false
				for _, stmt := range statements {
					stmtMap, ok := stmt.(map[string]interface{})
					if !ok {
						continue
					}
					action := stmtMap["Action"]
					if actionStr, ok := action.(string); ok {
						if actionStr == expectedAction {
							found = true
							break
						}
					} else if actionArr, ok := action.([]interface{}); ok {
						for _, a := range actionArr {
							if a == expectedAction {
								found = true
								break
							}
						}
					}
					if found {
						break
					}
				}
				assert.True(t, found, "SSM policy should contain %s action", expectedAction)
			}
		}

		// Check if it's the AppConfig policy
		if strings.Contains(policyName, "AppConfig") {
			hasAppConfigPolicy = true
		}

		// Check if it's the S3 policy
		if strings.Contains(policyName, "S3Access") {
			hasS3Policy = true
		}
	}

	// Assert that the policies are present
	assert.True(t, hasCloudWatchPolicy, "Task role should have CloudWatch Logs policy attached")
	assert.True(t, hasSSMPolicy, "Task role should have SSM Session Manager policy attached")
	assert.False(t, hasAppConfigPolicy, "Task role should not have AppConfig policy attached when enable_ecs_task_appconfig_permissions is false")
	assert.False(t, hasS3Policy, "Task role should not have S3 policy attached when enable_ecs_task_s3_permissions is false")
}

// TestComposableCustomPolicies verifies that when task_role_policy_statements is provided,
// only those customer managed policies are attached to the task role and no auto-generated
// policies (CloudWatch, SSM Session Manager, AppConfig, S3) are present.
func TestComposableCustomPolicies(t *testing.T, ctx testTypes.TestContext) {
	iamClient := GetAWSIAMClient(t)
	ecsClient := GetAWSECSClient(t)

	taskDefinitionArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "task_definition_arn")
	taskDefinitionFamily := terraform.Output(t, ctx.TerratestTerraformOptions(), "task_definition_family")
	taskDefinitionRevision := terraform.Output(t, ctx.TerratestTerraformOptions(), "task_definition_revision")
	taskExecutionRoleArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "task_execution_role_arn")
	taskRoleArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "task_role_arn")
	ecsTaskFamilyName := terraform.Output(t, ctx.TerratestTerraformOptions(), "ecs_task_family_name")
	logGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "log_group_name")

	t.Run("TestTaskDefinitionArn", func(t *testing.T) {
		testTaskDefinitionArn(t, taskDefinitionArn)
	})

	t.Run("TestTaskDefinitionFamily", func(t *testing.T) {
		testTaskDefinitionFamily(t, taskDefinitionFamily, ecsTaskFamilyName)
	})

	t.Run("TestTaskDefinitionRevision", func(t *testing.T) {
		testTaskDefinitionRevision(t, taskDefinitionRevision)
	})

	t.Run("TestTaskExecutionRoleArn", func(t *testing.T) {
		testTaskExecutionRoleArn(t, taskExecutionRoleArn)
	})

	t.Run("TestTaskRoleArn", func(t *testing.T) {
		testTaskRoleArn(t, taskRoleArn)
	})

	t.Run("TestLogGroupName", func(t *testing.T) {
		testLogGroupName(t, logGroupName)
	})

	t.Run("TestTaskDefinitionExists", func(t *testing.T) {
		testTaskDefinitionExists(t, ecsClient, taskDefinitionArn)
	})

	t.Run("TestCustomTaskRolePolicies", func(t *testing.T) {
		testCustomTaskRolePolicies(t, iamClient, taskRoleArn)
	})
}

// testCustomTaskRolePolicies verifies that exactly the customer-supplied policy statements
// are attached to the task role and that no auto-generated policies exist.
func testCustomTaskRolePolicies(t *testing.T, iamClient *iam.Client, taskRoleArn string) {
	parts := regexp.MustCompile(`^arn:aws:iam::\d+:role/(.+)$`).FindStringSubmatch(taskRoleArn)
	require.Len(t, parts, 2, "Task role ARN should contain role name")
	roleName := parts[1]

	attachedPolicies, err := iamClient.ListAttachedRolePolicies(context.TODO(), &iam.ListAttachedRolePoliciesInput{
		RoleName: &roleName,
	})
	require.NoError(t, err, "Failed to list attached policies for task role")

	hasCustomS3Policy := false
	hasCustomSSMPolicy := false
	hasAutoGeneratedPolicy := false

	autoGeneratedPolicySuffixes := []string{
		"CloudWatchLogs",
		"SSMSessionManager",
		"AppConfig",
		"S3Access",
		"KMSDecrypt",
		"EFSMount",
		"EFSKMS",
		"EFSS3",
		"ManagedPolicyAttachment",
	}

	for _, policy := range attachedPolicies.AttachedPolicies {
		policyName := *policy.PolicyName

		if strings.Contains(policyName, "CustomS3ReadAccess") {
			hasCustomS3Policy = true
		}
		if strings.Contains(policyName, "CustomSSMParamRead") {
			hasCustomSSMPolicy = true
		}

		for _, suffix := range autoGeneratedPolicySuffixes {
			if strings.Contains(policyName, suffix) {
				hasAutoGeneratedPolicy = true
				t.Errorf("Task role should not have auto-generated policy '%s' when task_role_policy_statements is set", policyName)
			}
		}
	}

	assert.True(t, hasCustomS3Policy, "Task role should have custom S3 policy (CustomS3ReadAccess) attached")
	assert.True(t, hasCustomSSMPolicy, "Task role should have custom SSM policy (CustomSSMParamRead) attached")
	assert.False(t, hasAutoGeneratedPolicy, "Task role should not have any auto-generated policies when task_role_policy_statements is provided")
}

func testMountPoints(t *testing.T, ecsClient *ecs.Client, taskDefinitionArn string) {
	// Extract task definition name from ARN
	parts := regexp.MustCompile(`^arn:aws:ecs:[^:]+:\d+:task-definition/(.+)$`).FindStringSubmatch(taskDefinitionArn)
	require.Len(t, parts, 2, "Task definition ARN should contain task definition name")

	// Describe the task definition
	describeInput := &ecs.DescribeTaskDefinitionInput{
		TaskDefinition: aws.String(parts[1]),
	}
	resp, err := ecsClient.DescribeTaskDefinition(context.TODO(), describeInput)
	require.NoError(t, err, "Failed to describe task definition")

	containerDefs := resp.TaskDefinition.ContainerDefinitions

	// Check if at least one container has mount points
	hasMountPoints := false
	for _, container := range containerDefs {
		if len(container.MountPoints) > 0 {
			hasMountPoints = true
			// Verify each mount point has required fields
			for _, mp := range container.MountPoints {
				assert.NotEmpty(t, *mp.SourceVolume, "Source volume should not be empty")
				assert.NotEmpty(t, *mp.ContainerPath, "Container path should not be empty")
				// Optionally check readOnly if applicable
			}
			break
		}
	}
	assert.True(t, hasMountPoints, "At least one container should have mount points defined")
}

func testReadOnlyRootFilesystem(t *testing.T, ecsClient *ecs.Client, taskDefinitionArn string) {
	parts := regexp.MustCompile(`^arn:aws:ecs:[^:]+:\d+:task-definition/(.+)$`).FindStringSubmatch(taskDefinitionArn)
	require.Len(t, parts, 2, "Task definition ARN should contain task definition name")

	resp, err := ecsClient.DescribeTaskDefinition(context.TODO(), &ecs.DescribeTaskDefinitionInput{
		TaskDefinition: aws.String(parts[1]),
	})
	require.NoError(t, err, "Failed to describe task definition")

	nginxFound := false
	sidecarFound := false
	for _, container := range resp.TaskDefinition.ContainerDefinitions {
		switch *container.Name {
		case "nginx":
			nginxFound = true
			require.NotNil(t, container.ReadonlyRootFilesystem, "Nginx container should have readOnlyRootFilesystem set")
			assert.True(t, *container.ReadonlyRootFilesystem, "Nginx container readOnlyRootFilesystem should be true")
		case "sidecar":
			sidecarFound = true
			assert.Nil(t, container.ReadonlyRootFilesystem, "Sidecar container should not have readOnlyRootFilesystem set")
		}
	}

	assert.True(t, nginxFound, "Nginx container should be present")
	assert.True(t, sidecarFound, "Sidecar container should be present")
}

func testLinuxParametersTmpfs(t *testing.T, ecsClient *ecs.Client, taskDefinitionArn string) {
	parts := regexp.MustCompile(`^arn:aws:ecs:[^:]+:\d+:task-definition/(.+)$`).FindStringSubmatch(taskDefinitionArn)
	require.Len(t, parts, 2, "Task definition ARN should contain task definition name")

	resp, err := ecsClient.DescribeTaskDefinition(context.TODO(), &ecs.DescribeTaskDefinitionInput{
		TaskDefinition: aws.String(parts[1]),
	})
	require.NoError(t, err, "Failed to describe task definition")

	nginxFound := false
	sidecarFound := false
	for _, container := range resp.TaskDefinition.ContainerDefinitions {
		switch *container.Name {
		case "nginx":
			nginxFound = true
			require.NotNil(t, container.LinuxParameters, "Nginx container should have linuxParameters set")
			require.Len(t, container.LinuxParameters.Tmpfs, 1, "Nginx container should have one tmpfs mount")

			tmpfs := container.LinuxParameters.Tmpfs[0]
			require.NotNil(t, tmpfs.ContainerPath, "Tmpfs container path should be set")
			assert.Equal(t, "/tmp", *tmpfs.ContainerPath, "Tmpfs container path should match")
			assert.EqualValues(t, 64, tmpfs.Size, "Tmpfs size should match")
			assert.ElementsMatch(t, []string{"defaults", "rw", "mode=1777"}, tmpfs.MountOptions, "Tmpfs mount options should match")
		case "sidecar":
			sidecarFound = true
			assert.Nil(t, container.LinuxParameters, "Sidecar container should not have linuxParameters set")
		}
	}

	assert.True(t, nginxFound, "Nginx container should be present")
	assert.True(t, sidecarFound, "Sidecar container should be present")
}
