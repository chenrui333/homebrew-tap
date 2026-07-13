class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "a8991a6276d62ad9c513253e6cdb27300c51bc78757a2aa141fe8975d0dfaea7"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dad84eca0d556c806a799324ba23039d6de2fb6d4d0d4956d8d5cbded4b9451"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "611d806de15a1b1137194ed9dfb9d623f1381e192c4e047d882976c88a293d7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcfc5988925ccaab277e03532010b24bc3e6f6e7633b99566e07c18a9ab22db6"
    sha256 cellar: :any,                 arm64_linux:   "d47439601835420253aabd9c15b7523bb757fa8a8e153be351351b75e4827f36"
    sha256 cellar: :any,                 x86_64_linux:  "e6ce051bd9597384b50d55ef975a22f8e78f1861ac8282c7e28b019cdd1ee082"
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
