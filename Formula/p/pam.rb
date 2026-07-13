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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27a9edf931ba2c8936378edf43d5468697ce0245af937dfdbcd713889eab5bee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aacf60f685877ce80c7f5f116b51ad4db7eea9213f2eaaf4d08d35b8594daaf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3718280b11dfd14525bf0830203827ab83ac4a454736a687042a22b381fb28d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce2448df3b772c57ca64eca698b2dfdb73d1f5bd523419b88f15b4948dc42b86"
    sha256 cellar: :any,                 x86_64_linux:  "1d98bab8890628f0dd6c94a756c703cf47b7753051e7a1d384aef2a2098cd8ae"
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
