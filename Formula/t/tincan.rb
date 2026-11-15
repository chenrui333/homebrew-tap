class Tincan < Formula
  desc "Serverless peer-to-peer voice and text chat for your terminal"
  homepage "https://tincan.rs"
  url "https://github.com/bilalyazicioglu/tincan-cli/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "65b04d123d474a157ee881ab24d54b22c874790a481366d2ba1229b9d20e90b3"
  license "MIT"
  head "https://github.com/bilalyazicioglu/tincan-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2dbbdf60e715db92a7cc7151c295a8a273033fc58b5c4ea356d73792af18242"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c180e5afd55b1185a8dcb53cab4311bdf989e3247d5410198bc9a127914ac13d"
    sha256 cellar: :any,                 arm64_linux:   "78e50b911602f394c2e08bd39202e11abc764f2d39281dcf8529262cfb2509c0"
    sha256 cellar: :any,                 x86_64_linux:  "132bcae8a7efb5de3be9cd1c6fdbd61fd1ac8163c8969af55ede5634ea81c78c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  on_linux do
    depends_on "alsa-lib"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # audiopus_sys defaults to static Opus on macOS; select its shared-library feature.
    inreplace "Cargo.toml", 'audiopus = "0.2.0"', <<~TOML.chomp
      audiopus = "0.2.0"
      audiopus_sys = { version = "0.1.8", features = ["dynamic"] }
    TOML
    inreplace "Cargo.lock", ' "audiopus",', " \"audiopus\",\n \"audiopus_sys\","

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"tincan", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tincan --version")

    # The malformed invite is rejected before creating an endpoint or initializing audio.
    invite = (["1111"] * 13).join("-")
    output = shell_output("#{bin}/tincan join #{invite} --no-voice 2>&1", 1)
    assert_match "the invite code contains an invalid character", output
  end
end
