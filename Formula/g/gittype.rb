class Gittype < Formula
  desc "CLI code-typing game that turns your source code into typing challenges"
  homepage "https://github.com/unhappychoice/gittype"
  url "https://github.com/unhappychoice/gittype/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2efb51de5b8e00a4bc0086a3811e473f5934ca08750a32bcc39b19dfdeff68e7"
  license "MIT"
  head "https://github.com/unhappychoice/gittype.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6bed04f6d2b0b26278a25ab92279726cbc4440baefe6900c657db3dbc1b5511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85b89d9559891dfeb0465561a9d766b14cc4114ee08f7c087a65b8c67a11cda1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4fdd8c7e6651cd704c9dcf9836a64fe07cd7f547c00a8a6352dfb93e2525062"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gittype --version")

    %w[history stats export].each do |cmd|
      output = shell_output("#{bin}/gittype #{cmd} 2>&1", 1)
      assert_match "command is not yet implemented", output
    end

    output = shell_output("#{bin}/gittype repo list 2>&1", 1)
    assert_match "Error: Terminal error: Not running in a terminal environment", output
  end
end
