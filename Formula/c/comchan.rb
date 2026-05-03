class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "1e1b8788d2d2de5ab5685248355cb3b4e4ef41901b6735e2541ffeef0d99fab3"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d6d3f3c9386f2723dcef134e4fd7f9f01535c0dc914d0415cc8c8bbc4227059"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5d4f1095b6ff1465a2c5100eb3f4d274cb401c9aa04b609b931b6582dcf4107"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa41b042f4f64547891bd744d1db3d9e515df595de2ae49a8637758d16577f88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a34a194d615726d0df9616eaaa1c79e40760612edbe20937357f613d6b267bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f4fc18c11cea265dfd1f8580bbed2c6bc6f7195db6e0029b472d0181ed7b310"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
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
