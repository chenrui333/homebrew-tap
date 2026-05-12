class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.15.9.tar.gz"
  sha256 "8aa75163ad0eb028a3c804e6143bfa4e8522c9b6c27051659a9d3de21a7afc54"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0908b68e444a04f520b6b3b4407c41252a9afe26142c286247c7b4b738cb64a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b60ad2cb126f8abb4cd876ebe429516edf27480e8f2309b2c46caa9844cf961b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb4d203335ac13402b4bef6dd1c5b88cd20e39434dfb4455128ae821f88aba45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c27682bcd2f649c96081b251174507d1bdbeaf85f543b1b1f8368c7cd0f1076f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29c13d8d5df18855d6f367bfa833860c20d2ee41d7728a657b2fb560d9f66e40"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end
