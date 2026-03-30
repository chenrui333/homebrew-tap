class Gittop < Formula
  desc "Beautiful terminal UI for visualizing Git repository statistics"
  homepage "https://github.com/hjr265/gittop"
  url "https://github.com/hjr265/gittop/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "5afaf1ee423bb23b7e7cbe335bdbf2bc83da848caf2eeac82284efbe80ab3b4b"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd40af3d6550664067a1d752aa9f051a082447ad8988c59d615072b9cab0d5f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd40af3d6550664067a1d752aa9f051a082447ad8988c59d615072b9cab0d5f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd40af3d6550664067a1d752aa9f051a082447ad8988c59d615072b9cab0d5f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a26eef9aa5a24b58ccacfffceac3c9c4ce9ca6bd1794652881d9605051609855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85fce6824f7affa25a2929f28b9b22c777b0d8d0edc781b2641464b0f1cea475"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "Homebrew"
    system "git", "config", "user.email", "brew@example.com"
    (testpath/"README.md").write("hello from Homebrew\n")
    system "git", "add", "README.md"
    system "git", "commit", "-m", "init"

    command = if OS.mac?
      "printf 'q' | script -q /dev/null #{bin/"gittop"} #{testpath}"
    else
      "printf 'q' | script -qefc '#{bin/"gittop"} #{testpath}' /dev/null"
    end

    output = shell_output("#{command} 2>&1")
    assert_match "q", output
  end
end
