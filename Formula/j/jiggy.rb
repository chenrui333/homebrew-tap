class Jiggy < Formula
  desc "Minimalistic cross-platform mouse jiggler written in Rust"
  homepage "https://0xdeadbeef.info/"
  url "https://github.com/0xdea/jiggy/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "11e3d3c3d55ae9fddbfb6e94c27edda03a8ccdcf29b1cc6247a84411510c9d80"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7755eb9907da13e12ee5fb21908b4fc1583eb1e9623e48679060b1545eebb44c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f8c52443ed32fa7e1861c897e6aa36fea2560e7c2e655d672c91a6ff5acde1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5381751ab5b0a9d14ece1e402dacc1ea7aab38cd78dd30a0004997c83084c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51d1bd0bdf6fd7fe1ead93706fe13c1435d19916d7a117bc51ed0013efdf85ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc6e096837056111917fafb0a5fb93566f82dd115499cbaf827405537361be90"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "xdotool"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiggy --version")

    # Error: DISPLAY environment variable is empty.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"jiggy", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Just chillin' for 60s", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
