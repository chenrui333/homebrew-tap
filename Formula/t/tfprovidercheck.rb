class Tfprovidercheck < Formula
  desc "CLI to prevent malicious Terraform Providers from being executed"
  homepage "https://github.com/suzuki-shunsuke/tfprovidercheck"
  url "https://github.com/suzuki-shunsuke/tfprovidercheck/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "d6330db7e927dcd89281c2ff8b3545914489a5a09b59e73def8d6525ec8d9596"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfprovidercheck.git", branch: "main"

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/tfprovidercheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfprovidercheck -version")

    (testpath/"test.tf").write <<~HCL
      terraform {
        required_version = ">= 1.0"

        required_providers {
          aws = {
            source = "hashicorp/aws"
            version = "~> 5"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }
    HCL

    # Only google provider and azurerm provider are allowed
    (testpath/".tfprovidercheck.yaml").write <<~YAML
    providers:
      - name: registry.terraform.io/hashicorp/google
        version: ">= 4.0.0"
      - name: registry.terraform.io/hashicorp/azurerm
    YAML

    system "tofu", "init"
    output = shell_output("tofu version -json | #{bin}/tfprovidercheck 2>&1", 1)
    assert_match "Terraform Provider is disallowed", output
  end
end
