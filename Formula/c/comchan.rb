class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ef90b2be9e1fb3cbf870af06c55d5dd58df44747f3861553b0cb095e83ff80f3"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94cbdf5578b16356da824cdf0e9e5b692b329246e68714c0836363bf34ec8450"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b8d5bec58f4bf0421c541cd4889ee4c4996340e970d405eaad2a7fec8217cf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61b4b6c60d26b3ab203e1ebaa94891b66c2230eb35cedf84734d741a102c8db3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9ec6cf7c8b46b8e64f4e0e9a68cdd35eb940bea32133101168812bd9c98e8e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3426e92d1cbae5046264c51e57ca63170ae87c809a9dc8f14b57e2f8f648fc5"
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
