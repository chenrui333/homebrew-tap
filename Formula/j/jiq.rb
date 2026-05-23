class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.24.0.tar.gz"
  sha256 "8b14ee66aa61e0a264a0cbdebd46511308a8d4d35bba2801ffc959c48098c247"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7342d7e354519b4c81e3a070dc238f3e06bf2c4edd3d34bb6f70b09a696c235"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f04fa01ad240dc06fd6ee5f4a72eb0c0b6b28890d05f5b77f3d8b690567f3cdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01a99d58a65f840650f5a9f9128f31074c6dcbc706f5b5e45d4363e42c9848e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c546789cb0542c169378dc74de824d4a1d9c4e6cddc7807ed080cd9af336b153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dfe8c3540cb7a3701519d6c61af649418497caf61f9a4334284a59ffdccb87e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiq --version")

    (testpath/"data.json").write("{}\n")
    empty_path = testpath/"empty"
    empty_path.mkpath
    output = shell_output("PATH=#{empty_path} #{bin}/jiq #{testpath}/data.json 2>&1", 1)
    assert_match "jq binary not found in PATH.", output
  end
end
