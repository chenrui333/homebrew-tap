class Gloomberb < Formula
  desc "Extensive financial terminal, in your terminal"
  homepage "https://github.com/vincelwt/gloomberb"
  version "0.7.2"
  license "MIT"

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
