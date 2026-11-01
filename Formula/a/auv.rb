class Auv < Formula
  desc "Inspectable command-line computer-use automation"
  homepage "https://github.com/moeru-ai/auv"
  url "https://github.com/moeru-ai/auv/archive/refs/tags/v0.0.40.tar.gz"
  sha256 "f235622ca95a105fb7590892f7fd5fcf69ceb1c5d9cf6ac583b7a8aa35a0c1df"
  license all_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/moeru-ai/auv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae48a09dbaaa5736bc6ef1e424a0e949d2e40cb28d308702d19a979dc7e335e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb9ede2d68d001520e58e82d55ce43181e0fdf9b9fda9375876208c29738b303"
    sha256 cellar: :any,                 arm64_linux:   "66e5bd906da44781f2b710c14fc1823fefabead21c59678a2f3308c52d022760"
    sha256 cellar: :any,                 x86_64_linux:  "3f5bd06122d86dfd98f7e1a924ba185a0b776b2fad49e2ea5cad96cb23cf0dec"
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
