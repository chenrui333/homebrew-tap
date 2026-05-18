class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ef90b2be9e1fb3cbf870af06c55d5dd58df44747f3861553b0cb095e83ff80f3"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "137fbf9161e2197a59244f9aef26c5efa2611a91de78fa019851e7b0b4e3cf7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e55b1e6ff0861b69bc287e43b4220fae784848c9fc2d3b99fb4c8d4ec9de548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74298baaa521bdd17559ec804ed04f3eb6adc2b095840d6723b72226560c3140"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86f01ed8dc42dc5d08369d5346274a363785d819b44a782443c78f9a69408b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c163dc38207deac4dd44d3209c7b892f625d376f2f02ed8412d1e15280451a8"
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
