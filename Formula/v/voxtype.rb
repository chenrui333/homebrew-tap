class Voxtype < Formula
  desc "Push-to-talk local voice transcription for Linux and macOS"
  homepage "https://voxtype.io/"
  url "https://github.com/peteonrails/voxtype/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "3b5f3d05734319737eb6711cd29b561e02c90863ad47d4451fd6f8a1c5e04947"
  license "MIT"
  head "https://github.com/peteonrails/voxtype.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85f76f4b722e1671753fb18a3f2a91a7837d3f4fb69095d75e62f3ed6ecc7ce1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "811a364473e5e8497929269f24b3b6ea50dc331f465f1ada42d6eb1455ee5e53"
    sha256 cellar: :any,                 arm64_linux:   "48a6c9e2df2dea25e136a422ae38fd1b263537d61a57602d15612a310fa6298d"
    sha256 cellar: :any,                 x86_64_linux:  "ab5ee44d49f308d98034bf533bd12b13e3cdb96e20113ae09ae3b5f101b70c2b"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"

  on_macos do
    depends_on macos: :ventura
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libnotify"
    depends_on "openssl@3"
    depends_on "wl-clipboard"
    depends_on "wtype"
    depends_on "xclip"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Keep openssl-sys on the declared OpenSSL 3 rather than a build dependency's OpenSSL 4.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3") if OS.linux?
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s
    ENV["ORT_LIB_LOCATION"] = formula_opt_lib("onnxruntime").to_s
    ENV["ORT_PREFER_DYNAMIC_LINK"] = "1"
    system "cargo", "install", *std_cargo_args, "--bin", "voxtype", "--features", "parakeet"
    bash_completion.install "packaging/completions/voxtype.bash" => "voxtype"
    zsh_completion.install "packaging/completions/voxtype.zsh" => "_voxtype"
    fish_completion.install "packaging/completions/voxtype.fish"
    man1.install Dir["target/release/build/voxtype-*/out/man/*.1"]
  end

  def caveats
    <<~EOS
      Run `voxtype configure` to choose settings and download a speech model.
      This source build includes CPU Whisper and Parakeet, using system ONNX
      Runtime. Optional CUDA, Vulkan, Metal, and OSD frontends are not built.
      macOS support is upstream beta. Grant microphone and Input Monitoring
      permissions yourself when using dictation; installation does not alter
      permissions, signatures, or quarantine settings.
      Linux alternative eitype/dotool/ydotool drivers require separate setup;
      uinput device access and helper daemons remain operator-managed.
    EOS
  end

  service do
    run [opt_bin/"voxtype", "daemon"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/voxtype --version")
    # Persisted recording state must not masquerade as a live dictation daemon.
    (testpath/"state").write "recording\n"
    (testpath/"config.toml").write "state_file = \"#{testpath}/state\"\n"
    ENV["XDG_RUNTIME_DIR"] = testpath.to_s
    assert_equal "stopped", shell_output("#{bin}/voxtype --config #{testpath}/config.toml status").strip
  end
end
