class Ghgrab < Formula
  desc "TUI for searching and downloading files from GitHub repositories"
  homepage "https://github.com/abhixdd/ghgrab"
  url "https://github.com/abhixdd/ghgrab/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "4085a878d1a99bcc91431da7fc24b7825fec3293a2bbeb4a67a94561b798dca8"
  license "MIT"
  head "https://github.com/abhixdd/ghgrab.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32c83ec2c63ed6b9839c42e7ff55dc63e23f3caf66890942da33a9b38cabdd9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3d4a2aa4790acebcfeceaefad154dada5fc72a33e586fa3fd7746ed87583c2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7282f4ac358f2d05afc27d81e01acd5988085212fbe1955c671ee15e4b9c2657"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a41c08fbbd13b4445e0be939f67cb598550964d84ba6f055f9d886be267bcb1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5324966d86d0be35c524f02359e2b0f966775551da278234fb9f7aecb3a9696b"
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
