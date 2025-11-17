class Cashd < Formula
  desc "TUI for personal finance management"
  homepage "https://github.com/hzqtc/cashd"
  url "https://github.com/hzqtc/cashd/archive/refs/tags/0.1.5.tar.gz"
  sha256 "c996be017f6598540d5bf8cd3dfbb4d73d0398bf5e941148018d426cbce7df4d"
  license "MIT"
  head "https://github.com/hzqtc/cashd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56b5afe219494982016a8ff4f35491c8e95f6657df95dde682464faf36531c1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56b5afe219494982016a8ff4f35491c8e95f6657df95dde682464faf36531c1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56b5afe219494982016a8ff4f35491c8e95f6657df95dde682464faf36531c1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f64f7659449d699a579af5a2b0ed34debc9a73da44cbc2156c156f1eab0e49c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a58cb6190c667bb80035d4f31f4ad4e7c431e62990e2442a1e09fe2d83844fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cashd --version")
  end
end
