class Tortuise < Formula
  desc "Terminal-native 3D Gaussian splatting viewer"
  homepage "https://github.com/buildoak/tortuise"
  url "https://github.com/buildoak/tortuise/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "e48d388823512bdaad4801736e8b9966141dfb2cea353e43f6885e9267377d42"
  license "MIT"
  head "https://github.com/buildoak/tortuise.git", branch: "main"

  depends_on "rust" => :build

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
