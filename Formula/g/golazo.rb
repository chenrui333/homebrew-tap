class Golazo < Formula
  desc "Minimal TUI app to follow live and recent football matches"
  homepage "https://github.com/0xjuanma/golazo"
  url "https://github.com/0xjuanma/golazo/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "9dcc5103833cbd57c86ddea99f7ff70f18e6e2606961e2a7036462db089f64c4"
  license "MIT"
  head "https://github.com/0xjuanma/golazo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17570e3014879c8984a3057f6cba6c2bc5a76e4684f072ea333c8f62a57784f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17570e3014879c8984a3057f6cba6c2bc5a76e4684f072ea333c8f62a57784f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17570e3014879c8984a3057f6cba6c2bc5a76e4684f072ea333c8f62a57784f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ba4ac0a32caee0f7641632e039d0f068a9f1f396102040ec2dfc3a466f59e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd01830dd136f9403fa662d8234297b09fcfed3e4d6c9f9a445e951f9610bd34"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/0xjuanma/golazo/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/golazo --version")

    output = shell_output("#{bin}/golazo --definitely-invalid-flag 2>&1", 1)
    assert_match "unknown flag", output
  end
end
