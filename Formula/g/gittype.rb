class Gittype < Formula
  desc "CLI code-typing game that turns your source code into typing challenges"
  homepage "https://github.com/unhappychoice/gittype"
  url "https://github.com/unhappychoice/gittype/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2efb51de5b8e00a4bc0086a3811e473f5934ca08750a32bcc39b19dfdeff68e7"
  license "MIT"
  head "https://github.com/unhappychoice/gittype.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a4a81533f2ce776c1d11362dfc920168e7a34bb308d992835831bed63bf27ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50743fd41a28b2c6b4afbd02d9b6122e71351e29638066f992bfda79f4fed79e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c447018a8088d0ef82ed7706dffc6b342faceae1944ab14ce859ba9aa8974ec4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c217e08b322a361c1c5b41206b016e85ff2eb76d44e075e51f966a20a628d006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40e5bc2df02c375f1267ba4d6f9496e492c9db09527d4bbbc5c7d0fb00e7b957"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
