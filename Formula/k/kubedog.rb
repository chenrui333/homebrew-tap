# NOTE: Kubedog also includes a CLI, however it provides a minimal interface to access library functions.
# CLI was created to check library features and for debug purposes. Currently, we have no plans on further improvement of CLI.

class Kubedog < Formula
  desc "Watch and follow Kubernetes resources in CI/CD deploy pipelines"
  homepage "https://github.com/werf/kubedog"
  url "https://github.com/werf/kubedog/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "986847bf3ed7b778764da03114c12d50f7213edc1c5af76eaf39ac570fb3b7ea"
  license "Apache-2.0"
  head "https://github.com/werf/kubedog.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88c4cea598fb4b4acd80625076fce1559a0d4ff074276b9f17a50617c4c69eff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85f10f57cf462f0c2862203823d281885c88adb752c1fd196cb45e1b1ee4ed04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a81e87ec14c42dad022232a79b27516e79d4b1edf4eda080dd0689ed0e53f9ca"
    sha256 cellar: :any,                 x86_64_linux:  "ceb51b9e5ba0c73b2fcc3c08b553ba234805fd65c1786a6ccb6fdd2b1eba06ac"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/werf/kubedog.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubedog"

    generate_completions_from_executable(bin/"kubedog", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubedog version")
    output = shell_output("#{bin}/kubedog rollout track deployment 2>&1", 1)
    assert_match "requires at least 1 arg(s)", output
  end
end
