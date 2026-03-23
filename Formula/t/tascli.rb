class Tascli < Formula
  desc "Track tasks and records from the terminal"
  homepage "https://github.com/Aperocky/tascli"
  url "https://github.com/Aperocky/tascli/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "e7ce1b10383724bac04ca8927895693945838e8bee5c43cf89c4ab458b65fb1d"
  license "MIT"
  head "https://github.com/Aperocky/tascli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "768dc6f8c6a83f136cd4ce64fe95eaf0ef2aa5c9492daec5108971328693606c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8efeefba6193d4eadca04cb0a94d466e1885343a3c8ba9f17b3bea9159774b17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd436f0fa4d12ddc3a2bd0aa850c295a3bf5cf46a9e798ee3ee5d96a7a458544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43112b9b2564ce77cd273a1bd0e60f54d92989bf674699efb38c5938648f3693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0b311a7440e3fac0a5f985cddf54e45a8b929b3abca530c691c088a23877c20"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    task_content = "Write formula test"

    assert_match version.to_s, shell_output("#{bin}/tascli --version")

    system bin/"tascli", "task", "-c", "work", task_content, "today"

    output = shell_output("#{bin}/tascli list task -c work")
    assert_match task_content, output
    assert_match "work", output
    assert_path_exists testpath/".local/share/tascli/tascli.db"
  end
end
