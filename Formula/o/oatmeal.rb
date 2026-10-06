class Oatmeal < Formula
  desc "TUI to chat with large language models"
  homepage "https://github.com/dustinblackman/oatmeal"
  url "https://github.com/dustinblackman/oatmeal/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "dee11f69eabc94adeb58edc5ecf5b51556bd4dec3a6a3d66c3a5e603aa8a0256"
  license "MIT"
  head "https://github.com/dustinblackman/oatmeal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c96076f96f9fa52a79de8eeef2d8a7d9e387f5d01f42abb971003bb546f3e6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb654d9a9b2bf8374d8c30e07fa493e8f9c222b3b9be4982e129d986ca4ff905"
    sha256 cellar: :any,                 arm64_linux:   "fe367ec14111f259bda76ac5f7a1b931b6f789d4442dd772cd7c1b8f2c2e5de6"
    sha256 cellar: :any,                 x86_64_linux:  "804b1e9a7731cf026eb91431a4da13e7c87703ca61e733925ba18bf00900c67c"
  end

  depends_on "rust" => :build

  # Syntax and theme sources pinned in `assets.toml`; build.rs downloads them unless pre-staged.
  resource "sublimehq-packages" do
    url "https://github.com/sublimehq/Packages/archive/759d6eed9b4beed87e602a23303a121c3a6c2fb3.tar.gz"
    sha256 "dd08752ec33febae3486f4a3f2ae9fcb41205377bd8cae0d812fa2a6a53ba0d6"
  end

  resource "sharkdp-bat" do
    url "https://github.com/sharkdp/bat/archive/7658334645936d2a956fb19aa96e6fca849cb754.tar.gz"
    sha256 "2b675dbb414df85c4daa82b5985d46e14fd4100b8cd15cc01710118b55d2b3ee"
  end

  resource "dncrews-graphql-sublimetext3" do
    url "https://github.com/dncrews/GraphQL-SublimeText3/archive/9b6f6d0a86d7e7ef1d44490b107472af7fb4ffaf.tar.gz"
    sha256 "6712c9ab2e2d51cf8a36c2e1c0f52c1bfba9bed481bed7fb7f1ebf96ffbab364"
  end

  resource "vcamx-protobuf-syntax-highlighting" do
    url "https://github.com/VcamX/protobuf-syntax-highlighting/archive/726e21d74dac23cbb036f2fbbd626decdc954060.tar.gz"
    sha256 "8dad4e622e3bcf5e8ae1f1a05d6fa86d83a38cbbb12653ed216b293a29f0fec6"
  end

  resource "ziglang-sublime-zig-language" do
    url "https://github.com/ziglang/sublime-zig-language/archive/1a4a38445fec495817625bafbeb01e79c44abcba.tar.gz"
    sha256 "d598341626c18784618a16a7ff34e2dcc26e40d001ea1618359c403fa4af2787"
  end

  resource "alexlouden-terraform-tmlanguage" do
    url "https://github.com/alexlouden/Terraform.tmLanguage/archive/54d8350c3c5929c921ea7561c932aa15e7d96c48.tar.gz"
    sha256 "bf6fcc484f2b48175349aec68251a6dfff8a1354f3378a355c9c7d308031c107"
  end

  resource "jasonwilliams-sublime-toml-highlighting" do
    url "https://github.com/jasonwilliams/sublime_toml_highlighting/archive/fd0bf3e5d6c9e6397c0dc9639a0514d9bf55b800.tar.gz"
    sha256 "0bf145d5fa6796e3bafd6b95524f5e8e64cf0552ac9276ba7b96860fef474e61"
  end

  resource "princemaple-elixir-sublime-syntax" do
    url "https://github.com/princemaple/elixir-sublime-syntax/archive/4fb01891dd17434dde42887bc821917a30f4e010.tar.gz"
    sha256 "83575ac646395c5ad011424e5f6f52509d61d3959d3e4209d4f3fd7a57debfe6"
  end

  resource "digitalcora-sublime-text-gleam" do
    url "https://github.com/digitalcora/sublime-text-gleam/archive/0b032f78c9c4aec1c598da1d25c67ca21fa8c381.tar.gz"
    sha256 "66ab9bcaed606561edf18e4ea07bba05b5d5e2bbf3389ff4bca8713f399416c0"
  end

  resource "chriskempson-base16-textmate" do
    url "https://github.com/chriskempson/base16-textmate/archive/0e51ddd568bdbe17189ac2a07eb1c5f55727513e.tar.gz"
    sha256 "f0151015d93d234d418692d1d8ac50461417e4df2ec8027779c62e70bfcd4ca5"
  end

  deny_network_access!

  def fetch
    system "cargo", "update", "-p", "time"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Mirror build.rs `download_files`: keep only the files selected in `assets.toml`.
    assets = {
      "sublimehq-packages"                      => ["syntaxes", %w[LICENSE */LICENSE */LICENSE.* */*.sublime-syntax]],
      "sharkdp-bat"                             => ["syntaxes", %w[LICENSE-MIT
                                                                   assets/syntaxes/02_Extra/*.sublime-syntax]],
      "dncrews-graphql-sublimetext3"            => ["syntaxes", %w[LICENSE *.sublime-syntax]],
      "vcamx-protobuf-syntax-highlighting"      => ["syntaxes", %w[LICENSE *.sublime-syntax]],
      "ziglang-sublime-zig-language"            => ["syntaxes", %w[LICENSE Syntaxes/*.sublime-syntax]],
      "alexlouden-terraform-tmlanguage"         => ["syntaxes", %w[LICENSE *.sublime-syntax]],
      "jasonwilliams-sublime-toml-highlighting" => ["syntaxes", %w[LICENSE *.sublime-syntax]],
      "princemaple-elixir-sublime-syntax"       => ["syntaxes", %w[LICENSE *.sublime-syntax]],
      "digitalcora-sublime-text-gleam"          => ["syntaxes", %w[LICENSE package/*.sublime-syntax]],
      "chriskempson-base16-textmate"            => ["themes", %w[
        LICENSE.md
        Themes/base16-{github,monokai,one-light,onedark,seti}.tmTheme
      ]],
    }
    assets.each do |name, (kind, globs)|
      dest = buildpath/"brew-assets"/kind/name
      resource(name).stage do
        globs.each do |glob|
          Pathname.glob(glob).each do |file|
            (dest/file.dirname).mkpath
            cp file, dest/file
          end
        end
      end
    end
    ENV["OATMEAL_BUILD_DOWNLOADED_SYNTAXES_DIR"] = buildpath/"brew-assets/syntaxes"
    ENV["OATMEAL_BUILD_DOWNLOADED_THEMES_DIR"] = buildpath/"brew-assets/themes"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"oatmeal", "completions", "--shell")
    (man1/"oatmeal.1").write Utils.safe_popen_read(bin/"oatmeal", "manpages")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oatmeal --version")
    output = shell_output("#{bin}/oatmeal config default")
    assert_match "# The initial backend hosting a model to connect to", output
  end
end
