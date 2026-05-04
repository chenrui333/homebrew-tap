class Pam < Formula
  desc "Minimal CLI tool for managing and executing SQL queries with a TUI"
  homepage "https://github.com/eduardofuncao/squix"
  url "https://github.com/eduardofuncao/squix/archive/refs/tags/v0.4.0-beta.tar.gz"
  sha256 "be4e0283df5e1f8801af2e8e6a9c8017cba6b8f7923aa56c829d3abca51801e2"
  license "MIT"
  head "https://github.com/eduardofuncao/squix.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-beta)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e700fe33c47cee1ce2531eaf578db08740c9eceb0ef4ac8ba5d2a3ffd0129b36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36aa69235b220cdfb8d68a53a41698f826e57311e6922119bc836d0e51fb8dc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23b8137e43f3d412b86c7ff1f0a0acfa8be18a4903c07604d0f2cd3d259bf1bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ca5022640df3c0bc703dcaacd25b9aa201d39dbc2c3a4a416fd3d827d8ef236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c9c4d322993b737dcb020e6a0f794e53dd5a4afb6ab49a968fa7c301b8d8132"
  end

  depends_on "go" => :build

  def install
    # Upstream renamed the project from pam to squix; keep a pam shim for this tap formula name.
    system "go", "build", *std_go_args(output: bin/"squix", ldflags: "-s -w"), "./cmd/squix"
    bin.install_symlink "squix" => "pam"
  end

  test do
    output = shell_output("#{bin}/pam list connections")
    assert_match "No connections configured", output
    assert_equal shell_output("#{bin}/squix --version").strip, shell_output("#{bin}/pam --version").strip
  end
end
