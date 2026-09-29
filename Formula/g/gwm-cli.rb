class GwmCli < Formula
  desc "Git worktree manager with a terminal interface"
  homepage "https://github.com/kbrdn1/gwm-cli"
  url "https://github.com/kbrdn1/gwm-cli/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "e391e8fc652720773cc71ba73eeee5b3d53369584f160658616992c3216910a4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/kbrdn1/gwm-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aff6a1cc72618d927ca181b413c4864559df2d9beecc0fe715452f22dc344b63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0296872c68ede5f0604337e954196ed0633ad59a8f059a79bce077d5acb413c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54bbbc7d3420b5035756b76f4051957b7656aa4628b915aacf0fc8e211eeb00b"
    sha256 cellar: :any,                 arm64_linux:   "89004f275e42c456f1d69e6b96925df0e5a52ac94d1cc24dc2b9626119860636"
    sha256 cellar: :any,                 x86_64_linux:  "37e4988dbd2b8c01685a9b94973dabc3fd4198c56ad859abcdf53ac21e84dfe7"
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
