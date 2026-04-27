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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07ad2b5e5d25248723385f7e0a817f767a9cbbf705f4fc01edaa4e740b021ab0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eae69e078441af400ba4982e7545ecb776ed8448084d74514d45cb7ebc98cd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9276ada77605111dbad34a6b90672a2d5fb7162c064a182acfb567dc4a9e07f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bcd0b08840c52474f48dc99b617d264f12140cf76de6bf42aa56cbdd6e52b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "630095ea36043d856ceb261208eaa310e7ce2e8b37b97ceb3d65fec732288c83"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/werf/kubedog.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubedog"

    generate_completions_from_executable(bin/"kubedog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubedog version")
    output = shell_output("#{bin}/kubedog rollout track deployment 2>&1", 1)
    assert_match "requires at least 1 arg(s)", output
  end
end
