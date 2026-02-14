# NOTE: Kubedog also includes a CLI, however it provides a minimal interface to access library functions.
# CLI was created to check library features and for debug purposes. Currently, we have no plans on further improvement of CLI.

class Kubedog < Formula
  desc "Watch and follow Kubernetes resources in CI/CD deploy pipelines"
  homepage "https://github.com/werf/kubedog"
  url "https://github.com/werf/kubedog/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "986847bf3ed7b778764da03114c12d50f7213edc1c5af76eaf39ac570fb3b7ea"
  license "Apache-2.0"
  head "https://github.com/werf/kubedog.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/werf/kubedog.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubedog"

    generate_completions_from_executable(bin/"kubedog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubedog version")
    system bin/"kubedog", "rollout", "track", "deployment", "invalid"
  end
end
