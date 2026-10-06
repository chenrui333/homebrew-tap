class OmpManager < Formula
  desc "TUI manager for Oh My Posh themes, fonts, and shell setup"
  homepage "https://github.com/marlocarlo/omp-manager"
  url "https://github.com/marlocarlo/omp-manager/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "c65be58e47d2e8348385c4c7df8569375dda2b9797845779cedb7d55447937bc"
  license "MIT"
  head "https://github.com/marlocarlo/omp-manager.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80aa4958191f3451187fa1ab274fae63c5df6b1eb72568d11abad23716a9bbf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4688e409ac8f2c2b865bbe246cf7a950ef2ec4a33984717e7c3ebd3bd6cdb54b"
    sha256 cellar: :any,                 arm64_linux:   "a8ed330ef2ea7d3568d10d47997161ceb7c6fa5903103ca52837c5298064dad7"
    sha256 cellar: :any,                 x86_64_linux:  "4ea51cd85396ae5e031ad46d782579c47fe4502996cc0f17205ff369f34ebb27"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["TERM"] = "xterm-256color"

    cmd = if OS.mac?
      "printf 'q' | script -q /dev/null #{bin}/omp-manager"
    else
      "printf 'q' | script -q -c '#{bin}/omp-manager' /dev/null"
    end

    output = shell_output(cmd)
    assert_match(/\e\[\?1049h/, output)
    assert_match(/\e\[\?1049l/, output)
  end
end
