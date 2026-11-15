class Voxtype < Formula
  desc "Push-to-talk local voice transcription for Linux and macOS"
  homepage "https://voxtype.io/"
  url "https://github.com/peteonrails/voxtype/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "59d5ebb3450e47418716f4168a3c21d85056b09c8762bc0aa0c55953bfd62bc2"
  license "MIT"
  head "https://github.com/peteonrails/voxtype.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83f30eeda0287a50ad1c67bb97a31db576e6db2cba81ecd74967eefee89bb69c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8778c9e6282a9657584f3b460c94f16a76530cc668c3129a081c15f9f6c4afa2"
    sha256 cellar: :any,                 arm64_linux:   "f27cab89f7128a19a65e1f857ebf15b4a012cbd15ca0a7313a29797b36506e78"
    sha256 cellar: :any,                 x86_64_linux:  "8698dfc827f0808b5ad81ed556657708173395e67197b7cfb023e4624fac7d84"
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
