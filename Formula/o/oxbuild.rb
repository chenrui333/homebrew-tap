class Oxbuild < Formula
  desc "Ultra fast and easy-to-use TypeScript/JavaScript compiler"
  homepage "https://github.com/DonIsaac/oxbuild"
  url "https://github.com/DonIsaac/oxbuild/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "834585e6e17339b96e22562db245d8a0852f468d0a6ddeaad1656f424b3800f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d21ecce8f4a355ba5afee012a49f4411a2b7468b3ce4a9cb6f7147b952b86c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "defc784bc7548660a4d77112d16f34379c945ae85198cc843434719edb8d7a8d"
    sha256 cellar: :any,                 arm64_linux:   "571793d254200e08c1d754c03d13c767be7afdc5ec72e913dd4e2f9721fcb381"
    sha256 cellar: :any,                 x86_64_linux:  "7cbb24857450a71ff11006a96174fe9217ab1db81b1dbf0d5ed063c49e8844ee"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxbuild --version")

    (testpath/"src/test.ts").write <<~TYPESCRIPT
      export function greet(name: string): string {
        return `Hello, ${name}!`;
      }
      console.log(greet("Homebrew"));
    TYPESCRIPT

    system bin/"oxbuild"
    output = shell_output("node #{testpath}/dist/test.js")
    assert_match "Hello, Homebrew", output
  end
end
