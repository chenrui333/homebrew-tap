class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "b4ef7d7dfbf2dcdf2a22ba4f4de356f8237f9252ccb69c7f2aab1e76191a8cb9"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

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
