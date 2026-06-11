class Kplane < Formula
  desc "CLI for creating virtual Kubernetes control planes"
  homepage "https://github.com/kplane-dev/kplane"
  url "https://github.com/kplane-dev/kplane/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "531f9dfb92c85fe1940d17ba4220b19ac644b45819c83053bd523bf082113ded"
  license "Apache-2.0"
  head "https://github.com/kplane-dev/kplane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b602214007b740c0406f9c31aefc47854ff2696837dd9e3bf04a7ed18a896065"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b602214007b740c0406f9c31aefc47854ff2696837dd9e3bf04a7ed18a896065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b602214007b740c0406f9c31aefc47854ff2696837dd9e3bf04a7ed18a896065"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2717f43e62aaf886b78b9110f597b23fffeaf1a45caa1cda49b0952f279fd700"
    sha256 cellar: :any,                 x86_64_linux:  "3dbb0f226e65cf1792ac47362652ab31a780082664194e065af0d90995ac649c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kplane-dev/kplane/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kplane"

    generate_completions_from_executable(bin/"kplane", "completion")
  end

  test do
    output = shell_output("#{bin}/kplane --help")
    assert_match "Available Commands", output
    assert_match "doctor", output

    assert_match "Check local prerequisites", shell_output("#{bin}/kplane doctor --help")
  end
end
