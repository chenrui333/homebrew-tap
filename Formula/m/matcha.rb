class Matcha < Formula
  desc "Daily Digest Reader"
  homepage "https://github.com/piqoni/matcha"
  url "https://github.com/piqoni/matcha/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "239f97bed3014c8809d3d70c7840b77985c7cd12dc73510ae7a2fe3f557a0e1d"
  license "MIT"
  head "https://github.com/piqoni/matcha.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68685811773e40cdb2dec345be36e80617b41c0097006e678184ac6bc2c0c6ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68685811773e40cdb2dec345be36e80617b41c0097006e678184ac6bc2c0c6ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68685811773e40cdb2dec345be36e80617b41c0097006e678184ac6bc2c0c6ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e56743ffd43c97f03f029e315ec3b4aa5b5474db2c4b695101431b7784dd84c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d2398be59d2aeeacf0f0795e6ac7cf27bcdfb535a72f2759a7146c1ce3af7dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"matcha"
    assert_match "markdown_dir_path", (testpath/"config.yaml").read
  end
end
