class Ghgrab < Formula
  desc "TUI for searching and downloading files from GitHub repositories"
  homepage "https://github.com/abhixdd/ghgrab"
  url "https://github.com/abhixdd/ghgrab/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "cb7cd6a6747add6653f8556c3911aa1ddaaff35061c8d7ee334694deecd03595"
  license "MIT"
  head "https://github.com/abhixdd/ghgrab.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f473e2f4ef22561cc13b325f8d08861ae12d2bdc331d6bc167878f97b6a93f50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22653cd711d820fc046fd9bcad338b36dccdcae800d74693b335a501ea35b323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b6e8682e3c4d7c24e24fec51707c33bee57001834f8edd0e44f6ebcf3912f5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89ea21ffc1b31df27ecd70bf20da705618e7064c5b8db6e220c8f523bc3441e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f0be85669527254c9fa4d64f131e35779360b8eba712be46e15167b91ba5857"
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
