class Judo < Formula
  desc "Multi-database TUI for ToDo lists"
  homepage "https://github.com/giacomopiccinini/judo"
  url "https://static.crates.io/crates/judo/judo-1.2.0.crate"
  sha256 "dd1025aca46fcb6bf3d6224d883f3dd47066e9193a9ac4e03fde95d9964d191e"
  license "MIT"
  head "https://github.com/giacomopiccinini/judo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20472096d189efe0540fc1044639139303e8c70a1d1dae3eb6921932b636d546"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b60398d182b2d33804a44bc59befc87e5b6f898bead550f7a6e8674b7aefae94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12f205f45e3fe44386b25cb95b42a5db779bdf1f1b397b49f758de9ed54a7166"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f78d9d9cc086b798f52767dffb0a286f3b77784d8e981645e0eab37f12819c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "658a12880f438c6686633a6f2eb9035544609697eb72f919174ddb26fecd4037"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Fails in Linux CI with `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"judo", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "D A T A B A S E", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
