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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35aab69eab85456d6b1c1347d71996ab9c706424315e2a5ff71f012631c321e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce20878b84d33a82d49af8860eb8aa144d4873b61e388fc37819b163b11768f5"
    sha256 cellar: :any,                 arm64_linux:   "62a13184032c87ccb20185adbdddb68bf950837e09de597d1eef0dd4a27c0d93"
    sha256 cellar: :any,                 x86_64_linux:  "2ef527ed73bbc8bb68e01dfe1478548a6ba83d8ec8c76cf8c0d7e9ac7f96a08d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    if OS.mac?
      system "sh", "-c", "printf 'qq' | script -q /dev/null #{bin}/nexus >/dev/null 2>&1"
    else
      system "sh", "-c", "printf 'qq' | script -q -c '#{bin}/nexus' /dev/null >/dev/null 2>&1"
    end
  end
end
