class Rendy < Formula
  desc "Terminal-based ASCII renderer for 3D models"
  homepage "https://github.com/tokyohardrock/rendy"
  url "https://github.com/tokyohardrock/rendy/archive/fad82c6f7934ab07b663285e77c6499f445232a8.tar.gz"
  version "0.0.0"
  sha256 "dbc0af17151f183f8f4b4bb446301ec1cbd9b45d653b760c29e4fd1d5cbfd221"
  license "MIT"
  head "https://github.com/tokyohardrock/rendy.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/rendy 2>&1", 1)
    assert_match "open models/gun.obj", output
  end
end
