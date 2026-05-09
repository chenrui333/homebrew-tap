class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "bf8f8923ce7e7459165a828c153f1dc46347c446139f767249abb1746b3fddfd"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dc30343c035d76586e46e1a061970eae0d874434cd9763aa11493e6a3dace85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3feac5a9c48481d563ff98c921586013943b24e1fd79b9dcd69ad3ef1e686374"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7bbd0ec3c4869b404258632d327ae79f50bd9b1b9e481532dd13c42bbda282f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "405407c63ebe5c7ac1f57760d9f982451f91fdfe7a4727bcb4757752b043fc23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "091773d0a93d258fc9ca70fd221551d490dd0ecba55ee9f2e604dad1f2304868"
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
