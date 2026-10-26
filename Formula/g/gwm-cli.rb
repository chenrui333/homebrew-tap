class GwmCli < Formula
  desc "Git worktree manager with a terminal interface"
  homepage "https://github.com/kbrdn1/gwm-cli"
  url "https://github.com/kbrdn1/gwm-cli/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "62a5421731326390dc721b3f756c8c95dccb2e43607f83c934d738d7fbd93bf6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/kbrdn1/gwm-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "615bf4b78eadf8139c0a065ba05ec48f0e32a388713c4704eb0c826e0250aba8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd950565ffe9a7d256f0b26e694c82150da417a72151698a795a38c4ae86ae06"
    sha256 cellar: :any,                 arm64_linux:   "88944c92238009ebd7c0300ce73ea4e6f45e4d158e936ed990a0eb39d8748ee5"
    sha256 cellar: :any,                 x86_64_linux:  "5404f64bf7295ec42876c38fe949370e6e49aa5c0aebe54c67341419287a0369"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"gwm", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gwm --version")
    output = shell_output("#{bin}/gwm list 2>&1", 1)
    assert_match "not inside a git repository", output
  end
end
