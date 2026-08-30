class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "a328b5231f0bf4eaa30f3c79a636e1b29601e5cd54fa8bad316b426cae629794"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc3246bc9aa9162fa2b67ae6eecc6a166f5a63222c232ab0f6dbc450b50d18a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2e3b7a06b748a0d554bd4a724b782f03da8bed9e11de4ac4078f13e1c4e184e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2ef405207b276b10f857812a8321c95dc469b053ec79ab5fee27197cb563dde"
    sha256 cellar: :any,                 arm64_linux:   "eb8624dacbf489b5e8fa9980a0ffb9dc5a9b4ce260a56b95bfb277d6a2a70d17"
    sha256 cellar: :any,                 x86_64_linux:  "c73feccf7d8c8324fc537cfdab8e63494915ee14993eab4409b542f0ac5e127f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdns-scanner --version")
    assert_match "# mdns-scanner configuration file", shell_output("#{bin}/mdns-scanner dump-default-config")
  end
end
