class Kanha < Formula
  desc "Web-app pentesting suite written in rust"
  homepage "https://github.com/pwnwriter/kanha"
  url "https://static.crates.io/crates/kanha/kanha-0.1.2.crate"
  sha256 "dea79d04f2c29a742dca69642e473ceca5e458f2a6bf9cfd88847e9124057baa"
  license "MIT"
  head "https://github.com/pwnwriter/kanha.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42ea17f6ad56213a62ec0b5fad58daeed0b4450c62acc04d10bfbe2fecd2b823"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7130c84960522bb29f38d3e633b193c811f612ab27aadeb81a5a559a0cba05d9"
    sha256 cellar: :any,                 arm64_linux:   "2ac5902fb50274922d2817aabd2aee6a12d71511e547035ae3c73366d2b29476"
    sha256 cellar: :any,                 x86_64_linux:  "50d42dfdec131ff938c5bd47f432d8b4fa645a901f352dcf40b864f813fea7a9"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kanha --version")

    (testpath/"plain.txt").write "https://example.com/a b?q=1\n"
    (testpath/"encoded.txt").write "https%3A%2F%2Fexample.com%2Fa%20b%3Fq%3D1\n"

    assert_equal "https%3A%2F%2Fexample.com%2Fa%20b%3Fq%3D1\n",
                 shell_output("#{bin}/kanha urldencode --encode #{testpath}/plain.txt")
    assert_equal "https://example.com/a b?q=1\n",
                 shell_output("#{bin}/kanha urldencode --decode #{testpath}/encoded.txt")
  end
end
