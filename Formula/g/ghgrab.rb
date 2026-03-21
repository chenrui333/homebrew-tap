class Ghgrab < Formula
  desc "TUI for searching and downloading files from GitHub repositories"
  homepage "https://github.com/abhixdd/ghgrab"
  url "https://github.com/abhixdd/ghgrab/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "0b68ec1e7c0a0975f5ddb5e040be4349a4f5657b761c3e7c1a6d302f364cb8c8"
  license "MIT"
  head "https://github.com/abhixdd/ghgrab.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee0c4673e68ce42e7f1da2599dc0de633d7eb4723c07d49a04eec1f2272b1d83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "631fb279fa04fa9b67576e4b878f5760a0ca21f2f408a5a059af5acf7781c6aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45194eae6f7c7829871b08ca464a00b3066fd484f9894e7d135c7e1f35e8a3a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eee6f8e269fee0fb7353e823341cb027b5af6c101c6fac35f291ecb6d5e7213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "accf81c69a1ea8a7a200f2031d5b2624635fecb2c501a6e235311128d9975cb8"
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
