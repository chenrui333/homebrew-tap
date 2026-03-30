class Mlbt < Formula
  desc "TUI for MLB stats API"
  homepage "https://github.com/mlb-rs/mlbt"
  url "https://github.com/mlb-rs/mlbt/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ef28455431ad0d68cbe80dbdcde06aefe362eb96e1d4f4bcc09a3eca26a0b385"
  license "MIT"
  head "https://github.com/mlb-rs/mlbt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec4b330ab789ac4a2f41b3978f49bfd18a15ec1d50a96af29a8354db6ad070b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ecb2d7f490748ea93d51b83d4da95596335d992ad3036ef4332fcc9872002b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "503ac538093a8a65e1444f9e9c5af6287a48a4ec0bd9ab022edc55f7f8c3b86d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41ba3bb30b2eb016a737b89f04256ef8066fd4377901cc8b0cb10539eb4e547d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c370b5b578a20362d1dba4e6dd06e87c70beff8cfd40b8ad49987892c5e56bc5"
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
