class Kplane < Formula
  desc "CLI for creating virtual Kubernetes control planes"
  homepage "https://github.com/kplane-dev/kplane"
  url "https://github.com/kplane-dev/kplane/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "531f9dfb92c85fe1940d17ba4220b19ac644b45819c83053bd523bf082113ded"
  license "Apache-2.0"
  head "https://github.com/kplane-dev/kplane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "932451c0de8a9b296633362af928aa96b9db24024527a2cb5c0005adde40a10e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "932451c0de8a9b296633362af928aa96b9db24024527a2cb5c0005adde40a10e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "932451c0de8a9b296633362af928aa96b9db24024527a2cb5c0005adde40a10e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "520d497f80410b889cb7f9727554dd3ba9b9529589b0d005c7e1d4dfdc297c2a"
    sha256 cellar: :any,                 x86_64_linux:  "1a26a8e5c637bc8b1015ec7634f7dc09e96af316d7ad62acb4737cb56d6bf8a1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kplane-dev/kplane/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kplane"

    generate_completions_from_executable(bin/"kplane", shell_parameter_format: :cobra)
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/kplane not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
