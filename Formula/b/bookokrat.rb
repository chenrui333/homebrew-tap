class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "45cf2216993cbb2fda2d71f2fdf0f479d62cb5a5a0867c9b4413e4c9d38e335a"
  license "MIT"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d25be1c092794c7e1de537a18103bb84a646d35bb3d178ffee5989f0b815c98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7a791ed5aa1daf6950fd100450547a18c4c0323a02a0dfed24d557a89f38d22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d441e3fdc25687239f3271871ae813dd76c266ddf89944bcd39798d0d411a5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7faec892bb759ea4fc1b3ccbc6ac520105c7239740b730baa7718f9f9f72178d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "533fd70d95e53a6ecf89bbe32cb5beda99a386fea7e7d76bbfe408b385b57f0e"
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
