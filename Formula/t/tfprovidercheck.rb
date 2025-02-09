# framework: urfave/cli
class Tfprovidercheck < Formula
  desc "CLI to prevent malicious Terraform Providers from being executed"
  homepage "https://github.com/suzuki-shunsuke/tfprovidercheck"
  url "https://github.com/suzuki-shunsuke/tfprovidercheck/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "d6330db7e927dcd89281c2ff8b3545914489a5a09b59e73def8d6525ec8d9596"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfprovidercheck.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72650c0a3942ea77cb2e53c9a0e5325c6877584a20a6aea65d62c8b80ef92af0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "051f192f67d72094957d0852acfe2e924f95295210e86af8c5c199abe7c3e382"
    sha256 cellar: :any_skip_relocation, ventura:       "3ae4842c5f069564e94a54cc9135439a0992d1dfa4b520105750eec1c45c1e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c33ce4af544c6fec831d610d917b73e661e23d8d8d7363b7e2a833f4b4234706"
  end

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
    json_output = shell_output("tofu version -json")
    output = pipe_output("#{bin}/tfprovidercheck 2>&1", json_output, 1)
    assert_match "Terraform Provider is disallowed", output
  end
end
