class Mlbt < Formula
  desc "TUI for MLB stats API"
  homepage "https://github.com/mlb-rs/mlbt"
  url "https://github.com/mlb-rs/mlbt/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "a0ff8d51c1294c05a3fa7bed81f80f44562fb344020d88fc0c7ed94711934da1"
  license "MIT"
  head "https://github.com/mlb-rs/mlbt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc22e96f7190e865918ce7d91a64ee781129a456a3bc27e316a2634d17a7614b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ef6a0b21fe0fbfc9b433de26d9376200cf0ac90322f04253ea326881db3e399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0be45eac7e45e3de5e814d43c0285e8ed2fbf80fbfb2727b0a9bda37af06aecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "095505a1d09f54de9f888947b7c2adcc19d2aae685b9e9a8bc55db12002d7e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "016a261be494a4e3f5e5b89255c2e9000b03a7fece2c9377c7d47a22e0ed9f81"
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
