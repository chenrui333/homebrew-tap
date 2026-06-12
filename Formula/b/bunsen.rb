class Bunsen < Formula
  desc "NixOS flake-inspired dotfiles manager for TypeScript"
  homepage "https://github.com/g4rcez/bunsen"
  url "https://github.com/g4rcez/bunsen/archive/1d0c191adc54e4c2ecf96c4f3f4c74d9a0de86fc.tar.gz"
  version "0.0.9"
  sha256 "2ef5e4737e39184b34c772bcd6c025910a829300f5172477469ff2fe8003a52a"
  license "MIT"
  head "https://github.com/g4rcez/bunsen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "cd4a076a94e5904bb3d1448e655368d212d8ee9e3de8decefff456ac06585256"
    sha256 arm64_sequoia: "b4960edf2ccc5966461a126846bb0146fabc7c9a8fce29ee3e26376d35ba7682"
    sha256 arm64_sonoma:  "0a64890f2cdeafba12571e5879e1e91b7df7d740b81e568a594dc9a344131789"
  end

  depends_on "homebrew/core/bun" => :build
  depends_on :macos

  def install
    inreplace "src/cli/index.ts", ".version('0.0.0')", ".version('#{version}')"
    system "bun", "install", "--frozen-lockfile"
    system "bun", "run", "compile"
    bin.install "bin/bunsen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bunsen --version")

    system bin/"bunsen", "init"
    assert_path_exists testpath/"dotfiles.config.ts"
    assert_match "defineConfig", (testpath/"dotfiles.config.ts").read
  end
end
