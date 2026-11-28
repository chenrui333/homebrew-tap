class Voxtype < Formula
  desc "Push-to-talk local voice transcription for Linux and macOS"
  homepage "https://voxtype.io/"
  url "https://github.com/peteonrails/voxtype/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "c98cd433872e30de57c3b48756ec1177404f07ebd7f65a4bd9116d7310240841"
  license "MIT"
  head "https://github.com/peteonrails/voxtype.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "38d205e7bd4a2f74ad3b32d4b45a91b4a37fd070d58fc261d7d0fe7759a4ff56"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "704989185f7753c9237348a8bf746c5ebf929d04af0739fc861bfda1fea6e001"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60680af966a117ffb5f8b035401e23753b26067d0025975ca73a8735106419a6"
    sha256 cellar: :any,                 arm64_linux:   "3e1c71a6c6b5068efca84cfc474d35fb9ccc82def4778f82eaafea0701d9ce8c"
    sha256 cellar: :any,                 x86_64_linux:  "b99780207a83b72e9056a20db8b82a17b2dca5c7eea7c620ea2a984542dbe9cc"
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
