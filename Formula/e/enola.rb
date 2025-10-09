# framework: cobra
class Enola < Formula
  desc "Hunt down social media accounts by username across social networks"
  homepage "https://github.com/TheYahya/enola"
  url "https://github.com/TheYahya/enola/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "3d1e08662a2a535773379b24d40c542fac406318c8ea6db6d6c191dfd0f2f703"
  license "MIT"
  revision 1
  head "https://github.com/TheYahya/enola.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27663b53671a37eef8fdaa75d859a2833fe236afd02e9bcddffe70cc8cfbe96f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27663b53671a37eef8fdaa75d859a2833fe236afd02e9bcddffe70cc8cfbe96f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27663b53671a37eef8fdaa75d859a2833fe236afd02e9bcddffe70cc8cfbe96f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa880e5628fd7da963bdef79f081b9a4d7a2ec4d71f95b998c19fc8615d75c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0688efec3d683cb5e82da5745e2b71914da3927b2daf5ca99aed0d96c3ea5404"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/enola"
  end

  test do
    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    Open3.popen3("#{bin}/enola --site GitHub brewtest") do |stdin, stdout, _, w|
      stdin.close
      sleep 1
      Process.kill("TERM", w.pid)
      output = stdout.read
      assert_match "No items", output
    end
  end
end
