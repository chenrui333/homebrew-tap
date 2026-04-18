class Ghgrab < Formula
  desc "TUI for searching and downloading files from GitHub repositories"
  homepage "https://github.com/abhixdd/ghgrab"
  url "https://github.com/abhixdd/ghgrab/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "2c38e403957eb60c4c20cbd6accadc4900e09cee02edad2ee047e9284006a944"
  license "MIT"
  head "https://github.com/abhixdd/ghgrab.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc88a968000080a2b67bbc07383455251efd0ac9412fac4140492e913c7d7155"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71c6e3485b7b729973c1b7a047660b6e390053dbd3b6629072a5d4aa9458ec53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76d518edad1e5df7ed973a2804044873583afcee8e5225ac08bf7505795b2aa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9dc2b03d8fa7d06c60fbb43ebb88368b15882a854b22bd55fbf9fd6a7cf8426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b830ffe00443549e354710bc0f89ab5e991d9e390baf7441cddaaffe48e143d8"
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
