class Pam < Formula
  desc "Minimal CLI tool for managing and executing SQL queries with a TUI"
  homepage "https://github.com/eduardofuncao/squix"
  url "https://github.com/eduardofuncao/squix/archive/refs/tags/v0.3.0-beta.tar.gz"
  sha256 "32dd9ab000f8c498427ab7ed715b33166ab19b4fcb850479da709b684a037760"
  license "MIT"
  revision 1
  head "https://github.com/eduardofuncao/squix.git", branch: "main"

  depends_on "go" => :build

  def install
    # Upstream renamed the project from pam to squix; keep a pam shim for this tap formula name.
    system "go", "build", *std_go_args(output: bin/"squix", ldflags: "-s -w"), "./cmd/squix"
    bin.install_symlink "squix" => "pam"
  end

  test do
    output = shell_output("HOME=#{testpath} #{bin}/pam list connections")
    assert_match "No connections configured", output
    assert_equal shell_output("#{bin}/squix --version").strip, shell_output("#{bin}/pam --version").strip
  end
end
