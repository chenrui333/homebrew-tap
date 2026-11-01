class Auv < Formula
  desc "Inspectable command-line computer-use automation"
  homepage "https://github.com/moeru-ai/auv"
  url "https://github.com/moeru-ai/auv/archive/refs/tags/v0.0.39.tar.gz"
  sha256 "a90cc5862cb86f9ef2db6b04acada807895a954ea07be0c0dfceb2ef1b712bdc"
  license all_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/moeru-ai/auv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10e0d2d15e3e3a3ac4e48dcf4686877a414038a4ab2cd11b5e83e2e3c72f2f69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52b613e7c09864eb7793992ed8c942f357d5ad7cf3812474e5dceb0785519cf5"
    sha256 cellar: :any,                 arm64_linux:   "6609d84a7bca069f3e7b428462454753d48a9e6b251f60f7c126182cf6e769ad"
    sha256 cellar: :any,                 x86_64_linux:  "f6c53cbcc51a1c15309bc1c0432c313af2bebb8c03b269f7c0bd3afacd9d102f"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on macos: :ventura
  end

  on_linux do
    # Locked bindgen 0.69 emits incomplete SPA structs with libclang 22+.
    # https://github.com/rust-lang/rust-bindgen/issues/3275
    depends_on "llvm@21" => :build
    depends_on "dbus"
    depends_on "leptonica"
    depends_on "libxcb"
    depends_on "libxkbcommon"
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "pipewire"
    depends_on "tesseract"
    depends_on "wayland"
  end

  resource "mediaremote-adapter" do
    url "https://github.com/ungive/mediaremote-adapter/archive/3ac3d4bdf862c7b5399b4fba4df5689f5c38609a.tar.gz"
    sha256 "111e285e7a8acfb05b7339883e303a360f8a7a9b7acb4f0f5c01b647deb8ceb5"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["CMAKE_GENERATOR"] = "Ninja"
    ENV["CMAKE_BUILD_PARALLEL_LEVEL"] = ENV.make_jobs.to_s
    ENV["CARGO_BUILD_JOBS"] = ENV.make_jobs.to_s
    if OS.mac?
      adapter_path = buildpath/"crates/auv-media-macos/vendor/mediaremote-adapter"
      resource("mediaremote-adapter").stage adapter_path
      (pkgshare/"licenses/mediaremote-adapter").install adapter_path/"LICENSE"
    else
      ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm@21").to_s
    end
    system "cargo", "install", *std_cargo_args(path: "crates/auv-cli"), "--bin", "auv"
  end

  def caveats
    <<~EOS
      This is the source-built CLI and foreground daemon. It does not include
      the separately signed AUV Helper.app or application-specific plugins.
      Grant desktop capture/accessibility permissions through your OS only
      when you choose to use those features; no permissions are granted here.
    EOS
  end

  service do
    run [opt_bin/"auv", "serve", "--store-root", var/"auv"]
    keep_alive true
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/auv --version")
    # This policy rejection occurs before listeners/providers initialize; no device/media access is made.
    output = shell_output("#{bin}/auv serve --local-auth-allowed-methods launcher-token 2>&1", 1)
    assert_match "requires --exit-on-stdin-close", output
  end
end
