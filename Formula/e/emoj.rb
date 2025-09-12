class Emoj < Formula
  desc "Find relevant emoji from text on the command-line"
  homepage "https://github.com/yeoman/emoj"
  url "https://registry.npmjs.org/emoj/-/emoj-4.2.0.tgz"
  sha256 "14901233fcf52543cd51bf4a6355a7ada69afdd8212a004fa90ea75b17d26383"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98a6984b2ca15a444d0b47a0abe6ef88489f343b6fc95fd981c5341f0d606255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0339c1e94af5f3eb9b6654494b972c6ab849384cf7a7dbacbc92ef906a951759"
    sha256 cellar: :any_skip_relocation, ventura:       "2e7fdc05733738d8542be01522914283035316aef808cfae22b9c441c440326f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12f79b7cecd53098f8467bead2caf2eb25bd160f1b447a81e9ca2aeb6ddf7d3a"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/emoj"

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/emoj --version")
    assert_match "🦄", shell_output("#{bin}/emoj unicorn")
  end
end
