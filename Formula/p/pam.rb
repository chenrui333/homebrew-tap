class Pam < Formula
  desc "Minimal CLI tool for managing and executing SQL queries with a TUI"
  homepage "https://github.com/eduardofuncao/squix"
  url "https://github.com/eduardofuncao/squix/archive/refs/tags/v0.5.4-beta.tar.gz"
  sha256 "c6ab6840b3bc6c0ef3c6f50142e9e369ef1abae876107abfdc959fc1cb31e148"
  license "MIT"
  head "https://github.com/eduardofuncao/squix.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-beta)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b40c142bd2e9bf46d60d258c9fb5e7197de7b0bae87042b248d17abea1850339"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f927e2d6bfb734868adefdec705f4c518f7e321fc498c81dd79043b158829383"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45aa615f8ae775267f38c66a4d924a9e4a32a4d32777545e432b44820f7c6396"
    sha256 cellar: :any,                 x86_64_linux:  "58fc0a432b27b2d7bc55c22a77d8603c2ce7855d16443bc100a464866fde3a22"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
