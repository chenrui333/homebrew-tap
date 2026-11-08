class Tincan < Formula
  desc "Serverless peer-to-peer voice and text chat for your terminal"
  homepage "https://tincan.rs"
  url "https://github.com/bilalyazicioglu/tincan-cli/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "d7f548770114ced57d20917da7a147b73139013a4bc6e77c3b95f7a4b40ad550"
  license "MIT"
  head "https://github.com/bilalyazicioglu/tincan-cli.git", branch: "main"

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
