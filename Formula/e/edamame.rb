class Edamame < Formula
  desc "Terminal Markdown editor that stays rendered while you edit"
  homepage "https://github.com/mijowi/edamame"
  url "https://github.com/mijowi/edamame/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "952c8972d2b272876f2f45a5ca83dd3d686dc8bc7655270d823402ae4634f515"
  license all_of: ["Apache-2.0", "OFL-1.1"]
  head "https://github.com/mijowi/edamame.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52369a8b6ce7f9e11164106e41e34b65503b17f717ebcc1e11212632f5f8a981"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1e6bf1fe97949517ba0b19cdee8e38699eb9b8bfd35f679ab1b572784534928"
    sha256 cellar: :any,                 arm64_linux:   "0a258d4e1df2be1969b58c4354201b6b1eb915adc0d8d0a19b36656d9cf56896"
    sha256 cellar: :any,                 x86_64_linux:  "4e2c08724f20d2900006e99f1a4f53bdd33ac91e43aaf98ac161d9bf6a889b22"
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
