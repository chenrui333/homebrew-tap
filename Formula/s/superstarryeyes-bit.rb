class SuperstarryeyesBit < Formula
  desc "CLI/TUI logo designer with ANSI fonts, gradients, shadows, and exports"
  homepage "https://github.com/superstarryeyes/bit"
  url "https://github.com/superstarryeyes/bit/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "eb5e2a0ff22a4cd5312180e2e8396736b4e5d63ebe2c6c5ac0f98560992c9dac"
  license "MIT"
  head "https://github.com/superstarryeyes/bit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "895a8937eaa9e490b83aea8d061ee5e998926c3bae7e371d42d474e49299d52e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "895a8937eaa9e490b83aea8d061ee5e998926c3bae7e371d42d474e49299d52e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "895a8937eaa9e490b83aea8d061ee5e998926c3bae7e371d42d474e49299d52e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "872cdfcb92040098b458bdec59ffffbd45cac7f82c6c8a3e066984644a6e6d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aa02fd33ba486beb4f31df124a9c2588b45c418387a215d03b21936b9f583dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"bit"), "./cmd/bit"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"ansifonts-cli"), "./cmd/ansifonts"
  end

  test do
    assert_match "Error listing fonts", shell_output("#{bin}/ansifonts-cli -list 2>&1", 1)
  end
end
