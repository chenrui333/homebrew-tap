class Kplane < Formula
  desc "CLI for creating virtual Kubernetes control planes"
  homepage "https://github.com/kplane-dev/kplane"
  url "https://github.com/kplane-dev/kplane/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "531f9dfb92c85fe1940d17ba4220b19ac644b45819c83053bd523bf082113ded"
  license "Apache-2.0"
  head "https://github.com/kplane-dev/kplane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48a5b9a95030b4af91975b8282a2461bdda9a48c80ca765682d38ee94552f132"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48a5b9a95030b4af91975b8282a2461bdda9a48c80ca765682d38ee94552f132"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e08b0ade55115a84f6b922a4c68c56c314ed43b7bdbfab0f286e2f2504f9ec78"
    sha256 cellar: :any,                 x86_64_linux:  "c69f76290809db413bd22850ef5cd3debd3fe0ebe74e0f712fbfd4f2996e70c6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
