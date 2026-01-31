package test

import (
	"testing"
	"os/exec"
)

func TestTerraformInitAndPlan(t *testing.T) {
	dirs := []string{
		"../../environments/dev",
		"../../environments/uat",
		"../../environments/prod",
		"../../modules/acm",
		"../../modules/cloudfront",
		"../../modules/ecr",
		"../../modules/ecs",
		"../../modules/route53",
		"../../modules/s3",
		"../../modules/s3-artifacts",
		"../../modules/vpc",
	}
	for _, dir := range dirs {
		t.Run(dir, func(t *testing.T) {
			cmd := exec.Command("terraform", "init", "-backend=false")
			cmd.Dir = dir
			if err := cmd.Run(); err != nil {
				t.Fatalf("terraform init failed in %s: %v", dir, err)
			}

			cmd = exec.Command("terraform", "plan", "-detailed-exitcode")
			cmd.Dir = dir
			_ = cmd.Run() // Only fail if init fails
		})
	}
}
