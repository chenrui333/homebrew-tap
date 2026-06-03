class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "79d97241d9b74a82e35026cfbf8f12d4a1967f94fac3e332bb2578fbaea555a8"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9439320642a179d51e27425ca9adaf079029d23950e84254ebd5c0d35b5db8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9439320642a179d51e27425ca9adaf079029d23950e84254ebd5c0d35b5db8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9439320642a179d51e27425ca9adaf079029d23950e84254ebd5c0d35b5db8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "032470e4d7fead45711f14e88572ff2602b7e658a6a23b68e61c7fbe815639e7"
    sha256 cellar: :any,                 x86_64_linux:  "02ce1b7bece33c08fba645bb554016c53309a2995c6c5fe1cdafec32b2b2eae6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gpk"
  end

  test do
    assert_match "gpk #{version}", shell_output("#{bin}/gpk --version")
  end
end
