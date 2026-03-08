class Dotstate < Formula
  desc "Modern and secure dotfile manager"
  homepage "https://dotstate.serkan.dev"
  url "https://github.com/serkanyersen/dotstate/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "c6d0bb49be40186543451f67356581eab488f888188ddf84678feafeec19db27"
  license "MIT"
  head "https://github.com/serkanyersen/dotstate.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c087a88f6461d5f868ec126e4d4fad6a58a6a9297179b85bd42a9ca00f36d034"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81d73022c13b097dc93a45d6d4c9c5ca8bf1ec4c37c77a6e2c65d5b495b01991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f1b4d745ca3d7a9158fad2b5eda69b5c38f8926ef3a61aea96787fb5919aa18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1eb84a319bf97ccb81e9bfdc8ecb3956ac147a8605b844e493e43322349fa48e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00d5233bff1e6f4b7c6665ddd4926846d636636c10479d8212309a239804b3f4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@3"].opt_lib/"pkgconfig"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_LIB_DIR"] = Formula["openssl@3"].opt_lib
    ENV["OPENSSL_INCLUDE_DIR"] = Formula["openssl@3"].opt_include

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"dotstate", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dotstate --version")
    assert_match "_dotstate", shell_output("#{bin}/dotstate completions zsh")
  end
end
