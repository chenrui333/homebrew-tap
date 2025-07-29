class FxUpscale < Formula
  desc "Metal-powered video upscaling"
  homepage "https://github.com/finnvoor/fx-upscale"
  url "https://github.com/finnvoor/fx-upscale/archive/refs/tags/1.2.5.tar.gz"
  sha256 "4ec46dd6433d158f74e6d34538ead6b010455c9c6d972b812b22423842206d8b"
  license "CC0-1.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e68c28fdcc75d05fa6512a0bdb566c0f1a3b0bdd4a162795b29c110ab7dd040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d829f696427be6e7dc4274dfe60e455df26526d43323eb656f7c2733b5ad57ee"
    sha256 cellar: :any_skip_relocation, ventura:       "15d54eead879ab66ab343b324731622aade25b94de0697a4e13bbcf1d8bd4142"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/fx-upscale"
  end

  test do
    cp test_fixtures("test.mp4"), testpath
    system bin/"fx-upscale", "#{testpath}/test.mp4"
    assert_path_exists "#{testpath}/test Upscaled.mp4"
  end
end
