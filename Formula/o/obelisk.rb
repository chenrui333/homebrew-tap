class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "230189a51f4290db37fe84cf088765328f5cfa7d4fd99118a3e5ec44ed3b4cec"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4d3d4a1df4013e1eab7ec253a55b47f9d65a5f9fe74a788b6baf169de0b5d7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61ae9a9e61ac49eddc666e1667754cacf78ed2340349d75ec1ebb61802d16704"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8921378bc91f5555fce82361dff2998629e8040a3b79acb011980de79b730f32"
    sha256 cellar: :any,                 arm64_linux:   "4d402da91c3aaaf27008f336cebfc526ec1c483e066c5da1227dbbb6868abe83"
    sha256 cellar: :any,                 x86_64_linux:  "3f7f455952bf54b1903da094e551c766eda0199421b7ae5eb9ab7c289bde8057"
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
