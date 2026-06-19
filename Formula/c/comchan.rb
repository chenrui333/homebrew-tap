class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "21a3e01f02d67c70238ae94a31c1c2579d363d3d2548059e11e495e7d2b26c22"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c358a41f8726a3c090275f256a6b701e88b28f3d331cdf07ac5062aa7221538b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6292ed0a7c63574819b9967eae3dd4162c6ef89ecc9ad7d2ea479bac294d8683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a62921ac20e44db214330142db6e340cbc0a5e5a047657bad316f9f1afb171b5"
    sha256 cellar: :any,                 arm64_linux:   "d38b2acc6a734d35fa9af17b9d4285a56fd66548dc58f2fd50d4097e1e587afa"
    sha256 cellar: :any,                 x86_64_linux:  "a6a6ed1a60df6cfc57960620ec4d515af19a7101f6b4479f117918920e1b93fc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comchan --version")

    shell_output("HOME=#{testpath} #{bin}/comchan --generate-config")

    config = if OS.mac?
      testpath/"Library/Application Support/comchan/comchan.toml"
    else
      testpath/".config/comchan/comchan.toml"
    end
    assert_path_exists config
    assert_match 'port = "auto"', config.read
  end
end
