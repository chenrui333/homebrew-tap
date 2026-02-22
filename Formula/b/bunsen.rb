class Bunsen < Formula
  desc "NixOS flake-inspired dotfiles manager for TypeScript"
  homepage "https://github.com/g4rcez/bunsen"
  url "https://github.com/g4rcez/bunsen/archive/1d0c191adc54e4c2ecf96c4f3f4c74d9a0de86fc.tar.gz"
  version "0.0.9"
  sha256 "2ef5e4737e39184b34c772bcd6c025910a829300f5172477469ff2fe8003a52a"
  license "MIT"
  head "https://github.com/g4rcez/bunsen.git", branch: "main"

  depends_on :macos

  on_macos do
    depends_on "bun" => :build
  end

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
