class Auv < Formula
  desc "Inspectable command-line computer-use automation"
  homepage "https://github.com/moeru-ai/auv"
  url "https://github.com/moeru-ai/auv/archive/refs/tags/v0.0.44.tar.gz"
  sha256 "5275f90f338460e9bfe1e746089202d9b64dd90cc0a9eef0e008842d3786bac6"
  license all_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/moeru-ai/auv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "c43c40e0f082ac6c07fffa295edcf864729c20750198bb567af045af10653ed8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bd74ff06256b7394d87d1ccba5cbcbe8a75ae5455f22bd7a1a826f1e0340466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6109bb219657bfa750e7405bd7a618d0e448bf1987279fce83198ad85b13083d"
    sha256 cellar: :any,                 arm64_linux:   "f8010d887ca6ccb1fda19b98175f9d349e71cc8409d3d768b1b0e63a333a78e2"
    sha256 cellar: :any,                 x86_64_linux:  "d1b84b3e840f8844248d1f8c4c932b7671362ae88fdc5991a1e827d0abad5469"
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
