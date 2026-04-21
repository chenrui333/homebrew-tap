class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "8647ca415638ba9f4134a53669489e1ff7bee1cfc3fd89bfef2ad40a546fac44"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cfeb1bc47d51a4d9dadfbc81f8c8096cb1af7bd8b041316087fad96e5a8dccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b0a1b52d0830e14eae0aa0f92d29abbd8dc4ac3548c1cae75ebaffa2db02fde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d89378aeb300535e956f984444fd34815f4815e867b769215ebb1c1046c6ecc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e9e80abd641f335c4a6033f60804c344e831a70df5fae55cf5b69dc84bb7ac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8710a4e5fae841ffb56d5be441f90beec39bfa062fc47af5e5e235916f568b53"
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
