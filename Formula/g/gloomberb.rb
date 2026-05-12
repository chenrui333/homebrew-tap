class Gloomberb < Formula
  desc "Extensive financial terminal, in your terminal"
  homepage "https://github.com/vincelwt/gloomberb"
  version "0.7.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vincelwt/gloomberb/releases/download/v#{version}/gloomberb-darwin-arm64.gz",
          using: :nounzip
      sha256 "ec551f50649486fbf4f0cc506d727d770e8a4ad49a8de8fd3dff4d208dc94586"
    end

    on_intel do
      url "https://github.com/vincelwt/gloomberb/releases/download/v#{version}/gloomberb-darwin-arm64.gz",
          using: :nounzip
      sha256 "ec551f50649486fbf4f0cc506d727d770e8a4ad49a8de8fd3dff4d208dc94586"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vincelwt/gloomberb/releases/download/v#{version}/gloomberb-linux-arm64.gz",
          using: :nounzip
      sha256 "f538285aa84872fa1fa2ad388b217152ceda4cf7f2f003b4ec3cff8bd31e5187"
    end

    on_intel do
      url "https://github.com/vincelwt/gloomberb/releases/download/v#{version}/gloomberb-linux-x64.gz",
          using: :nounzip
      sha256 "c57a197ecc6c94fa84456093247902931379a82580e7a2e62de5d52078e3967a"
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
