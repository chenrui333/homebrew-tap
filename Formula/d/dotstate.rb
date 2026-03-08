class Dotstate < Formula
  desc "Modern and secure dotfile manager"
  homepage "https://dotstate.serkan.dev"
  url "https://github.com/serkanyersen/dotstate/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "c6d0bb49be40186543451f67356581eab488f888188ddf84678feafeec19db27"
  license "MIT"
  head "https://github.com/serkanyersen/dotstate.git", branch: "main"

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
