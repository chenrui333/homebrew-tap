class Gittype < Formula
  desc "CLI code-typing game that turns your source code into typing challenges"
  homepage "https://github.com/unhappychoice/gittype"
  url "https://github.com/unhappychoice/gittype/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2efb51de5b8e00a4bc0086a3811e473f5934ca08750a32bcc39b19dfdeff68e7"
  license "MIT"
  head "https://github.com/unhappychoice/gittype.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ed131e1bc7e6571f4bb559086155ebf09524c2c9fe8c443951b9a5bd3ab15b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e399a2c84b8ebfae90114c9ef0f685f8c518c49f523bed4980f4b1b741f2bd33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90f79a2e6b95667414ebb61d72cf1988f3fffc85a983acbdabb58663964f4617"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1563da30de7b89d8b0116d3db0b4386aef71372f3bb405d86d644f08636ed6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42980aa4c99e7fd9b3cc7407d4c0e18c5198bc5d3b18249977cf974a9deb0135"
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
