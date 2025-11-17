package testimpl

import (
	"context"
	"fmt"
	"regexp"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ecs"
	"github.com/aws/aws-sdk-go-v2/service/sts"
	"github.com/gruntwork-io/terratest/modules/terraform"
	testTypes "github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestComposableComplete(t *testing.T, ctx testTypes.TestContext) {
	// Get AWS ECS client to verify task definition
	ecsClient := GetAWSECSClient(t)

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
}
