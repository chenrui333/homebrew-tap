class Clauth < Formula
  desc "Multi-account manager and usage monitor for Claude Code"
  homepage "https://github.com/uwuclxdy/clauth"
  url "https://github.com/uwuclxdy/clauth/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "2f3efd3f27bbb714bda4eb18da92e56dfbe9088ffe00e4efbf63ab0c04f8ca99"
  license "MIT"
  head "https://github.com/uwuclxdy/clauth.git", branch: "mommy"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "214e3aaa274fdb80b96bef5eb5423c5c5fb221da7e4e5d7ff711f504670c5149"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b6a8d4d418d1a7a9c78f6126530fbabe135bcf061fa9d5a9d096e081b62c0a8"
    sha256 cellar: :any,                 arm64_linux:   "19938faff4b64e45e621c18dd9563848cfe99e29224bc506f60e230c1c56bd9f"
    sha256 cellar: :any,                 x86_64_linux:  "ae01ae97730be2fe9b4d5143742fbd55bd3c7be6ef9205fd8a7236ce5f2c3b21"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Homebrew manages upgrades, so disable the background self-updater.
    inreplace "src/update.rs", 'env::var(NO_UPDATE_ENV).as_deref() != Ok("1")', "false"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"clauth", "completions")
  end

  service do
    run [opt_bin/"clauth", "daemon", "--standby"]
    keep_alive true
    log_path var/"log/clauth.log"
    error_log_path var/"log/clauth.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clauth --version")
    assert_match "no accounts yet. add one with `clauth login <name>`.", shell_output("#{bin}/clauth list")
    assert_empty JSON.parse(shell_output("#{bin}/clauth jobs --json"))
  end
end
