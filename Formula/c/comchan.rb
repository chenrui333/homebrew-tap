class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f66667621b7251a92803633e6c2b18747b32a45a04d0d0e892e6483c5e65ea86"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d70c1409033dda8f3e5b6180b6eb3f5623f622dc8e816765b6a9527dbc5b5db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "855f5d5d497574ce9c2ab2f53ba040c7d0c58214fa7ff83d288ea556d751df3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "684bfa927054346f5b30e77cdea3f4084bf39d36bd912a9acca9888dd55a02f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bd0c1a854057fd7c497a6cd9876b89bdc225d0af748ea0d6587fc90b59db439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe1b3c811d8841f52f91e18671ccd05502fe4a83a3c7b1261571aa7ad2c3cd1c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
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
