class Mlbt < Formula
  desc "TUI for MLB stats API"
  homepage "https://github.com/mlb-rs/mlbt"
  url "https://github.com/mlb-rs/mlbt/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "dee9070332edf3a3308c8db69fa7302173806931fd06a97010ad67a25181dfbf"
  license "MIT"
  head "https://github.com/mlb-rs/mlbt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bce2f4489f58d7c81fe5a0d03d6cdbbd7640bcc1600f11ef8a566c8e59f1c89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b001a800a803ac37b1a0a390eff2cb6f56324a388cd9eff2a48a151e077341cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18f6a8385b4148bef9188270b2aadac2fb55b21f5bab4afc11340c7d0a5f6c2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0660f4004c5ba4f7efb383046e17955e649f4d7d320c54a502d7ac66f672ba35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eca503b710aa0d788511fccbdef34de69c3c62017429198ed9bd06175959996"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"mlbt", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Gameday │ Stats │ Standings", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
