class Rendy < Formula
  desc "Terminal-based ASCII renderer for 3D models"
  homepage "https://github.com/tokyohardrock/rendy"
  url "https://github.com/tokyohardrock/rendy/archive/fad82c6f7934ab07b663285e77c6499f445232a8.tar.gz"
  version "0.0.0"
  sha256 "dbc0af17151f183f8f4b4bb446301ec1cbd9b45d653b760c29e4fd1d5cbfd221"
  license "MIT"
  head "https://github.com/tokyohardrock/rendy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7bffa2d420bf5e25203262bc2abd252e1c909a7349842862d41f4480add9876"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7bffa2d420bf5e25203262bc2abd252e1c909a7349842862d41f4480add9876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d646e825194495e6ac9b47f934840e148fe831b521a8e440ad9cbcd2f5db86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e6fa148d1c3055b662eb29607f8955b40472c95be14103e4995838d48bd5323"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/rendy 2>&1", 1)
    assert_match "open models/gun.obj", output
  end
end
