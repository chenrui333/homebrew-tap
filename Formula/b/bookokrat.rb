class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "c3e65ab54bfd0bb3b4abf21139ccf07d32f15316afec69eb011ff74dd3893a1d"
  license "MIT"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1158015398b07b728e4d180e17dc39ab40c94691811d74885a00ee4e8377f082"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "398e3fed4b7e201b87c9a7e486eb291de14cd2a405664fe8647146a0aadc68f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0e3e5d421aa922dc1c2aed6d00dec1c006510f284f1c269df412b53b05ff56a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6c48d2f99d4ae7313f7205f207e1613ded5135bcc95f9427c31c7d5920f22fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "683b39c76df536e9b1ff3d241251ca70827ac33e0c0a51187f2b9a8868fc74d7"
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
