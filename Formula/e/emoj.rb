class Emoj < Formula
  desc "Find relevant emoji from text on the command-line"
  homepage "https://github.com/yeoman/emoj"
  url "https://registry.npmjs.org/emoj/-/emoj-4.1.0.tgz"
  sha256 "18ef4b06e9ab7dff8dfb15257bf6e9110d3c6842fa0285728d9e4e3c0a0ad298"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dc3fa3b0f4251f4d20886334a9bbe160b195e3ecc4d3af475c5a33ebbf0daa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3a9a0f4c4c76caafa319e4238e4fe49175ef44b3c8eeafc08af0c155f5e67d0"
    sha256 cellar: :any_skip_relocation, ventura:       "1ea4d68ffdf59c8d2b26d7878ac5240c4ab04f8cc3e240f0d68ec70bcc0a7ca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b32b443c969b5cc8f13f504eda6380244793320e037d82dc655ee66a7f54ea9"
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
