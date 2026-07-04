class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "3600dadbba659d56d2dede32a384923ebf3cdf91af96c13b1efdaaee23302ba9"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c904a3a1f6b1887d9098e56eda6b9b9341c7a2fc861c0d2fd1fc241a273a23f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbc38a7d518f495fb7e8ef974f2902f2ca22c539e1d02c8e283fa452acbb57c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cd6f27944b082c6ad5a2076221cfa767cccca001dca7e3be7462bba75ecc1be"
    sha256 cellar: :any,                 arm64_linux:   "aa7fd49c52b9b8b5828326c911598e8ff387568ffd1c80baa455e9b371ff8c2c"
    sha256 cellar: :any,                 x86_64_linux:  "bcf1fa08f0c3005c5672a5f98028af30ecc3510c5bbedb3360d369f99edc1eeb"
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
