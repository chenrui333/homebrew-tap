class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "ff59e1a02c42e52fae4090443c5d9fc7bdec3ab0357598f514b8d811e8de318a"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eea7d938247805b3cc93d654c5e2898bebebb046ebab537a4039509376b513c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03fb14792921be7d4e4cb00388fc19be8ec47145cf151e2ddd78d91523bca742"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "deaf8ab4e3f19852384904669e76db02e797fee8c451c46ab9f687a3c390f808"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cab226ac35da7ae0fb255a90d76f81f6de18298d7c1b5758b4c52599f4adbee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74c435fa3fadb70b17c88659de40bf7c311fb5697f99e6f5d1706251b15cd58d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
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
