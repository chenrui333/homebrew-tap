class Ghgrab < Formula
  desc "TUI for searching and downloading files from GitHub repositories"
  homepage "https://github.com/abhixdd/ghgrab"
  url "https://github.com/abhixdd/ghgrab/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "cb7cd6a6747add6653f8556c3911aa1ddaaff35061c8d7ee334694deecd03595"
  license "MIT"
  head "https://github.com/abhixdd/ghgrab.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47cb48a9b8934d7988045bd427b646de08acf33fd43be23d7d4d570ffb3e1e34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b71f9192d7b104cbfdf04a2d3dce20d186101e62e1f407c6bfbfec52f87fca71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab4c36d0abd84ae6795f3cbcf8180e6a06787ef4f7e131ce70a2279e2a119670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c982b7bc60f0156de91a00b65035464f72961180601de31de3fcf68a32d4ef5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78fe41c3cbae466a5139f1307af7c02c6edc3d4a320890ad9d6606eb2031d622"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "json"

    ENV["XDG_CONFIG_HOME"] = testpath/"config"
    (testpath/"downloads").mkpath

    assert_match version.to_s, shell_output("#{bin}/ghgrab --version")
    assert_match "saved successfully", shell_output("#{bin}/ghgrab config set path #{testpath/"downloads"}")
    assert_match "Download Path: #{testpath/"downloads"}", shell_output("#{bin}/ghgrab config list")

    payload = JSON.parse(shell_output("#{bin}/ghgrab agent tree not-a-url"))
    assert_equal false, payload["ok"]
    assert_equal "invalid_url", payload.dig("error", "code")
  end
end
