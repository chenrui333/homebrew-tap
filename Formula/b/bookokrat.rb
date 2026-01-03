class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "45cf2216993cbb2fda2d71f2fdf0f479d62cb5a5a0867c9b4413e4c9d38e335a"
  license "MIT"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b75d710291cfd2394ad50f39723e176d301daa0cd9cf35d5fd6b19b620f4a47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "883fcacc1cc81be887e0eb456665aca6720e582bdcab7a2695b5e6d2e829d9b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43af416da098ca498cf3fb78b90d5a016318bdf2a5dc428bf8a5a8166a02940d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c87240dd8c442e39b3d2a9cc91cbe8109f91a457c979e30f80d9ff227a61380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37db9f8d48028d15579a0a9893964795853b64f6565e70efecb0c0eae7fae2bf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Fails in Linux CI with `No such device or address (os error 6)` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = spawn bin/"bookokrat"
      sleep 2
      assert_path_exists testpath/".bookokrat_settings.yaml"
      assert_match "Starting Bookokrat EPUB reader", (testpath/"bookokrat.log").read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
