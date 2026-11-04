class NoMistakes < Formula
  desc "Agent-driven Git push gate and validation pipeline"
  homepage "https://github.com/kunchenguid/no-mistakes"
  url "https://github.com/kunchenguid/no-mistakes/archive/refs/tags/v1.110.0.tar.gz"
  sha256 "ebc2e11ae771cfa9964d7d502289ce4c494c522077e10dde4e46425ea967b437"
  license "MIT"
  head "https://github.com/kunchenguid/no-mistakes.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88ad712eeb38f19965b4680688f4d8205606591d56ae9eacdf827c6f1c826544"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88ad712eeb38f19965b4680688f4d8205606591d56ae9eacdf827c6f1c826544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9258a641bbd05dfff93ee75e4c02c4a7a5ea271bc3341935b388391c96febed9"
    sha256 cellar: :any,                 x86_64_linux:  "e8497657a3a7201e0061caeb861f34e03543dfef278974cc3878f3d4ef555e1f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/kunchenguid/no-mistakes/internal/buildinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/no-mistakes"
    generate_completions_from_executable(bin/"no-mistakes", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"no-mistakes", "daemon", "run"]
    log_path var/"log/no-mistakes.log"
    error_log_path var/"log/no-mistakes.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/no-mistakes --version")

    assert_match "not in a git repository", shell_output("#{bin}/no-mistakes status")
  end
end
