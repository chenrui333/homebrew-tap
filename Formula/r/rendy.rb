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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e40d00ecc7a8c545da9bbf53641560aeb9482f746fdcbcd21e82be00880a8f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e40d00ecc7a8c545da9bbf53641560aeb9482f746fdcbcd21e82be00880a8f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e40d00ecc7a8c545da9bbf53641560aeb9482f746fdcbcd21e82be00880a8f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4fc8807b5c4d31f9cd860ea3ce184c11ad6bca81dfdabb490716cfbbd9a8deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e79a1c93eb783fb510af844d64ec929b04c44f9eeb17d237b7c8ad8d7555356"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/rendy 2>&1", 1)
    assert_match "open models/gun.obj", output
  end
end
