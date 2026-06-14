class Kplane < Formula
  desc "CLI for creating virtual Kubernetes control planes"
  homepage "https://github.com/kplane-dev/kplane"
  url "https://github.com/kplane-dev/kplane/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "531f9dfb92c85fe1940d17ba4220b19ac644b45819c83053bd523bf082113ded"
  license "Apache-2.0"
  head "https://github.com/kplane-dev/kplane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "358bb8f4c142989062481f3376772c624a1e8b04307a5f172e994d96ef9ecf4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "358bb8f4c142989062481f3376772c624a1e8b04307a5f172e994d96ef9ecf4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "358bb8f4c142989062481f3376772c624a1e8b04307a5f172e994d96ef9ecf4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75675171b191d9bda32f7b6b462ba0f940c2091b5f2f0dc57cf3abd120e72a13"
    sha256 cellar: :any,                 x86_64_linux:  "fdfbcf6ebccd7f1ca593078037011f85fe228d35490eb43c68a574b44efd950d"
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
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/kplane not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
