class Pam < Formula
  desc "Minimal CLI tool for managing and executing SQL queries with a TUI"
  homepage "https://github.com/eduardofuncao/squix"
  url "https://github.com/eduardofuncao/squix/archive/refs/tags/v0.5.1-beta.tar.gz"
  sha256 "5aaa54beb14c090ea88a15762002573aec5e632b9c773756a1f27af272c791e2"
  license "MIT"
  head "https://github.com/eduardofuncao/squix.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-beta)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e87935ef2a0baa11960a54964ca049de1c5fda3da2fe75f00a15790256182a55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "472c765238089450d8cf2d409bfbe28f9c67a30424b5fff9b36a4e1610f51821"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd5a0bbc34efa0c31e241d4e1fe3b2212450343ab0aa85d567718be710fcb4ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "becec908337a2ebaff50d2f6711c89baf1d880b82970fd98ae367701a925aedf"
    sha256 cellar: :any,                 x86_64_linux:  "6b76a50be026ef472a8f3989ccd221dcc518e8423ab6de4ccfe6da08788cc79f"
  end

  depends_on "go" => :build

  def install
    # Upstream renamed the project from pam to squix; keep a pam shim for this tap formula name.
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"squix", ldflags:), "./cmd/squix"
    bin.install_symlink "squix" => "pam"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/squix --version")

    output = shell_output("#{bin}/pam list connections")
    assert_match "No connections configured", output
    assert_equal shell_output("#{bin}/squix --version").strip, shell_output("#{bin}/pam --version").strip
  end
end
