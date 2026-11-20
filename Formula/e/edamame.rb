class Edamame < Formula
  desc "Terminal Markdown editor that stays rendered while you edit"
  homepage "https://github.com/mijowi/edamame"
  url "https://github.com/mijowi/edamame/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "490f473431dda87857337a1e2cee744499b33deff79b2677b26588fc608916d9"
  license all_of: ["Apache-2.0", "OFL-1.1"]
  head "https://github.com/mijowi/edamame.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3583e2f2b27519cb1fa85b17aaad9fb5a055f6aed55beba2e0d4f31dea28f578"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4131b3e989993941f658d3b29f3743d59c70c35b8b9c986a70b763ffa948132b"
    sha256 cellar: :any,                 arm64_linux:   "5512db090347eb45c52e044311e4e2871296190fc6778de0897c8b62469afbe7"
    sha256 cellar: :any,                 x86_64_linux:  "4d3dfac2adc973eeddfe146316eddb3efd78ee0884ad399ded91823b04e8fc66"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "src/assets/katex/OFL.txt", "src/assets/katex/FONT_NOTICE.txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/edamame --version")
    (testpath/"old.md").write("# Homebrew\n\nMarkdown editing.\n")
    cp testpath/"old.md", testpath/"new.md"
    assert_match "has no differences to review", shell_output("#{bin}/edamame --diff old.md new.md 2>&1")
  end
end
