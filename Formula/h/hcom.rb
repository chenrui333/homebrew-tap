class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.22.tar.gz"
  sha256 "b256af1f2e9787ef7ea78d6463409e4343805243636107dd28a5dcfd2f55564f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5e2ec229655c185e52815daa9bdbac9229a6b7bece9be2f9b12abd2ca2d1372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1f1a9753d93c5515d8a3f597e7e8df54170c21d1815384c75c3e28c2c950bdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fdfe7dd345b2b2f4c29dc49baefafaeef239ad4cc3520f4512062c116c4e5c8"
    sha256 cellar: :any,                 arm64_linux:   "1bc942420edc13a4d17faee7dfa651bff808fa650af9c503b1e38990a3d39c48"
    sha256 cellar: :any,                 x86_64_linux:  "122d67aeb46d1a690890c9a1bfdbdaf5e2dacb3d38df31e3cdf48ec82ee544de"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
