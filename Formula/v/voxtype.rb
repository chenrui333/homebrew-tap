class Voxtype < Formula
  desc "Push-to-talk local voice transcription for Linux and macOS"
  homepage "https://voxtype.io/"
  url "https://github.com/peteonrails/voxtype/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "3b5f3d05734319737eb6711cd29b561e02c90863ad47d4451fd6f8a1c5e04947"
  license "MIT"
  head "https://github.com/peteonrails/voxtype.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88271f7494f5f4f0e80ee11168b2743d49f2a6da89a885d3198007416d013e1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "115bb2b3a885a0aa2900288a94f66f85dcea39ebac5030fe9fdd042b557b3abf"
    sha256 cellar: :any,                 arm64_linux:   "bb2ab64f31614b3147c0e0db65ab1ba0091804ff8d4a09cab3a83a4cef062f81"
    sha256 cellar: :any,                 x86_64_linux:  "f7c408a6f68f1cff0d40f2b185d83095ce5a0dfc1698cb69751d11ae752ed4de"
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
