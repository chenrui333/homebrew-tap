class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "0490e129af6820b5b7be24e662efc660a1d5aab9f7d00c383b8ab1ff26b032a5"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a03578e279fc9e9963ac779a5f4cfc3e0d28a8ea6ec90fc03cb8965ad365dd42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "850b07f7dbd0e9dfdfb8e1201ec33fb4a99fcd9fc39d12d0d0d201a3f58e9938"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82ec04dccf226ac3def4a07367e6b3ed629d5a15dc66ff1df477851e2e051735"
    sha256 cellar: :any,                 arm64_linux:   "7e5a22f51732a579d1af65b7af6c021e2dc1979c66b7c519b32e7d08f1780bc3"
    sha256 cellar: :any,                 x86_64_linux:  "39ba703b96647f0e1cf8af2f6b039086561112b14829776d5d6065f9f0769b68"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
