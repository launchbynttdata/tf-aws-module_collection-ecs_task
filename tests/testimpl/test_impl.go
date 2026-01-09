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

const (
	TestConfigsExamplesFolderDefault = "../../examples/simple"
	InfraTFVarFileNameDefault        = "test.tfvars"
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
