class Jjj < Formula
  desc "Modal interface for Jujutsu"
  homepage "https://jjj.isaaccorbrey.com/"
  url "https://github.com/icorbrey/jjj/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "012d111279821ca9c34bdb5d2562f3241cd9cac83f1239e33fd59ded3f2daff3"
  license "MIT"
  head "https://github.com/icorbrey/jjj.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d34fbc07def1562736fa942c2a18cbda5c4948108c46a999debc032a8ef5dee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fad778bcad0971617061ae44d26bc3753bc3f0f2dec50726cc3856d3f4ee37f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c7537aed75cfd55583764fb5d657b8c3b8eb3639956f95815aae218becd3d68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13d89021a793f271dd4fc3d0d0afdab1a006e54d940c3dea64dfffb695b0911e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff7571cbd2d99cdbd116cbf3ec9743420d6d1067be936cf360b97904b9ab6110"
  end

  depends_on "rust" => :build
  depends_on "jj"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjj --version")

    # Fails in Linux CI with "No such device or address (os error 6)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"jjj", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "\e[?1049h\e[?u\e[c", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
