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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e09a52131882eba1fdf3210cd5147b689925aef1939ca317b49114c02100c555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "665fc2b35c493d06f6b3132318b367e46f0b07f07371a6a185062549d82e8092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d53471cdc219847480ec789b6828bb93e862d9a46ce399a8f232a9684795081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c872c05e77807551130423ce11880ef43f53c0723db3b25fe1799067dab1a277"
    sha256 cellar: :any,                 x86_64_linux:  "f0093dfd3116a212d3b4d39027e6f21bd331104f6114f6e308b05f5f8728ebb0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/werf/kubedog.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubedog"

    generate_completions_from_executable(
      bin/"kubedog", shell_parameter_format: :cobra, shells: [:bash, :zsh, :fish, :pwsh]
    )
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubedog version")
    output = shell_output("#{bin}/kubedog rollout track deployment 2>&1", 1)
    assert_match "requires at least 1 arg(s)", output
  end
end
