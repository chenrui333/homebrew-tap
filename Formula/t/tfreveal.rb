# framework: urfave/cli
class Tfreveal < Formula
  desc "CLI to show Terraform plan with all the secret (sensitive) values revealed"
  homepage "https://github.com/breml/tfreveal"
  url "https://github.com/breml/tfreveal/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "ece05febc2b4e8bb19f1e01b3359edeff4202b8e0a248d28c2b93ad7ee154937"
  license "MIT"
  head "https://github.com/breml/tfreveal.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0460e1888917aa7d2021b8d79b725105fee7ba556d424e158982463ec58af760"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0460e1888917aa7d2021b8d79b725105fee7ba556d424e158982463ec58af760"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0460e1888917aa7d2021b8d79b725105fee7ba556d424e158982463ec58af760"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "080757248430086dbc9d4d38c9f5377aea34406c97b0e55123d1381d7d238f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aef6e1944355b1db145f199b35f7e783357d1c9a0c545931ad1709985fb195e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfreveal -v")

    (testpath/"plan.json").write <<~JSON
      {
        "format_version": "1.2",
        "terraform_version": "1.7.2",
        "resource_changes": [
          {
            "address": "null_resource.cluster",
            "mode": "managed",
            "type": "null_resource",
            "name": "cluster",
            "provider_name": "registry.terraform.io/hashicorp/null",
            "change": {
              "actions": ["delete", "create"],
              "before": {"id": "5350362168280616586", "triggers": {"secret": "secure"}},
              "after": {"triggers": {"secret": "very very secure"}},
              "after_unknown": {"id": true, "triggers": {}},
              "before_sensitive": {"triggers": {"secret": true}},
              "after_sensitive": {"triggers": {"secret": true}},
              "replace_paths": [["triggers"]]
            },
            "action_reason": "replace_because_cannot_update"
          }
        ]
      }
    JSON

    output = shell_output("#{bin}/tfreveal --no-color #{testpath}/plan.json")
    assert_match "null_resource.cluster must be replaced", output
    assert_match '~ secret = "secure" -> "very very secure"', output
  end
end
