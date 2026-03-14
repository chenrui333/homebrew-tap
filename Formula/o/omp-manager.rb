class OmpManager < Formula
  desc "TUI manager for Oh My Posh themes, fonts, and shell setup"
  homepage "https://github.com/marlocarlo/omp-manager"
  url "https://github.com/marlocarlo/omp-manager/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "c65be58e47d2e8348385c4c7df8569375dda2b9797845779cedb7d55447937bc"
  license "MIT"
  head "https://github.com/marlocarlo/omp-manager.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a999439e6846437c106f0df3bf39ab184af32db2c8c34d3271e750c066250c99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46688134f26fa31b6610d4b70f9061542047df205c71d33832bfecd6b58b221a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "727011f2a3a4211d2a5682778c4a43f70fd2905a23c76af11504b283219dfca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "169759900df1a26d4b5cbcdcd773a4c93f929aa211865eb009de187e036fc394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9494d8f856868446f0895bfecb63ebc087c667010cb2ed45b2f58b22b5f09140"
  end

  depends_on "rust" => :build

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
