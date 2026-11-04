class Auv < Formula
  desc "Inspectable command-line computer-use automation"
  homepage "https://github.com/moeru-ai/auv"
  url "https://github.com/moeru-ai/auv/archive/refs/tags/v0.0.43.tar.gz"
  sha256 "8224630a6e451f3970fb1d7b363667491dab8f1eec1ae7d19ab1fe9c7b506781"
  license all_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/moeru-ai/auv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4f349bd0c795c06ddda500191c0a2079c3e7ad18aa9f470d1a5160631024aeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ea8cc2275a9739a15026fd3d2cfa447a65c76b72e5bf44c1b7aa72f8fadd7f5"
    sha256 cellar: :any,                 arm64_linux:   "653a20e07fe83ed50c712cc2752dbec710d9c3656a7762f264742f2f22e1c729"
    sha256 cellar: :any,                 x86_64_linux:  "8c04b674bcf5d50f1f98c9abc947e105bdd4cfaf32a28b220612fb65ab78e596"
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
