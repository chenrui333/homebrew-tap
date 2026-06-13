class Spdr < Formula
  desc "Read-only DDR5 SPD decoder and semantic linter in Rust"
  homepage "https://github.com/The-Open-Memory-Initiative-OMI/spdr"
  url "https://github.com/The-Open-Memory-Initiative-OMI/spdr/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f0bf7a9d80b11885ce47e7288cde33df712a22ae0d1c393cda6c4ee0a308c5f7"
  license "Apache-2.0"
  head "https://github.com/The-Open-Memory-Initiative-OMI/spdr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6192aec676c3ac0d2206cbb5513ce4c7058b6937bf42e2fa206ce3879a626d1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43ee87ba71da1275d3b487ff34b5b09f134e3850e5031cde567e1e431c15150b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93b422311172cae644558965e15b69019856070bffc883c19ac0c2b4427f71f5"
    sha256 cellar: :any,                 arm64_linux:   "142320db97d93822adef559c240db86e1b4b5d2ad348eecfbcd677c49c55e6a0"
    sha256 cellar: :any,                 x86_64_linux:  "dc18be40e00d7bd2679f6a3f36b64c325376b8104b674db63a6547d68cca14ab"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "spdr-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spdr --version")
    output = shell_output("#{bin}/spdr not-a-real-command 2>&1", 2)
    assert_match "unrecognized subcommand", output
  end
end
