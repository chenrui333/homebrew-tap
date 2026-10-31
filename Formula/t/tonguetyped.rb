class Tonguetyped < Formula
  desc "Local Linux dictation controlled from the terminal or a keyboard shortcut"
  homepage "https://github.com/cheerfulScumbag/tonguetyped"
  url "https://github.com/cheerfulScumbag/tonguetyped/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "e7e36f482b4e2651681f2804b33d7a7906564f3d62fb4e914d8a2a5c8d5e18b3"
  license "MIT"
  head "https://github.com/cheerfulScumbag/tonguetyped.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "shaderc" => :build
  depends_on "spirv-headers" => :build
  depends_on "vulkan-headers" => :build
  depends_on "alsa-lib"
  depends_on "libxkbcommon"
  depends_on :linux
  depends_on "onnxruntime"
  depends_on "openssl@3"
  depends_on "vulkan-loader"
  depends_on "wayland"
  depends_on "wl-clipboard"
  depends_on "wtype"
  depends_on "xclip"
  depends_on "xdotool"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s
    ENV["ORT_LIB_LOCATION"] = formula_opt_lib("onnxruntime").to_s
    ENV["ORT_PREFER_DYNAMIC_LINK"] = "1"
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
    system "cargo", "install", *std_cargo_args, "--features", "gpu-vulkan"
    bash_completion.install "target/release/dist/completions/tonguetyped.bash" => "tonguetyped"
    zsh_completion.install "target/release/dist/completions/_tonguetyped"
    fish_completion.install "target/release/dist/completions/tonguetyped.fish"
    man1.install Dir["target/release/dist/man/*.1"]
    pkgshare.install "data"
  end

  def caveats
    <<~EOS
      Run `tonguetyped setup` in your Linux desktop session to select and
      download a model. Models are not downloaded during installation or tests.
      X11 typing and wlroots Wayland typing helpers are installed. The optional
      dotool backend and desktop notification sounds are not bundled.
    EOS
  end

  service do
    run [opt_bin/"tonguetyped", "daemon"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tonguetyped --version")
    ENV["XDG_RUNTIME_DIR"] = testpath.to_s
    status = JSON.parse(shell_output("#{bin}/tonguetyped status --format json"))
    assert_equal "stopped", status.fetch("class")
    assert_match "daemon not running", status.fetch("tooltip")
  end
end
