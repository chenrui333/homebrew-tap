class Nexus < Formula
  desc "Terminal-based HTTP client for REST and gRPC APIs"
  homepage "https://github.com/pranav-cs-1/nexus"
  url "https://github.com/pranav-cs-1/nexus/archive/0906a0fd7799058a35adaf58160d5e2027a59e83.tar.gz"
  version "0.2.1"
  sha256 "e5ca698629a915f4b988c8b91d79059c4ac7ff245ef86cbd24235bd96eedf349"
  license "MIT"
  head "https://github.com/pranav-cs-1/nexus.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "684edf8f054d17ed74e075172fff6da8e5ee3e0f3a65b7478960dacf8985b303"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "697e068cdc19e969310de5497e1e39f56d7ea6ec7ae617e10e4b99c2dd2a5f97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1093efce05af232806f162f3bf19cc1f75b7b57175488b0161cc7af65777ae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a01caddec29d265dc5b8ec7fdf5a528e96b3ad82c9dc7aeafde3ff97424a31b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b31bafd31fef1527b764109ccd8c5bfa925cb0184bf665cb53c1819022209f1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    if OS.mac?
      system "sh", "-c", "printf 'qq' | script -q /dev/null #{bin}/nexus >/dev/null 2>&1"
    else
      system "sh", "-c", "printf 'qq' | script -q -c '#{bin}/nexus' /dev/null >/dev/null 2>&1"
    end
  end
end
