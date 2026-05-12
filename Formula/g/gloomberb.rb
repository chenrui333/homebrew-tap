class Gloomberb < Formula
  desc "Extensive financial terminal, in your terminal"
  homepage "https://github.com/vincelwt/gloomberb"
  version "0.7.2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0b17f6ca397c3206fa206074e4895e446d425743e91dcf9adb73634326786807"
    sha256                               arm64_sequoia: "0b17f6ca397c3206fa206074e4895e446d425743e91dcf9adb73634326786807"
    sha256                               arm64_sonoma:  "0b17f6ca397c3206fa206074e4895e446d425743e91dcf9adb73634326786807"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f68437e19c2c79b0e6fa8cc467ec65d2a18eb4a632f2590d81f325a3f3d15fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31da9ea143e597aa4b626debdaf3fa2ee09a4f789b3461b7015fb05f70a43908"
  end

  on_macos do
    on_arm do
      url "https://github.com/vincelwt/gloomberb/releases/download/v#{version}/gloomberb-darwin-arm64.gz",
          using: :nounzip
      sha256 "2c9fc51ea92f29d70402bd7fb402025cec6f2ea7adac3de9e2f1b00bd8564995"
    end

    on_intel do
      url "https://github.com/vincelwt/gloomberb/releases/download/v#{version}/gloomberb-darwin-arm64.gz",
          using: :nounzip
      sha256 "2c9fc51ea92f29d70402bd7fb402025cec6f2ea7adac3de9e2f1b00bd8564995"
      disable! date: "2025-05-12", because: "no macOS x86_64 binary; use Rosetta 2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vincelwt/gloomberb/releases/download/v#{version}/gloomberb-linux-arm64.gz",
          using: :nounzip
      sha256 "784b6f0c0a65fe68da9ff7d7e31d67e6cb1c67dce50631a43e1a85f4c7f0e24f"
    end

    on_intel do
      url "https://github.com/vincelwt/gloomberb/releases/download/v#{version}/gloomberb-linux-x64.gz",
          using: :nounzip
      sha256 "e78abe6504a64430d81a88ac628e63aec0efdb7ca0a9a3171ef59ecad452f7fe"
    end
  end

  def install
    gz = Pathname.glob("*.gz").first
    system "gunzip", gz
    binary = gz.basename(".gz")
    binary.chmod(0755)
    bin.install binary => "gloomberb"
  end

  test do
    assert_match "gloomberb", shell_output("#{bin}/gloomberb help 2>&1")
  end
end
