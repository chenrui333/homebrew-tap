class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "eb58a1327b39897500f5f5ccf97d47061cab2beaa71f54b73c9c4065bf556078"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6751a8f3f2788eea4dbb2574bf7e6270cf6409a5658c588ca1d54892b1d1d38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faead6659ff8ed38659df5e4f25d77073b573ba17b7fef429abbf037127033ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a8f4ae5b31ffcb28c5fc1898b5e6bef5801fab6ab9fbc3548f4bed6d41eaefe"
    sha256 cellar: :any,                 arm64_linux:   "9aebfb36d3c97d62aec94f50471d0528c38a3988bd151d85bc370b6dffd52749"
    sha256 cellar: :any,                 x86_64_linux:  "c68122ea1d96e66168ebe6e7bd09cfaa3dbd1b76fede16d0f5d436eb8b2f8672"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/obelisk --version")
    output = shell_output("#{bin}/obelisk --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
