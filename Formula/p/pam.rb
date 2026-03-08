class Pam < Formula
  desc "Minimal CLI tool for managing and executing SQL queries with a TUI"
  homepage "https://github.com/eduardofuncao/squix"
  url "https://github.com/eduardofuncao/squix/archive/refs/tags/v0.3.0-beta.tar.gz"
  sha256 "32dd9ab000f8c498427ab7ed715b33166ab19b4fcb850479da709b684a037760"
  license "MIT"
  revision 1
  head "https://github.com/eduardofuncao/squix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5371b035cff26bb7f019a16114e4427219f053becd1aad5635fc86249f5dd1c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a5bb0421f7671d2ee4897a2f7fb25179a38b4f727151301b81c34d7e8521826"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f209ee20577b45d96acf15a8b1f6df920830491aff4e368eb7b6adf828a18aae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bffd043d4c244bdba3eb1bb19977f29399b76926ac369ae394fc7d2963afa2bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69f44376666d2c2f23fea37f7db03a78da660383b7eb3808fea4b385a448c766"
  end

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
