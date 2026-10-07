class Tortuise < Formula
  desc "Terminal-native 3D Gaussian splatting viewer"
  homepage "https://github.com/buildoak/tortuise"
  url "https://github.com/buildoak/tortuise/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "e48d388823512bdaad4801736e8b9966141dfb2cea353e43f6885e9267377d42"
  license "MIT"
  head "https://github.com/buildoak/tortuise.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24b5b4db0f32298ea70be738b529470a66318c34612c49fe0444723b5bc6f300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a401e7c10758e1dbfb8d223671362b9b9d3fc783e80215fa317880a81ac6f36"
    sha256 cellar: :any,                 arm64_linux:   "b3b17ea6789b39c7c50da8e0c9fdad2c4f598726f79883074f89714e911f05e9"
    sha256 cellar: :any,                 x86_64_linux:  "ffcc600fb01e6e08dfc45511d1961e54189b35725b7a1d91d3afc12cec4afbf2"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tortuise --version")

    ENV["TERM"] = "xterm-256color"
    cmd = if OS.mac?
      "printf 'q' | script -q /dev/null #{bin}/tortuise --demo"
    else
      "printf 'q' | script -q -c '#{bin}/tortuise --demo' /dev/null"
    end

    output = shell_output(cmd)
    assert_match(/\e\[\?1049h/, output)
    assert_match(/\e\[\?1049l/, output)
  end
end
