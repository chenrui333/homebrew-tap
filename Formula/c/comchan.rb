class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "72a68ee05b61cee6678b5ba87b7d8cca1290381b0a7bbe90bf4401fcb63db63c"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "378abeb228cdb06117eaf496b46ffd1f862d5e9cb9e4212d6010092c31365dcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce18a1fef1dcf913c29664e6751ee1862254e424f7c95785180f84bba3e3331d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de77258576a61f7b13b000dd758f005ea2c2774b7077eb1c4187e8ac54f932dc"
    sha256 cellar: :any,                 arm64_linux:   "a7287c4358f462b9dc2f2d6ce897dd31dd811c4cc05e18878038449519875c0c"
    sha256 cellar: :any,                 x86_64_linux:  "50b1ca096c8c7e96ae48c73241343bd87f8eef891835152215e02dd156654096"
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

    shell_output("#{bin}/comchan --generate-config")

    config = if OS.mac?
      testpath/"Library/Application Support/comchan/comchan.toml"
    else
      testpath/".config/comchan/comchan.toml"
    end
    assert_path_exists config
    assert_match 'port = "auto"', config.read
  end
end
