class Lazycli < Formula
  desc "Turn static CLI commands into TUIs with ease"
  homepage "https://github.com/jesseduffield/lazycli"
  url "https://github.com/jesseduffield/lazycli/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "66f4c4c5bedf4d3ceb35aebc1d7f18663c7250ac47241fea18108c0741bf2019"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "990118766cfd3ec37e9c44f50d1c64b5330001e19fd1309c5d287c5eb2e9eb95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43e22c022fa5c60d9e73144e4f060b433304cabdbbaa3338d1cdfd59d771bd1b"
    sha256 cellar: :any_skip_relocation, ventura:       "a5404c8f84df2bde35819f09c52d3f8c718817c17d740fab8438b358fd91e27c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef4af19ed42b1a37cacbb1daa9c8cdad4724d61c3471751c6b45334eab93db24"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/lazycli --version")

    # Fails in Linux CI with `No such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"lazycli", "--", "ls", "-l", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "No profile selected", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
